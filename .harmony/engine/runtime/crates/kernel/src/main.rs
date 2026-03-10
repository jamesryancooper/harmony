mod context;
mod pipeline;
mod scaffold;
mod stdio;
mod workflow;

use clap::{Parser, Subcommand};
use harmony_core::errors::{ErrorCode, KernelError};
use harmony_core::tiers::validate_runtime_discovery_tiers;
use harmony_core::trace::TraceWriter;
use harmony_wasm_host::policy::GrantSet;
use std::process::Command as ProcessCommand;
use std::sync::Arc;

use crate::context::KernelContext;
use crate::pipeline::RunPipelineOptions;
use crate::workflow::ExecutorKind;

#[derive(Parser)]
#[command(
    name = "harmony",
    version,
    about = "Harmony executable runtime layer (v1)"
)]
struct Cli {
    #[command(subcommand)]
    cmd: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Print kernel info.
    Info,

    /// Service management and discovery.
    Services {
        #[command(subcommand)]
        cmd: ServicesCmd,
    },

    /// Invoke a service operation (one-shot).
    Tool {
        /// Service name or category/name.
        service: String,
        /// Operation name.
        op: String,
        /// Input JSON (default: {}).
        #[arg(long = "json")]
        json: Option<String>,
    },

    /// Validate services under .harmony/capabilities/runtime/services.
    Validate,

    /// Run the NDJSON stdio server.
    ServeStdio,

    /// Launch Harmony Studio desktop UI.
    Studio,

    /// Guest service scaffolding.
    Service {
        #[command(subcommand)]
        cmd: ServiceCmd,
    },

    /// Canonical workflow execution entry points.
    Workflow {
        #[command(subcommand)]
        cmd: WorkflowCmd,
    },
}

#[derive(Subcommand)]
enum ServicesCmd {
    /// List discovered services.
    List,
}

#[derive(Subcommand)]
enum ServiceCmd {
    /// Create a new service scaffold.
    New { category: String, name: String },

    /// Build a service (cargo-component) and update integrity hash.
    Build {
        /// Service category, or category/name.
        target: String,
        /// Service name (required only when target is category).
        name: Option<String>,
    },
}

#[derive(Subcommand)]
enum WorkflowCmd {
    /// List canonical workflows.
    List,
    /// Run a canonical workflow.
    Run {
        /// Canonical workflow id.
        workflow_id: String,
        /// Input override in the form key=value. Repeatable.
        #[arg(long = "set")]
        set: Vec<String>,
        /// Executor used for prompt stages.
        #[arg(long, value_enum, default_value_t = ExecutorKind::Auto)]
        executor: ExecutorKind,
        /// Optional explicit executor binary path.
        #[arg(long = "executor-bin")]
        executor_bin: Option<String>,
        /// Optional output slug override for the run bundle.
        #[arg(long = "output-slug")]
        output_slug: Option<String>,
        /// Optional model override.
        #[arg(long)]
        model: Option<String>,
        /// Materialize stage packets and reports without invoking executors.
        #[arg(long = "prepare-only", default_value_t = false)]
        prepare_only: bool,
    },
    /// Validate canonical workflows.
    Validate {
        /// Optional workflow id to validate semantically after collection checks.
        workflow_id: Option<String>,
    },
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();

    match cli.cmd {
        Command::Info => cmd_info(),
        Command::Services { cmd } => cmd_services(cmd),
        Command::Tool { service, op, json } => cmd_tool(&service, &op, json.as_deref()),
        Command::Validate => cmd_validate(),
        Command::ServeStdio => cmd_serve_stdio(),
        Command::Studio => cmd_studio(),
        Command::Service { cmd } => cmd_service(cmd),
        Command::Workflow { cmd } => cmd_workflow(cmd),
    }
}

fn cmd_info() -> anyhow::Result<()> {
    let ctx = KernelContext::load()?;
    println!("harmony kernel v{}", env!("CARGO_PKG_VERSION"));
    println!("repo_root: {}", ctx.cfg.repo_root.display());
    println!("harmony_dir: {}", ctx.cfg.harmony_dir.display());
    println!("state_dir: {}", ctx.cfg.state_dir.display());
    println!("os: {}", std::env::consts::OS);
    println!("arch: {}", std::env::consts::ARCH);
    println!("services: {}", ctx.registry.list().len());
    Ok(())
}

fn cmd_services(cmd: ServicesCmd) -> anyhow::Result<()> {
    let ctx = KernelContext::load()?;
    match cmd {
        ServicesCmd::List => {
            for svc in ctx.registry.list() {
                println!("{} @ {} ({})", svc.key.id(), svc.version, svc.dir.display());
            }
        }
    }
    Ok(())
}

fn cmd_validate() -> anyhow::Result<()> {
    let ctx = KernelContext::load()?;

    // Discovery already validates service.json schema and optional integrity hash.
    println!("discovered {} services", ctx.registry.list().len());

    for svc in ctx.registry.list() {
        println!("ok: {} @ {}", svc.key.id(), svc.version);
    }

    if let Some(report) = validate_runtime_discovery_tiers(&ctx.cfg.harmony_dir, &ctx.registry)? {
        println!(
            "runtime tiers ok: {} services ({} + {})",
            report.service_count,
            report.manifest_path.display(),
            report.registry_path.display()
        );
    } else {
        println!("runtime tiers: not configured (manifest.runtime.yml not found)");
    }

    Ok(())
}

fn cmd_tool(service_id_or_name: &str, op: &str, input_json: Option<&str>) -> anyhow::Result<()> {
    let ctx = KernelContext::load()?;

    let svc = ctx
        .registry
        .resolve_id(service_id_or_name)
        .ok_or_else(|| KernelError::new(ErrorCode::UnknownService, "unknown service"))?;

    // Policy gate.
    let caps = ctx.policy.decide_allow(svc)?;
    let grants = GrantSet::new(caps);

    let input: serde_json::Value = match input_json {
        Some(s) => serde_json::from_str(s).map_err(|e| {
            KernelError::new(ErrorCode::MalformedJson, format!("invalid --json: {e}"))
        })?,
        None => serde_json::json!({}),
    };

    let trace = TraceWriter::new(&ctx.cfg.state_dir, None).ok();
    let out = ctx
        .invoker
        .invoke(svc, grants, op, input, trace.as_ref(), None, None)?;

    println!("{}", serde_json::to_string_pretty(&out)?);
    Ok(())
}

fn cmd_serve_stdio() -> anyhow::Result<()> {
    let ctx = Arc::new(KernelContext::load()?);
    stdio::serve_stdio(ctx)
}

fn cmd_studio() -> anyhow::Result<()> {
    let harmony_dir = harmony_core::root::RootResolver::resolve()?;
    let runtime_dir = harmony_dir.join("engine").join("runtime");
    let manifest_path = runtime_dir.join("crates").join("Cargo.toml");
    let target_dir = harmony_dir
        .join("engine")
        .join("_ops")
        .join("state")
        .join("build")
        .join("runtime-crates-target");

    std::fs::create_dir_all(&target_dir)?;

    let status = ProcessCommand::new("cargo")
        .arg("run")
        .arg("--manifest-path")
        .arg(&manifest_path)
        .arg("-p")
        .arg("harmony_studio")
        .arg("--bin")
        .arg("harmony-studio")
        .current_dir(&harmony_dir)
        .env("CARGO_TARGET_DIR", target_dir)
        .status()?;

    if !status.success() {
        anyhow::bail!("harmony studio exited with status {}", status);
    }

    Ok(())
}

fn cmd_service(cmd: ServiceCmd) -> anyhow::Result<()> {
    let harmony_dir = harmony_core::root::RootResolver::resolve()?;
    match cmd {
        ServiceCmd::New { category, name } => {
            scaffold::service_new(&harmony_dir, &category, &name)?;
            println!(
                "created service scaffold at .harmony/capabilities/runtime/services/{category}/{name}"
            );
        }
        ServiceCmd::Build { target, name } => {
            let (category, name) = parse_category_name(&target, name.as_deref())?;
            scaffold::service_build(&harmony_dir, &category, &name)?;
            println!("built service and updated integrity: {category}/{name}");
        }
    }
    Ok(())
}

fn cmd_workflow(cmd: WorkflowCmd) -> anyhow::Result<()> {
    let harmony_dir = harmony_core::root::RootResolver::resolve()?;
    match cmd {
        WorkflowCmd::List => {
            for workflow_item in pipeline::list_pipelines_from_harmony_dir(&harmony_dir)? {
                println!(
                    "{} @ {} ({}, {})",
                    workflow_item.id,
                    workflow_item.version,
                    workflow_item.path,
                    workflow_item.execution_profile
                );
            }
        }
        WorkflowCmd::Run {
            workflow_id,
            set,
            executor,
            executor_bin,
            output_slug,
            model,
            prepare_only,
        } => {
            let input_overrides = parse_kv_overrides(&set)?;
            let result = pipeline::run_pipeline_from_harmony_dir(
                &harmony_dir,
                RunPipelineOptions {
                    pipeline_id: workflow_id,
                    executor,
                    executor_bin: executor_bin.map(Into::into),
                    output_slug,
                    model,
                    prepare_only,
                    input_overrides,
                },
            )?;
            println!("bundle_root: {}", result.bundle_root.display());
            println!("summary_report: {}", result.summary_report.display());
            println!("final_verdict: {}", result.final_verdict);
        }
        WorkflowCmd::Validate { workflow_id } => {
            pipeline::validate_pipelines_from_harmony_dir(&harmony_dir, workflow_id.as_deref())?;
            if let Some(workflow_id) = workflow_id {
                println!("validated canonical workflow: {workflow_id}");
            }
        }
    }
    Ok(())
}

fn parse_category_name(target: &str, name: Option<&str>) -> anyhow::Result<(String, String)> {
    if let Some((category, service)) = target.split_once('/') {
        if category.is_empty() || service.is_empty() {
            anyhow::bail!("invalid service id '{target}', expected <category>/<name>");
        }
        if name.is_some() {
            anyhow::bail!("do not pass a separate name when target is <category>/<name>");
        }
        return Ok((category.to_string(), service.to_string()));
    }

    let name = name.ok_or_else(|| {
        anyhow::anyhow!("missing <NAME>: expected `service build <CATEGORY> <NAME>` or `service build <CATEGORY>/<NAME>`")
    })?;
    if name.is_empty() {
        anyhow::bail!("service name cannot be empty");
    }

    Ok((target.to_string(), name.to_string()))
}

fn parse_kv_overrides(
    values: &[String],
) -> anyhow::Result<std::collections::HashMap<String, String>> {
    let mut out = std::collections::HashMap::new();
    for value in values {
        let (key, value) = value
            .split_once('=')
            .ok_or_else(|| anyhow::anyhow!("invalid --set value '{value}', expected key=value"))?;
        if key.is_empty() {
            anyhow::bail!("invalid --set key in '{value}'");
        }
        out.insert(key.to_string(), value.to_string());
    }
    Ok(out)
}

#[cfg(test)]
mod tests {
    use super::{Cli, Command, WorkflowCmd};
    use crate::workflow::ExecutorKind;
    use clap::{CommandFactory, Parser};

    #[test]
    fn cli_parses_studio_subcommand() {
        let cli = Cli::try_parse_from(["harmony", "studio"])
            .expect("studio subcommand should parse successfully");
        assert!(
            matches!(cli.cmd, Command::Studio),
            "parsed command should be Studio"
        );
    }

    #[test]
    fn cli_help_lists_studio_command() {
        let mut cmd = Cli::command();
        let mut help = Vec::new();
        cmd.write_long_help(&mut help)
            .expect("long help should render");
        let help = String::from_utf8(help).expect("help should be valid utf-8");
        assert!(
            help.contains("studio"),
            "help output should contain studio command"
        );
        assert!(
            help.contains("Launch Harmony Studio desktop UI"),
            "help output should include studio description"
        );
    }

    #[test]
    fn cli_parses_workflow_run_subcommand() {
        let cli = Cli::try_parse_from([
            "harmony",
            "workflow",
            "run",
            "audit-design-package",
            "--set",
            "package_path=.design-packages/orchestration-domain-design-package",
            "--executor",
            "mock",
            "--prepare-only",
        ])
        .expect("workflow run should parse successfully");

        match cli.cmd {
            Command::Workflow {
                cmd:
                    WorkflowCmd::Run {
                        workflow_id,
                        executor,
                        prepare_only,
                        ..
                    },
            } => {
                assert_eq!(workflow_id, "audit-design-package");
                assert_eq!(executor, ExecutorKind::Mock);
                assert!(prepare_only);
            }
            _ => panic!("parsed command should be workflow run"),
        }
    }

    #[test]
    fn cli_help_lists_workflow_command() {
        let mut cmd = Cli::command();
        let mut help = Vec::new();
        cmd.write_long_help(&mut help)
            .expect("long help should render");
        let help = String::from_utf8(help).expect("help should be valid utf-8");
        assert!(
            help.contains("workflow"),
            "help output should contain workflow command"
        );
        assert!(
            help.contains("Canonical workflow execution entry points"),
            "help output should include workflow command description"
        );
    }

    #[test]
    fn cli_parses_workflow_validate_subcommand() {
        let cli = Cli::try_parse_from([
            "harmony",
            "workflow",
            "validate",
            "audit-design-package",
        ])
        .expect("workflow validate should parse successfully");

        match cli.cmd {
            Command::Workflow {
                cmd: WorkflowCmd::Validate { workflow_id },
            } => {
                assert_eq!(workflow_id.as_deref(), Some("audit-design-package"));
            }
            _ => panic!("parsed command should be workflow validate"),
        }
    }
}
