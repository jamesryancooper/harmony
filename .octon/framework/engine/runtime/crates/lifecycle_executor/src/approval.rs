use crate::errors::{LifecycleErrorClass, LifecycleExecutionError};
use crate::request::LifecycleRouteExecutionRequest;
use crate::result::LifecycleRouteExecutionResult;
use crate::{observer, result::ReceiptObservation};
use anyhow::Result;
use std::fs;
use time::OffsetDateTime;

pub fn approval_required(request: &LifecycleRouteExecutionRequest) -> bool {
    route_requires_approval(request)
        && !matches!(
            request.policy.approval_policy.as_str(),
            "unattended" | "program-approved"
        )
}

pub fn unattended_override_active(request: &LifecycleRouteExecutionRequest) -> bool {
    route_requires_approval(request)
        && matches!(
            request.policy.approval_policy.as_str(),
            "unattended" | "program-approved"
        )
}

fn route_requires_approval(request: &LifecycleRouteExecutionRequest) -> bool {
    request.route.approval_required_by_default || request.route.route_type == "workflow"
}

pub fn write_unattended_override(
    request: &LifecycleRouteExecutionRequest,
) -> Result<std::path::PathBuf, LifecycleExecutionError> {
    fs::create_dir_all(&request.evidence_root)?;
    let path = request
        .evidence_root
        .join(format!("{}-approval-override.yml", request.route.route_id));
    let reason = request
        .route
        .approval_reason
        .as_deref()
        .unwrap_or("durable lifecycle route requires explicit approval");
    let (override_class, authorization_source, operator_responsibility) = if request
        .policy
        .approval_policy
        == "program-approved"
    {
        (
                "operator-program-approved-durable-route",
                "program-operator-approval-grant",
                "verify the program approval grant remains valid for this child route before resume or retry",
            )
    } else {
        (
            "operator-unattended-durable-route",
            "cli-operator-override",
            "verify durable mutation authorization before using unattended mode",
        )
    };
    let content = format!(
        "schema_version: octon-lifecycle-approval-override-v1\nrun_id: {}\nlifecycle_id: {}\nroute_id: {}\nroute_type: {}\napproval_policy: {}\noverride_class: {override_class}\nauthorization_source: {authorization_source}\napproval_required_by_default: {}\nworkflow_route: {}\nreason: {}\nrecorded_at: {}\noperator_responsibility: {operator_responsibility}\n",
        request.run_id,
        request.lifecycle_id,
        request.route.route_id,
        request.route.route_type,
        request.policy.approval_policy,
        request.route.approval_required_by_default,
        request.route.route_type == "workflow",
        reason,
        now_rfc3339(),
    );
    fs::write(&path, content)?;
    Ok(path)
}

pub fn write_approval_pause(
    request: &LifecycleRouteExecutionRequest,
    manifest_status_before: Option<String>,
    receipts: Vec<ReceiptObservation>,
) -> Result<LifecycleRouteExecutionResult, LifecycleExecutionError> {
    fs::create_dir_all(&request.evidence_root)?;
    let path = request.evidence_root.join("approval-required.yml");
    let now = now_rfc3339();
    let reason = request
        .route
        .approval_reason
        .as_deref()
        .unwrap_or("durable lifecycle route requires explicit approval");
    let default_resume_instruction = format!(
        "octon lifecycle run --lifecycle {} --target {} --run-id {} --execute-routes --approval-policy unattended",
        request.lifecycle_id,
        request.target.display(),
        request.run_id
    );
    let approval_instruction = request
        .approval_context
        .as_ref()
        .and_then(|context| context.approval_instruction.as_ref())
        .cloned()
        .unwrap_or_else(|| default_resume_instruction.clone());
    let retry_instruction = request
        .approval_context
        .as_ref()
        .and_then(|context| context.retry_instruction.as_ref())
        .cloned();
    let unattended_override_instruction = request
        .approval_context
        .as_ref()
        .and_then(|context| context.unattended_override_instruction.as_ref())
        .cloned()
        .unwrap_or_else(|| default_resume_instruction.clone());
    let content = format!(
        "schema_version: octon-lifecycle-approval-required-v1\nrun_id: {}\nlifecycle_id: {}\nroute_id: {}\nreason: {}\nresume_instruction: {}\nunattended_policy_notice: unattended is an explicit operator override; resumed durable route execution records approval override evidence before mutation\n{}",
        request.run_id,
        request.lifecycle_id,
        request.route.route_id,
        reason,
        approval_instruction,
        approval_context_yaml(
            request,
            retry_instruction.as_deref(),
            &unattended_override_instruction
        )
    );
    fs::write(&path, content)?;
    Ok(LifecycleRouteExecutionResult {
        schema_version: "octon-lifecycle-route-execution-result-v1".to_string(),
        run_id: request.run_id.clone(),
        route_id: request.route.route_id.clone(),
        executor_used: request.executor.clone(),
        status: "approval-required".to_string(),
        started_at: now.clone(),
        ended_at: now,
        manifest_status_before: manifest_status_before.clone(),
        manifest_status_after: observer::manifest_status(
            &request.target,
            &request.manifest_path,
            &request.status_field,
        )
        .map_err(LifecycleExecutionError::from)?,
        receipts_observed: receipts,
        evidence_paths: vec![path],
        stdout_path: None,
        stderr_path: None,
        prompt_packet_path: None,
        retryable: false,
        next_action: "resume-after-approval".to_string(),
        error_class: Some(LifecycleErrorClass::ApprovalRequired),
        error_message: Some(reason.to_string()),
    })
}

fn approval_context_yaml(
    request: &LifecycleRouteExecutionRequest,
    retry_instruction: Option<&str>,
    unattended_override_instruction: &str,
) -> String {
    let Some(context) = request.approval_context.as_ref() else {
        return format!(
            "approval_context:\n  context_kind: packet-route\n  unattended_override_instruction: {}\n",
            unattended_override_instruction
        );
    };
    let mut lines = vec![
        "approval_context:".to_string(),
        format!("  context_kind: {}", context.context_kind),
        format!(
            "  unattended_override_instruction: {}",
            unattended_override_instruction
        ),
    ];
    if let Some(program_run_id) = context.program_run_id.as_ref() {
        lines.push(format!("  program_run_id: {program_run_id}"));
    }
    if let Some(child_id) = context.child_id.as_ref() {
        lines.push(format!("  child_id: {child_id}"));
    }
    if let Some(approval_instruction) = context.approval_instruction.as_ref() {
        lines.push(format!("  approval_instruction: {approval_instruction}"));
    }
    if let Some(retry_instruction) = retry_instruction {
        lines.push(format!("  retry_instruction: {retry_instruction}"));
    }
    lines.push(String::new());
    lines.join("\n")
}

pub fn now_rfc3339() -> String {
    OffsetDateTime::now_utc()
        .format(&time::format_description::well_known::Rfc3339)
        .unwrap_or_else(|_| "unknown".to_string())
}
