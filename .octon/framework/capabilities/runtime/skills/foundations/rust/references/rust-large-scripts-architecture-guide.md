# Rust Architecture Guide for Large Scripts and Growing Tools

## Core opinion

A Rust script should become a real project earlier than a Bash or Python script would, because Rust rewards clear boundaries: typed input, typed output, explicit errors, testable pure functions, and a small executable shell.

Default recommendation for most growing Rust scripts:

```text
One Cargo package with a thin main.rs, real logic in lib.rs, modules under src/, integration tests under tests/, and no workspace until there are genuinely separate packages.
```

The best mental model:

```text
Parse at the edge.
Validate once.
Plan before mutating.
Keep the core pure.
Put effects behind boring adapters.
Test the library, smoke-test the binary.
```

## 1. When a Rust script should stop being just a script

A Rust script has outgrown a single file when `main()` is no longer a readable story.

Signs:

- Too many responsibilities in `main.rs`
- Hard-to-test logic
- Complex argument parsing
- Repeated helper functions
- Growing configuration needs
- Error handling becoming messy
- Multiple execution modes
- Shared domain logic
- Need for logging, tracing, or observability
- Dry-run or explain-mode needs
- Filesystem mutation
- External command orchestration
- JSON/human dual output
- CI usage
- Developer nervousness when editing

A practical threshold:

```text
If main.rs parses arguments, reads config, walks the filesystem, validates domain rules, calls external commands, formats output, handles dry-run behavior, and decides exit codes, it is not a script anymore. It is an application hiding in one file.
```

## 2. Recommended project structures

### A. Single `src/main.rs`

```text
my-tool/
├── Cargo.toml
└── src/
    └── main.rs
```

Use when:

- One command
- One responsibility
- Little or no config
- Logic is mostly glue
- Tests are not important yet

Do not use when:

- You have meaningful domain logic
- You need integration tests that call internal functions
- You have multiple commands or workflows
- Error handling is becoming noisy

Tradeoff:

- Fastest to start
- Worst to scale

### B. `main.rs` plus internal modules

```text
my-tool/
├── Cargo.toml
└── src/
    ├── main.rs
    ├── cli.rs
    ├── config.rs
    ├── fs_ops.rs
    └── commands/
        ├── mod.rs
        ├── check.rs
        └── fix.rs
```

Use when:

- The tool is growing
- You need organization quickly
- The binary is still the only consumer
- Most testing can be module-local unit tests

Do not use when:

- Integration tests need to call core behavior
- Multiple binaries need shared logic
- You want a stable internal API

Tradeoff:

- Good transitional structure
- Can become cramped if no `lib.rs` appears

### C. `bin` + `lib` split

```text
my-tool/
├── Cargo.toml
├── src/
│   ├── main.rs
│   ├── lib.rs
│   ├── cli.rs
│   ├── config.rs
│   ├── error.rs
│   ├── app.rs
│   ├── domain/
│   │   ├── mod.rs
│   │   ├── manifest.rs
│   │   └── rules.rs
│   ├── commands/
│   │   ├── mod.rs
│   │   ├── check.rs
│   │   └── fix.rs
│   └── io/
│       ├── mod.rs
│       ├── files.rs
│       └── process.rs
└── tests/
    ├── cli_check.rs
    └── fixtures/
```

Use when:

- You want unit and integration tests
- You want a clean CLI/logic boundary
- You may add another binary later
- The tool needs to survive

Tradeoff:

- Slightly more ceremony
- Much better maintainability

`main.rs` should parse, call, print, and exit.

### D. Multiple binaries under `src/bin`

```text
my-tool/
├── Cargo.toml
└── src/
    ├── lib.rs
    ├── cli.rs
    ├── app.rs
    └── bin/
        ├── my-tool.rs
        ├── my-tool-doctor.rs
        └── my-tool-migrate.rs
```

Use when:

- You have genuinely different entrypoints
- You have admin/dev/helper binaries
- You want separate command names
- Binaries share a common library

Do not use when:

- You merely have subcommands
- The binaries are barely different wrappers
- You are splitting only because `main.rs` is messy

### E. Workspace-based architecture

```text
tools/
├── Cargo.toml
├── crates/
│   ├── tool-cli/
│   ├── tool-core/
│   ├── tool-fs/
│   └── tool-test-support/
└── xtask/
```

Use when:

- You have multiple packages with real independent boundaries
- You have reusable internal crates
- You have an `xtask` repo automation tool
- Compile times or dependency boundaries justify separation
- You need separate feature sets or release surfaces

Do not use when:

- You merely have many files
- You are trying to feel architecturally mature
- Domain boundaries are still unclear
- The workspace forces fake abstractions

Rule:

```text
Do not split into crates until module boundaries have stabilized.
```

### F. Reusable internal crates

Good candidates:

```text
crates/
├── manifest-parser/
├── command-runner/
├── repo-model/
├── report-format/
└── test-support/
```

Bad candidates:

```text
crates/utils/
crates/helpers/
crates/common/
crates/misc/
```

A reusable internal crate should have:

- Clear owner responsibility
- Small public API
- Few dependencies
- Independent tests
- No CLI flag knowledge
- No hidden global state

## 3. Core architectural patterns

### Thin shell, testable core

Bad:

```rust
fn main() {
    let args = std::env::args();
    // parse, read env, read files, mutate files, print, call git, handle errors
}
```

Good:

```rust
pub fn run(cli: Cli) -> Result<RunReport, ToolError> {
    let config = Config::resolve(cli)?;
    let env = AppEnv::detect(&config)?;
    app::execute(config, env)
}
```

### Separate CLI parsing from execution logic

`clap` structs should be boundary types, not domain types.

```rust
#[derive(Debug, clap::Parser)]
pub struct Cli {
    #[arg(long, global = true)]
    pub config: Option<PathBuf>,

    #[arg(short, long, global = true, action = clap::ArgAction::Count)]
    pub verbose: u8,

    #[arg(long, global = true)]
    pub dry_run: bool,

    #[command(subcommand)]
    pub command: Command,
}

#[derive(Debug, clap::Subcommand)]
pub enum Command {
    Check { path: PathBuf },
    Fix { path: PathBuf, #[arg(long)] write: bool },
}
```

Then convert CLI shape into application shape:

```rust
impl TryFrom<Cli> for Config {
    type Error = ToolError;

    fn try_from(cli: Cli) -> Result<Self, Self::Error> {
        // merge defaults, config file, env, flags
        // validate once
        todo!()
    }
}
```

### Separate orchestration from pure business logic

Orchestration coordinates effects:

```rust
pub fn execute(config: Config, env: AppEnv) -> Result<RunReport, ToolError> {
    let files = env.fs.discover_inputs(&config.input)?;
    let parsed = parse_files(files)?;
    let plan = domain::plan_changes(parsed, &config.rules)?;

    if config.dry_run {
        return Ok(RunReport::dry_run(plan));
    }

    env.executor.apply(plan)
}
```

Pure logic should be boring and testable:

```rust
pub fn classify_file(file: &RepoFile, rules: &Rules) -> Classification {
    if rules.ignored_patterns.iter().any(|p| p.matches(&file.path)) {
        Classification::Ignored
    } else if file.contents.contains("TODO") {
        Classification::NeedsAttention
    } else {
        Classification::Ok
    }
}
```

### Command pattern

Start simple:

```rust
pub fn run_command(command: Command, ctx: &AppContext) -> Result<RunReport, ToolError> {
    match command {
        Command::Check { path } => commands::check::run(path, ctx),
        Command::Fix { path, write } => commands::fix::run(path, write, ctx),
    }
}
```

Only introduce traits when you have multiple real implementations.

### Pipeline pattern

For data/repo tools:

```text
Discover -> Read -> Parse -> Validate -> Plan -> Execute -> Report
```

Represent each stage with typed data:

```rust
pub struct DiscoveredFile {
    pub path: PathBuf,
}

pub struct ParsedFile {
    pub path: PathBuf,
    pub items: Vec<Item>,
}

pub struct ChangePlan {
    pub changes: Vec<PlannedChange>,
}
```

### Adapter pattern

Use adapters at effect boundaries:

```text
domain logic
    ↓
service layer
    ↓
filesystem/process/network adapters
```

Start concrete:

```rust
pub struct ProcessRunner;

impl ProcessRunner {
    pub fn run(&self, cmd: ExternalCommand) -> Result<CommandOutput, ToolError> {
        todo!()
    }
}
```

Avoid premature trait forests.

### Configuration object pattern

After parsing and validation, the program should receive one coherent config object:

```rust
pub struct Config {
    pub root: PathBuf,
    pub mode: Mode,
    pub dry_run: bool,
    pub output: OutputMode,
    pub rules: Rules,
}
```

### Context/environment struct

Use `Config` for user intent. Use `AppContext` for runtime environment.

```rust
pub struct AppContext {
    pub cwd: PathBuf,
    pub started_at: std::time::SystemTime,
    pub dry_run: bool,
}
```

Do not turn context into a service locator.

### Typed inputs and outputs

Prefer typed invariants over raw strings:

```rust
pub struct RepoRoot(PathBuf);
pub struct ManifestPath(PathBuf);
pub struct PackageName(String);
```

## 4. Error handling strategy

### Use `anyhow` at the application edge

Use `anyhow` when:

- Code is binary-only
- You mainly need context-rich reporting
- Callers do not need to match variants
- You are writing orchestration/glue

```rust
use anyhow::{Context, Result};

fn load_config(path: &Path) -> Result<RawConfig> {
    let text = std::fs::read_to_string(path)
        .with_context(|| format!("failed to read config file {}", path.display()))?;

    toml::from_str(&text)
        .with_context(|| format!("failed to parse config file {}", path.display()))
}
```

### Use `thiserror` for domain/library errors

```rust
#[derive(Debug, thiserror::Error)]
pub enum ToolError {
    #[error("invalid config: {0}")]
    InvalidConfig(String),

    #[error("input path does not exist: {path}")]
    MissingInput { path: PathBuf },

    #[error("failed to read {path}")]
    ReadFile {
        path: PathBuf,
        #[source]
        source: std::io::Error,
    },

    #[error("external command failed: {program}")]
    CommandFailed {
        program: String,
        status: std::process::ExitStatus,
        stderr: String,
    },
}
```

### Expected user errors vs internal failures

Expected user errors:

- Missing file
- Invalid flag combination
- Bad config
- Unsupported mode
- No matching records
- Permission denied
- External command not found

Internal failures:

- Invariant violation
- Parser bug
- Unexpected impossible state
- Corrupt intermediate data
- Panic-worthy programming errors

Every `?` crossing an I/O, config, process, or user boundary should add context.

## 5. Configuration and inputs

Use layered configuration:

```text
hardcoded defaults
    < config file
    < environment variables
    < CLI flags
```

Do not scatter env reads through the program.

Recommended crates:

- `clap` for CLI parsing and subcommands
- `serde` for typed serialization/deserialization
- `toml` for TOML config files
- `dotenvy` for local development `.env` loading when appropriate

Validation should happen after merging.

Secrets:

- Prefer env vars or secret managers over config files
- Do not log secret-bearing structs with `Debug`
- Redact summaries
- Avoid including secrets in errors
- Keep secrets out of snapshots and golden files

## 6. Logging, tracing, diagnostics

For serious tools, prefer `tracing` over starting with ad hoc logs.

Introduce diagnostics when:

- Tool runs longer than a few seconds
- Failures need forensic detail
- You call external commands
- You process many files
- You support `--verbose`, `--quiet`, `--json`, or CI usage
- You need structured events

Useful modes:

```text
--verbose       more diagnostic logs
--quiet         only errors / final result
--json          machine-readable output
--dry-run       show intended changes, do not mutate
--explain       explain why each decision was made
--summary       final audit summary
```

Rule:

```text
Human logs go to stderr. Machine-readable output goes to stdout.
```

## 7. Testing strategy

Use:

- Unit tests for pure logic
- Integration tests for CLI behavior
- Golden-file tests
- Snapshot testing
- Temp directories
- Fake systems only when temp dirs are insufficient
- Fixtures
- Error path tests
- Safe command execution tests

Recommended crates:

- `assert_cmd`
- `predicates`
- `insta`
- `tempfile`

Test the risky behavior first:

- destructive writes
- config merging
- invalid inputs
- external command failures
- dry-run
- output format

## 8. Async, concurrency, and long-running tasks

Do not make a Rust tool async just because it sounds modern.

Use sync when:

- Mostly local filesystem work
- Small number of commands
- Sequential processing is fine
- Simplicity matters more than throughput

Use async when:

- Many network requests
- Timers, cancellation, concurrent I/O
- Many independent slow operations
- Graceful shutdown
- Async libraries already required

Use Tokio for async I/O. Use Rayon for CPU-heavy local data parallelism.

Design:

- bounded concurrency
- cancellation
- timeouts
- retries
- rate limits
- progress tracking
- graceful shutdown
- partial result reporting
- cleanup/rollback behavior

## 9. Filesystem and external command architecture

Design around planning before mutation:

```text
scan filesystem -> build plan -> display/validate plan -> execute plan -> report result
```

Represent planned changes:

```rust
pub enum PlannedChange {
    WriteFile { path: PathBuf, contents: String },
    DeleteFile { path: PathBuf },
    RenameFile { from: PathBuf, to: PathBuf },
    RunCommand { command: ExternalCommand },
}
```

Filesystem practices:

- Use `Path` and `PathBuf`, not strings
- Use `camino` only when UTF-8 path assumption is explicit
- Use `walkdir` for recursive traversal
- Use atomic writes for important files
- Keep backups for destructive migrations
- Make operations idempotent

External command practices:

- Prefer `Command::new(program).args(args)`
- Avoid `sh -c` unless truly necessary
- Capture stdout/stderr intentionally
- Wrap commands for consistent error handling
- Preserve cwd explicitly
- Sanitize and quote human display separately from actual process invocation

## 10. Performance and memory

Most large Rust scripts become slow because they load too much, clone too much, or serialize work that could be streamed.

Use:

- streaming instead of loading all data
- `BufReader` and `BufWriter`
- iterators
- chunking
- Rayon for CPU-bound parallelism
- borrowing instead of cloning when possible
- profiling before optimizing

Escalation:

```text
1. Make it correct.
2. Add tests.
3. Add coarse timing/tracing.
4. Identify hot stages.
5. Benchmark hot pure functions.
6. Profile full execution.
7. Optimize the measured bottleneck.
```

## 11. Anti-patterns

Avoid:

- giant `main.rs`
- business logic mixed with CLI parsing
- global mutable state
- too many loosely related modules
- overusing traits too early
- making everything async
- hiding all errors behind strings
- excessive cleverness
- premature workspace splitting
- no tests because “it’s just a script”
- relying on implicit current working directory assumptions
- `utils.rs` junk drawers
- unbounded concurrency
- shell command strings built from user input
- generated outputs treated as source of truth

## 12. Migration path

1. Clean up `main`
2. Extract CLI parsing
3. Extract config parsing
4. Extract pure logic
5. Introduce typed errors
6. Split modules by responsibility
7. Add tests
8. Introduce `lib.rs`
9. Add multiple binaries if needed
10. Consider a workspace only when justified

## 13. Recommended default architecture

```text
my-tool/
├── Cargo.toml
├── README.md
├── src/
│   ├── main.rs
│   ├── lib.rs
│   ├── app.rs
│   ├── cli.rs
│   ├── config.rs
│   ├── error.rs
│   ├── report.rs
│   ├── commands/
│   │   ├── mod.rs
│   │   ├── check.rs
│   │   └── fix.rs
│   ├── domain/
│   │   ├── mod.rs
│   │   ├── model.rs
│   │   ├── rules.rs
│   │   └── planner.rs
│   └── io/
│       ├── mod.rs
│       ├── files.rs
│       └── process.rs
└── tests/
    ├── cli_check.rs
    ├── cli_fix.rs
    └── fixtures/
```

Default dependencies:

```toml
[dependencies]
clap = { version = "4", features = ["derive"] }
serde = { version = "1", features = ["derive"] }
toml = "0.9"
thiserror = "2"
anyhow = "1"
tracing = "0.1"
tracing-subscriber = "0.3"

[dev-dependencies]
assert_cmd = "2"
predicates = "3"
insta = "1"
tempfile = "3"
```

Add only when needed:

```toml
tokio = { version = "1", features = ["rt-multi-thread", "macros", "signal", "time"] }
rayon = "1"
walkdir = "2"
camino = "1"
xshell = "0.2"
atomic-write-file = "0.3"
```
