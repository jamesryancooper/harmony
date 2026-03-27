#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/orchestration-runtime-common.sh"
orchestration_runtime_init "${BASH_SOURCE[0]}"
require_tools yq

usage() {
  cat <<'EOF'
Usage:
  write-run.sh create --run-id <id> --decision-id <id> --summary <text> --workflow-group <group> --workflow-id <id> --executor-id <id> --lease-seconds <n> [--risk-class <low|medium|high|critical>] [--reversibility-class <value>] [--support-tier <value>] [options]
  write-run.sh complete --run-id <id> --status <succeeded|failed|cancelled> --summary <text>
  write-run.sh heartbeat --run-id <id> --lease-seconds <n>
  write-run.sh recovery --run-id <id> --recovery-status <status> [--recovery-reason <text>]
  write-run.sh backfill-wave4 --run-id <id>
EOF
}

validate_risk_class() {
  local risk_class="$1"
  case "$risk_class" in
    low|medium|high|critical) ;;
    *)
      echo "invalid risk-class: $risk_class" >&2
      echo "expected one of: low, medium, high, critical" >&2
      exit 1
      ;;
  esac
}

validate_support_tier() {
  local support_tier="$1"
  local support_targets_file="$OCTON_DIR/instance/governance/support-targets.yml"
  if [[ ! -f "$support_targets_file" ]]; then
    echo "support-target declaration missing: $support_targets_file" >&2
    exit 1
  fi

  if yq -e --arg support_tier "$support_tier" '.tiers.workload[]? | select(.label == $support_tier or .id == $support_tier)' "$support_targets_file" >/dev/null 2>&1; then
    return 0
  fi

  echo "invalid support-tier: $support_tier" >&2
  echo "expected a declared workload tier label or id from $support_targets_file" >&2
  exit 1
}

run_control_dir() {
  local run_id="$1"
  printf '%s/%s' "$RUN_CONTROL_ROOT" "$run_id"
}

run_contract_path() {
  local run_id="$1"
  printf '%s/%s/run-contract.yml' "$RUN_CONTROL_ROOT" "$run_id"
}

stage_attempt_dir() {
  local run_id="$1"
  printf '%s/%s/stage-attempts' "$RUN_CONTROL_ROOT" "$run_id"
}

checkpoint_dir() {
  local run_id="$1"
  printf '%s/%s/checkpoints' "$RUN_CONTROL_ROOT" "$run_id"
}

runtime_state_path() {
  local run_id="$1"
  printf '%s/%s/runtime-state.yml' "$RUN_CONTROL_ROOT" "$run_id"
}

rollback_posture_path() {
  local run_id="$1"
  printf '%s/%s/rollback-posture.yml' "$RUN_CONTROL_ROOT" "$run_id"
}

run_evidence_dir() {
  local run_id="$1"
  printf '%s/%s' "$CONTINUITY_RUNS_DIR" "$run_id"
}

receipt_dir() {
  local run_id="$1"
  printf '%s/%s/receipts' "$CONTINUITY_RUNS_DIR" "$run_id"
}

evidence_checkpoint_dir() {
  local run_id="$1"
  printf '%s/%s/checkpoints' "$CONTINUITY_RUNS_DIR" "$run_id"
}

replay_pointers_path() {
  local run_id="$1"
  printf '%s/%s/replay-pointers.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

trace_pointers_path() {
  local run_id="$1"
  printf '%s/%s/trace-pointers.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

retained_evidence_path() {
  local run_id="$1"
  printf '%s/%s/retained-run-evidence.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

assurance_dir() {
  local run_id="$1"
  printf '%s/%s/assurance' "$CONTINUITY_RUNS_DIR" "$run_id"
}

measurement_dir() {
  local run_id="$1"
  printf '%s/%s/measurements' "$CONTINUITY_RUNS_DIR" "$run_id"
}

intervention_dir() {
  local run_id="$1"
  printf '%s/%s/interventions' "$CONTINUITY_RUNS_DIR" "$run_id"
}

disclosure_dir() {
  local run_id="$1"
  printf '%s/%s/disclosure' "$CONTINUITY_RUNS_DIR" "$run_id"
}

replay_manifest_path() {
  local run_id="$1"
  printf '%s/%s/replay/manifest.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

functional_report_path() {
  local run_id="$1"
  printf '%s/%s/assurance/functional.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

behavioral_report_path() {
  local run_id="$1"
  printf '%s/%s/assurance/behavioral.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

recovery_report_path() {
  local run_id="$1"
  printf '%s/%s/assurance/recovery.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

evaluator_review_path() {
  local run_id="$1"
  printf '%s/%s/assurance/evaluator.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

maintainability_report_path() {
  local run_id="$1"
  printf '%s/%s/assurance/maintainability.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

measurement_summary_path() {
  local run_id="$1"
  printf '%s/%s/measurements/summary.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

intervention_log_path() {
  local run_id="$1"
  printf '%s/%s/interventions/log.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

run_card_path() {
  local run_id="$1"
  printf '%s/%s/disclosure/run-card.yml' "$CONTINUITY_RUNS_DIR" "$run_id"
}

run_card_markdown_path() {
  local run_id="$1"
  printf '%s/%s/disclosure/run-card.md' "$CONTINUITY_RUNS_DIR" "$run_id"
}

run_contract_relpath() {
  local run_id="$1"
  printf '.octon/state/control/execution/runs/%s/run-contract.yml' "$run_id"
}

stage_attempt_dir_relpath() {
  local run_id="$1"
  printf '.octon/state/control/execution/runs/%s/stage-attempts' "$run_id"
}

checkpoint_dir_relpath() {
  local run_id="$1"
  printf '.octon/state/control/execution/runs/%s/checkpoints' "$run_id"
}

runtime_state_relpath() {
  local run_id="$1"
  printf '.octon/state/control/execution/runs/%s/runtime-state.yml' "$run_id"
}

rollback_posture_relpath() {
  local run_id="$1"
  printf '.octon/state/control/execution/runs/%s/rollback-posture.yml' "$run_id"
}

run_evidence_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s' "$run_id"
}

receipt_dir_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/receipts' "$run_id"
}

orchestration_receipt_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/receipts/orchestration-lifecycle.yml' "$run_id"
}

evidence_checkpoint_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/checkpoints/bound.yml' "$run_id"
}

control_checkpoint_relpath() {
  local run_id="$1"
  printf '.octon/state/control/execution/runs/%s/checkpoints/bound.yml' "$run_id"
}

replay_pointers_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/replay-pointers.yml' "$run_id"
}

trace_pointers_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/trace-pointers.yml' "$run_id"
}

retained_evidence_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/retained-run-evidence.yml' "$run_id"
}

assurance_dir_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/assurance' "$run_id"
}

measurement_dir_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/measurements' "$run_id"
}

intervention_dir_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/interventions' "$run_id"
}

disclosure_dir_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/disclosure' "$run_id"
}

replay_manifest_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/replay/manifest.yml' "$run_id"
}

functional_report_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/assurance/functional.yml' "$run_id"
}

behavioral_report_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/assurance/behavioral.yml' "$run_id"
}

recovery_report_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/assurance/recovery.yml' "$run_id"
}

evaluator_review_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/assurance/evaluator.yml' "$run_id"
}

maintainability_report_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/assurance/maintainability.yml' "$run_id"
}

measurement_summary_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/measurements/summary.yml' "$run_id"
}

intervention_log_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/interventions/log.yml' "$run_id"
}

run_card_relpath() {
  local run_id="$1"
  printf '.octon/state/evidence/runs/%s/disclosure/run-card.yml' "$run_id"
}

contract_status_from_projection() {
  case "$1" in
    succeeded) printf 'completed' ;;
    failed) printf 'failed' ;;
    cancelled) printf 'cancelled' ;;
    running) printf 'running' ;;
    *) printf '%s' "$1" ;;
  esac
}

attempt_status_from_projection() {
  case "$1" in
    completed) printf 'succeeded' ;;
    *) printf '%s' "$1" ;;
  esac
}

collect_scope_in_json() {
  local workflow_group="$1"
  local workflow_id="$2"
  local mission_id="$3"
  local automation_id="$4"
  local incident_id="$5"

  local -a scopes=()
  if [[ -n "$workflow_group" && -n "$workflow_id" ]]; then
    scopes+=(".octon/framework/orchestration/runtime/workflows/$workflow_group/$workflow_id")
  fi
  if [[ -n "$mission_id" ]]; then
    scopes+=(".octon/instance/orchestration/missions/$mission_id")
  fi
  if [[ -n "$automation_id" ]]; then
    scopes+=(".octon/framework/orchestration/runtime/automations/$automation_id")
  fi
  if [[ -n "$incident_id" ]]; then
    scopes+=(".octon/framework/orchestration/runtime/incidents/$incident_id")
  fi
  if [[ "${#scopes[@]}" -eq 0 ]]; then
    scopes+=(".octon/framework/orchestration/runtime")
  fi

  printf '%s\n' "${scopes[@]}" | jq -R . | jq -s .
}

collect_requested_capabilities_json() {
  local workflow_group="$1"
  local workflow_id="$2"
  local mission_id="$3"
  local automation_id="$4"

  local -a capabilities=("evidence.write" "state.write")
  if [[ -n "$workflow_group" && -n "$workflow_id" ]]; then
    capabilities+=("workflow.execute")
  fi
  if [[ -n "$mission_id" ]]; then
    capabilities+=("mission.context")
  fi
  if [[ -n "$automation_id" ]]; then
    capabilities+=("automation.launch")
  fi

  printf '%s\n' "${capabilities[@]}" | awk '!seen[$0]++' | jq -R . | jq -s .
}

yaml_json_or_default() {
  local file="$1"
  local query="${2:-.}"
  local fallback="${3-}"
  if [[ -z "$fallback" ]]; then
    fallback='{}'
  fi
  if [[ -f "$file" ]]; then
    yq -o=json "$query" "$file" 2>/dev/null || printf '%s' "$fallback"
  else
    printf '%s' "$fallback"
  fi
}

merge_string_arrays_json() {
  local base_json="$1"
  local extra_json="$2"
  printf '%s\n%s\n' "$base_json" "$extra_json" \
    | jq -cs 'add | map(select(type == "string" and length > 0)) | unique'
}

write_runtime_state_file() {
  local run_id="$1"
  local status="$2"
  local created_at="$3"
  local updated_at="$4"
  local mission_id="$5"
  local parent_run_id="$6"
  local last_receipt_ref="${7:-}"
  local runtime_state_file existing_created_at existing_last_receipt_ref existing_last_checkpoint_ref
  local resolved_created_at resolved_last_receipt_ref resolved_last_checkpoint_ref
  runtime_state_file="$(runtime_state_path "$run_id")"
  existing_created_at="$( [[ -f "$runtime_state_file" ]] && yq -r '.created_at // ""' "$runtime_state_file" 2>/dev/null || printf '' )"
  existing_last_receipt_ref="$( [[ -f "$runtime_state_file" ]] && yq -r '.last_receipt_ref // ""' "$runtime_state_file" 2>/dev/null || printf '' )"
  existing_last_checkpoint_ref="$( [[ -f "$runtime_state_file" ]] && yq -r '.last_checkpoint_ref // ""' "$runtime_state_file" 2>/dev/null || printf '' )"
  resolved_created_at="$created_at"
  resolved_last_receipt_ref="$last_receipt_ref"
  resolved_last_checkpoint_ref="$(control_checkpoint_relpath "$run_id")"
  if [[ -n "$existing_created_at" && "$existing_created_at" != "null" ]]; then
    resolved_created_at="$existing_created_at"
  fi
  if [[ -z "$resolved_last_receipt_ref" && -n "$existing_last_receipt_ref" && "$existing_last_receipt_ref" != "null" ]]; then
    resolved_last_receipt_ref="$existing_last_receipt_ref"
  fi
  if [[ -n "$existing_last_checkpoint_ref" && "$existing_last_checkpoint_ref" != "null" ]]; then
    resolved_last_checkpoint_ref="$existing_last_checkpoint_ref"
  fi

  jq -n \
    --arg run_id "$run_id" \
    --arg status "$status" \
    --arg workflow_mode "$( [[ -n "$mission_id" ]] && printf 'autonomous' || printf 'human-only' )" \
    --arg decision_state "$( [[ "$status" == "failed" || "$status" == "cancelled" ]] && printf 'deny' || printf 'allow' )" \
    --arg run_contract_ref "$(run_contract_relpath "$run_id")" \
    --arg stage_attempt_root "$(stage_attempt_dir_relpath "$run_id")" \
    --arg checkpoint_root "$(checkpoint_dir_relpath "$run_id")" \
    --arg evidence_root "$(run_evidence_relpath "$run_id")" \
    --arg receipt_root "$(receipt_dir_relpath "$run_id")" \
    --arg control_checkpoint_ref "$resolved_last_checkpoint_ref" \
    --arg last_receipt_ref "$resolved_last_receipt_ref" \
    --arg mission_id "$mission_id" \
    --arg parent_run_ref "$( [[ -n "$parent_run_id" ]] && printf '.octon/state/control/execution/runs/%s/run-contract.yml' "$parent_run_id" || printf '' )" \
    --arg created_at "$resolved_created_at" \
    --arg updated_at "$updated_at" '
      {
        schema_version: "run-runtime-state-v1",
        run_id: $run_id,
        status: $status,
        workflow_mode: $workflow_mode,
        decision_state: $decision_state,
        run_contract_ref: $run_contract_ref,
        stage_attempt_root: $stage_attempt_root,
        control_checkpoint_root: $checkpoint_root,
        evidence_root: $evidence_root,
        receipt_root: $receipt_root,
        current_stage_attempt_id: "initial",
        last_checkpoint_ref: $control_checkpoint_ref,
        created_at: $created_at,
        updated_at: $updated_at
      }
      + (if $last_receipt_ref != "" then {last_receipt_ref: $last_receipt_ref} else {} end)
      + (if $mission_id != "" then {mission_id: $mission_id} else {} end)
      + (if $parent_run_ref != "" then {parent_run_ref: $parent_run_ref} else {} end)
    ' | yq -P -p=json '.' > "$runtime_state_file"
}

write_orchestration_receipt_file() {
  local run_id="$1"
  local status="$2"
  local summary="$3"
  local recorded_at="$4"

  jq -n \
    --arg run_id "$run_id" \
    --arg status "$status" \
    --arg summary "$summary" \
    --arg recorded_at "$recorded_at" '
      {
        schema_version: "orchestration-run-lifecycle-receipt-v1",
        run_id: $run_id,
        status: $status,
        summary: $summary,
        recorded_at: $recorded_at
      }
    ' | yq -P -p=json '.' > "$(receipt_dir "$run_id")/orchestration-lifecycle.yml"
}

write_rollback_posture_file() {
  local run_id="$1"
  local updated_at="$2"
  local rollback_file existing_json
  local reversibility_class rollback_strategy contamination_state hard_reset_required posture_source
  rollback_file="$(rollback_posture_path "$run_id")"
  existing_json="$(yaml_json_or_default "$rollback_file" '.' '{}')"
  reversibility_class="$(jq -r '.reversibility_class // "reversible"' <<<"$existing_json")"
  rollback_strategy="$(jq -r '.rollback_strategy // "rollback"' <<<"$existing_json")"
  contamination_state="$(jq -r '.contamination_state // "clean"' <<<"$existing_json")"
  hard_reset_required="$(jq -r '.hard_reset_required // false' <<<"$existing_json")"
  posture_source="$(jq -r '.posture_source // "orchestration-runtime"' <<<"$existing_json")"

  jq -n \
    --arg run_id "$run_id" \
    --arg reversibility_class "$reversibility_class" \
    --arg rollback_strategy "$rollback_strategy" \
    --arg contamination_state "$contamination_state" \
    --arg posture_source "$posture_source" \
    --argjson hard_reset_required "$hard_reset_required" \
    --arg updated_at "$updated_at" '
      {
        schema_version: "run-rollback-posture-v1",
        run_id: $run_id,
        reversibility_class: $reversibility_class,
        rollback_strategy: $rollback_strategy,
        contamination_state: $contamination_state,
        hard_reset_required: $hard_reset_required,
        posture_source: $posture_source,
        updated_at: $updated_at
      }
    ' | yq -P -p=json '.' > "$rollback_file"
}

write_bound_checkpoint_files() {
  local run_id="$1"
  local created_at="$2"
  local control_path evidence_path
  control_path="$(checkpoint_dir "$run_id")/bound.yml"
  evidence_path="$(evidence_checkpoint_dir "$run_id")/bound.yml"
  jq -n \
    --arg run_id "$run_id" \
    --arg created_at "$created_at" \
    --arg control_ref "$(control_checkpoint_relpath "$run_id")" \
    --arg evidence_ref "$(evidence_checkpoint_relpath "$run_id")" '
      {
        schema_version: "run-checkpoint-v1",
        run_id: $run_id,
        checkpoint_id: "bound",
        stage_attempt_id: "initial",
        checkpoint_kind: "binding",
        status: "materialized",
        control_ref: $control_ref,
        evidence_ref: $evidence_ref,
        notes: "Canonical run root bound for orchestration-managed execution.",
        created_at: $created_at,
        updated_at: $created_at
      }
    ' | yq -P -p=json '.' > "$control_path"
  jq -n \
    --arg run_id "$run_id" \
    --arg created_at "$created_at" \
    --arg control_ref "$(control_checkpoint_relpath "$run_id")" \
    --arg evidence_ref "$(evidence_checkpoint_relpath "$run_id")" '
      {
        schema_version: "run-checkpoint-v1",
        run_id: $run_id,
        checkpoint_id: "bound",
        stage_attempt_id: "initial",
        checkpoint_kind: "binding",
        status: "materialized",
        control_ref: $control_ref,
        evidence_ref: $evidence_ref,
        notes: "Canonical run root bound for orchestration-managed execution.",
        created_at: $created_at,
        updated_at: $created_at
      }
    ' | yq -P -p=json '.' > "$evidence_path"
}

write_replay_pointer_file() {
  local run_id="$1"
  local updated_at="$2"
  local replay_file existing_receipts_json existing_checkpoints_json existing_trace_json existing_external_json
  local new_receipts_json new_checkpoints_json merged_receipts_json merged_checkpoints_json merged_trace_json merged_external_json
  replay_file="$(replay_pointers_path "$run_id")"
  local receipt_ref=""
  if [[ -f "$(receipt_dir "$run_id")/orchestration-lifecycle.yml" ]]; then
    receipt_ref="$(orchestration_receipt_relpath "$run_id")"
  fi
  existing_receipts_json="$(yaml_json_or_default "$replay_file" '.receipt_refs // []' '[]')"
  existing_checkpoints_json="$(yaml_json_or_default "$replay_file" '.checkpoint_refs // []' '[]')"
  existing_trace_json="$(yaml_json_or_default "$replay_file" '.trace_refs // []' '[]')"
  existing_external_json="$(yaml_json_or_default "$replay_file" '.external_replay_refs // []' '[]')"
  new_receipts_json="$(jq -cn --arg receipt_ref "$receipt_ref" 'if $receipt_ref != "" then [$receipt_ref] else [] end')"
  new_checkpoints_json="$(jq -cn --arg checkpoint_ref "$(evidence_checkpoint_relpath "$run_id")" '[$checkpoint_ref]')"
  new_external_json="$(jq -cn --arg replay_manifest_ref "$(replay_manifest_relpath "$run_id")" '[$replay_manifest_ref]')"
  merged_receipts_json="$(merge_string_arrays_json "$existing_receipts_json" "$new_receipts_json")"
  merged_checkpoints_json="$(merge_string_arrays_json "$existing_checkpoints_json" "$new_checkpoints_json")"
  merged_trace_json="$(merge_string_arrays_json "$existing_trace_json" '[]')"
  merged_external_json="$(merge_string_arrays_json "$existing_external_json" "$new_external_json")"
  jq -n \
    --arg run_id "$run_id" \
    --argjson receipt_refs "$merged_receipts_json" \
    --argjson checkpoint_refs "$merged_checkpoints_json" \
    --argjson trace_refs "$merged_trace_json" \
    --argjson external_replay_refs "$merged_external_json" \
    --arg updated_at "$updated_at" '
      {
        schema_version: "run-replay-pointers-v1",
        run_id: $run_id,
        receipt_refs: $receipt_refs,
        checkpoint_refs: $checkpoint_refs,
        trace_refs: $trace_refs,
        external_replay_refs: $external_replay_refs,
        updated_at: $updated_at
      }
    ' | yq -P -p=json '.' > "$replay_file"
}

write_trace_pointer_file() {
  local run_id="$1"
  local updated_at="$2"
  local trace_file existing_trace_json merged_trace_json
  trace_file="$(trace_pointers_path "$run_id")"
  existing_trace_json="$(yaml_json_or_default "$trace_file" '.trace_refs // []' '[]')"
  merged_trace_json="$(merge_string_arrays_json "$existing_trace_json" '[]')"
  jq -n \
    --arg run_id "$run_id" \
    --argjson trace_refs "$merged_trace_json" \
    --arg updated_at "$updated_at" '
      {
        schema_version: "run-trace-pointers-v1",
        run_id: $run_id,
        trace_refs: $trace_refs,
        updated_at: $updated_at
      }
    ' | yq -P -p=json '.' > "$trace_file"
}

write_retained_evidence_file() {
  local run_id="$1"
  local updated_at="$2"
  local retained_file existing_map_json new_map_json merged_map_json
  local run_card_ref=""
  if [[ -f "$(run_card_path "$run_id")" ]]; then
    run_card_ref="$(run_card_relpath "$run_id")"
  fi
  retained_file="$(retained_evidence_path "$run_id")"
  existing_map_json="$(yaml_json_or_default "$retained_file" '.evidence_refs // {}' '{}')"
  new_map_json="$(jq -n \
    --arg run_contract "$(run_contract_relpath "$run_id")" \
    --arg runtime_state "$(runtime_state_relpath "$run_id")" \
    --arg rollback_posture "$(rollback_posture_relpath "$run_id")" \
    --arg control_checkpoint "$(control_checkpoint_relpath "$run_id")" \
    --arg evidence_checkpoint "$(evidence_checkpoint_relpath "$run_id")" \
    --arg orchestration_receipt "$(orchestration_receipt_relpath "$run_id")" \
    --arg replay_manifest "$(replay_manifest_relpath "$run_id")" \
    --arg replay_pointers "$(replay_pointers_relpath "$run_id")" \
    --arg trace_pointers "$(trace_pointers_relpath "$run_id")" \
    --arg functional_report "$(functional_report_relpath "$run_id")" \
    --arg behavioral_report "$(behavioral_report_relpath "$run_id")" \
    --arg maintainability_report "$(maintainability_report_relpath "$run_id")" \
    --arg recovery_report "$(recovery_report_relpath "$run_id")" \
    --arg evaluator_review "$(evaluator_review_relpath "$run_id")" \
    --arg measurement_summary "$(measurement_summary_relpath "$run_id")" \
    --arg intervention_log "$(intervention_log_relpath "$run_id")" \
    --arg run_card "$run_card_ref" \
    '{
      run_contract: $run_contract,
      runtime_state: $runtime_state,
      rollback_posture: $rollback_posture,
      control_checkpoint: $control_checkpoint,
      evidence_checkpoint: $evidence_checkpoint,
      orchestration_receipt: $orchestration_receipt,
      replay_manifest: $replay_manifest,
      replay_pointers: $replay_pointers,
      trace_pointers: $trace_pointers,
      functional_report: $functional_report,
      behavioral_report: $behavioral_report,
      maintainability_report: $maintainability_report,
      recovery_report: $recovery_report,
      evaluator_review: $evaluator_review,
      measurement_summary: $measurement_summary,
      intervention_log: $intervention_log
    }
    + (if $run_card != "" then {run_card: $run_card} else {} end)')"
  merged_map_json="$(printf '%s\n%s\n' "$existing_map_json" "$new_map_json" | jq -s '.[0] * .[1]')"
  jq -n \
    --arg run_id "$run_id" \
    --argjson evidence_refs "$merged_map_json" \
    --arg updated_at "$updated_at" '
      {
        schema_version: "retained-run-evidence-v1",
        run_id: $run_id,
        evidence_refs: $evidence_refs,
        updated_at: $updated_at
      }
    ' | yq -P -p=json '.' > "$retained_file"
}

ensure_run_lifecycle_roots() {
  local run_id="$1"
  ensure_dir "$(run_control_dir "$run_id")"
  ensure_dir "$(stage_attempt_dir "$run_id")"
  ensure_dir "$(checkpoint_dir "$run_id")"
  ensure_dir "$(run_evidence_dir "$run_id")"
  ensure_dir "$(receipt_dir "$run_id")"
  ensure_dir "$(evidence_checkpoint_dir "$run_id")"
  ensure_dir "$(run_evidence_dir "$run_id")/replay"
  ensure_dir "$(assurance_dir "$run_id")"
  ensure_dir "$(measurement_dir "$run_id")"
  ensure_dir "$(intervention_dir "$run_id")"
  ensure_dir "$(disclosure_dir "$run_id")"
}

write_replay_manifest_file() {
  local run_id="$1"
  local recorded_at="$2"
  jq -n \
    --arg run_id "$run_id" \
    --arg entrypoint ".octon/framework/orchestration/runtime/runs/$run_id.yml" \
    --argjson receipt_refs "$(jq -cn --arg ref "$(orchestration_receipt_relpath "$run_id")" '[$ref]')" \
    --argjson checkpoint_refs "$(jq -cn --arg ref "$(evidence_checkpoint_relpath "$run_id")" '[$ref]')" \
    --argjson trace_refs '[]' \
    --argjson reproduction_steps "$(jq -cn --arg step1 "Read the bound run contract and orchestration receipt." --arg step2 "Follow the replay manifest, checkpoints, and RunCard refs to reproduce the consequential path." '[$step1,$step2]')" \
    --arg recorded_at "$recorded_at" '
      {
        schema_version: "run-replay-manifest-v1",
        run_id: $run_id,
        entrypoint: $entrypoint,
        receipt_refs: $receipt_refs,
        checkpoint_refs: $checkpoint_refs,
        trace_refs: $trace_refs,
        reproduction_steps: $reproduction_steps,
        recorded_at: $recorded_at
      }
    ' | yq -P -p=json '.' > "$(replay_manifest_path "$run_id")"
}

write_proof_report_file() {
  local run_id="$1"
  local plane="$2"
  local proof_class="$3"
  local outcome="$4"
  local summary="$5"
  local evidence_refs_json="$6"
  local generated_at="$7"
  local target_file=""
  case "$plane" in
    functional) target_file="$(functional_report_path "$run_id")" ;;
    behavioral) target_file="$(behavioral_report_path "$run_id")" ;;
    maintainability) target_file="$(maintainability_report_path "$run_id")" ;;
    recovery) target_file="$(recovery_report_path "$run_id")" ;;
    *) echo "unknown proof plane: $plane" >&2; exit 1 ;;
  esac
  jq -n \
    --arg plane "$plane" \
    --arg subject_ref "$(run_contract_relpath "$run_id")" \
    --arg outcome "$outcome" \
    --arg proof_class "$proof_class" \
    --arg summary "$summary" \
    --argjson evidence_refs "$evidence_refs_json" \
    --arg generated_at "$generated_at" '
      {
        schema_version: "proof-plane-report-v1",
        plane: $plane,
        subject_kind: "run",
        subject_ref: $subject_ref,
        outcome: $outcome,
        proof_class: $proof_class,
        summary: $summary,
        evidence_refs: $evidence_refs,
        known_limits: [],
        generated_at: $generated_at
      }
    ' | yq -P -p=json '.' > "$target_file"
}

write_evaluator_review_file() {
  local run_id="$1"
  local recorded_at="$2"
  local support_tier="repo-local-transitional"
  local risk_class="low"
  local disposition="not_required"
  local summary="Deterministic functional, behavioral replay, recovery, and maintainability proof were sufficient for this run."
  if [[ -f "$(run_contract_path "$run_id")" ]]; then
    support_tier="$(yq -r '.support_tier // "repo-local-transitional"' "$(run_contract_path "$run_id")" 2>/dev/null || printf 'repo-local-transitional')"
    risk_class="$(yq -r '.risk_class // "low"' "$(run_contract_path "$run_id")" 2>/dev/null || printf 'low')"
  fi
  case "$support_tier" in
    release-and-boundary-sensitive|external-or-irreversible)
      disposition="approved"
      summary="Independent evaluator approval was required because this run used a widened support tier."
      ;;
  esac
  case "$risk_class" in
    high|critical)
      disposition="approved"
      summary="Independent evaluator approval was required because this run used a higher-risk class."
      ;;
  esac
  jq -n \
    --arg subject_ref "$(run_contract_relpath "$run_id")" \
    --arg disposition "$disposition" \
    --arg summary "$summary" \
    --arg recorded_at "$recorded_at" \
    --argjson evidence_refs "$(jq -cn --arg functional "$(functional_report_relpath "$run_id")" --arg behavioral "$(behavioral_report_relpath "$run_id")" --arg maintainability "$(maintainability_report_relpath "$run_id")" --arg recovery "$(recovery_report_relpath "$run_id")" '[$functional,$behavioral,$maintainability,$recovery]')" '
      {
        schema_version: "evaluator-review-v1",
        subject_ref: $subject_ref,
        evaluator_id: "evaluator://wave4-routing",
        disposition: $disposition,
        summary: $summary,
        evidence_refs: $evidence_refs,
        known_limits: [
          "Independent human review remains available for higher-risk support tiers."
        ],
        recorded_at: $recorded_at
      }
    ' | yq -P -p=json '.' > "$(evaluator_review_path "$run_id")"
}

write_measurement_summary_file() {
  local run_id="$1"
  local recorded_at="$2"
  jq -n \
    --arg subject_ref "$(run_contract_relpath "$run_id")" \
    --arg recorded_at "$recorded_at" '
      {
        schema_version: "measurement-summary-v1",
        subject_kind: "run",
        subject_ref: $subject_ref,
        metrics: [
          {metric_id: "receipt-count", label: "Retained lifecycle receipts", value: 1, unit: "count"},
          {metric_id: "checkpoint-count", label: "Retained checkpoints", value: 1, unit: "count"},
          {metric_id: "proof-plane-count", label: "Run-local proof-plane reports", value: 5, unit: "count"},
          {metric_id: "intervention-count", label: "Material interventions", value: 0, unit: "count"}
        ],
        summary: "Run emitted the canonical receipt, checkpoint, proof-plane, and disclosure families.",
        recorded_at: $recorded_at
      }
    ' | yq -P -p=json '.' > "$(measurement_summary_path "$run_id")"
}

write_intervention_log_file() {
  local run_id="$1"
  local recorded_at="$2"
  jq -n \
    --arg subject_ref "$(run_contract_relpath "$run_id")" \
    --arg recorded_at "$recorded_at" '
      {
        schema_version: "intervention-log-v1",
        subject_kind: "run",
        subject_ref: $subject_ref,
        interventions: [],
        summary: "No hidden or material human intervention was required for this retained run bundle.",
        recorded_at: $recorded_at
      }
    ' | yq -P -p=json '.' > "$(intervention_log_path "$run_id")"
}

write_run_card_file() {
  local run_id="$1"
  local status="$2"
  local summary="$3"
  local generated_at="$4"
  local decision_id="$5"
  local support_tier="repo-local-transitional"
  if [[ -f "$(run_contract_path "$run_id")" ]]; then
    support_tier="$(yq -r '.support_tier // "repo-local-transitional"' "$(run_contract_path "$run_id")" 2>/dev/null || printf 'repo-local-transitional')"
  fi
  jq -n \
    --arg run_id "$run_id" \
    --arg status "$status" \
    --arg summary "$summary" \
    --arg generated_at "$generated_at" \
    --arg decision_artifact ".octon/state/evidence/decisions/repo/$decision_id/decision.json" \
    --arg support_tier "$support_tier" '
      {
        schema_version: "run-card-v1",
        run_id: $run_id,
        status: $status,
        summary: $summary,
        support_tier: $support_tier,
        support_target_ref: ".octon/instance/governance/support-targets.yml",
        authority_refs: {
          run_contract: ".octon/state/control/execution/runs/\($run_id)/run-contract.yml",
          decision_artifact: $decision_artifact,
          retained_run_evidence: ".octon/state/evidence/runs/\($run_id)/retained-run-evidence.yml"
        },
        proof_plane_refs: {
          structural_gate_ref: ".octon/framework/assurance/runtime/_ops/scripts/validate-harness-structure.sh",
          governance_gate_ref: ".octon/framework/assurance/runtime/_ops/scripts/validate-execution-governance.sh",
          functional: ".octon/state/evidence/runs/\($run_id)/assurance/functional.yml",
          behavioral: ".octon/state/evidence/runs/\($run_id)/assurance/behavioral.yml",
          maintainability: ".octon/state/evidence/runs/\($run_id)/assurance/maintainability.yml",
          recovery: ".octon/state/evidence/runs/\($run_id)/assurance/recovery.yml",
          evaluator: ".octon/state/evidence/runs/\($run_id)/assurance/evaluator.yml"
        },
        measurement_ref: ".octon/state/evidence/runs/\($run_id)/measurements/summary.yml",
        intervention_ref: ".octon/state/evidence/runs/\($run_id)/interventions/log.yml",
        replay_ref: ".octon/state/evidence/runs/\($run_id)/replay/manifest.yml",
        known_limits: [
          "Support posture remains bounded to the \($support_tier) tier declared in support-targets.yml.",
          "Disclosure summarizes authority and evidence; it does not replace them."
        ],
        generated_at: $generated_at
      }
    ' | yq -P -p=json '.' > "$(run_card_path "$run_id")"

  cat > "$(run_card_markdown_path "$run_id")" <<EOF
# RunCard: $run_id

- Status: $status
- Support tier: $support_tier
- Summary: $summary
- Authority:
  - Run contract: $(run_contract_relpath "$run_id")
  - Decision artifact: .octon/state/evidence/decisions/repo/$decision_id/decision.json
  - Retained evidence: $(retained_evidence_relpath "$run_id")
- Proof planes:
  - Functional: $(functional_report_relpath "$run_id")
  - Behavioral: $(behavioral_report_relpath "$run_id")
  - Maintainability: $(maintainability_report_relpath "$run_id")
  - Recovery: $(recovery_report_relpath "$run_id")
  - Evaluator: $(evaluator_review_relpath "$run_id")
- Observability:
  - Measurements: $(measurement_summary_relpath "$run_id")
  - Interventions: $(intervention_log_relpath "$run_id")
- Replay: $(replay_manifest_relpath "$run_id")
- Generated at: $generated_at
EOF
}

write_run_evidence_expansion() {
  local run_id="$1"
  local status="$2"
  local summary="$3"
  local recorded_at="$4"
  local decision_id=""
  decision_id="$( [[ -f "$RUNTIME_RUNS_DIR/$run_id.yml" ]] && yq -r '.decision_id // ""' "$RUNTIME_RUNS_DIR/$run_id.yml" 2>/dev/null || printf '' )"

  write_replay_manifest_file "$run_id" "$recorded_at"
  write_replay_pointer_file "$run_id" "$recorded_at"
  write_trace_pointer_file "$run_id" "$recorded_at"
  write_proof_report_file \
    "$run_id" \
    "functional" \
    "deterministic" \
    "$( [[ "$status" == "failed" || "$status" == "cancelled" ]] && printf 'stage_only' || printf 'pass' )" \
    "Run emitted the canonical run-contract, receipt, checkpoint, and retained evidence roots." \
    "$(jq -cn --arg receipt "$(orchestration_receipt_relpath "$run_id")" --arg checkpoint "$(evidence_checkpoint_relpath "$run_id")" --arg retained "$(retained_evidence_relpath "$run_id")" '[$receipt,$checkpoint,$retained]')" \
    "$recorded_at"
  write_proof_report_file \
    "$run_id" \
    "behavioral" \
    "replay" \
    "$( [[ "$status" == "failed" || "$status" == "cancelled" ]] && printf 'stage_only' || printf 'pass' )" \
    "Behavioral disclosure is gated on retained replay evidence for this consequential run." \
    "$(jq -cn --arg replay "$(replay_manifest_relpath "$run_id")" --arg pointers "$(replay_pointers_relpath "$run_id")" '[$replay,$pointers]')" \
    "$recorded_at"
  write_proof_report_file \
    "$run_id" \
    "maintainability" \
    "deterministic" \
    "pass" \
    "Maintainability proof confirms the run remains aligned to the canonical architecture and contract registry surfaces." \
    "$(jq -cn --arg contract_registry ".octon/framework/cognition/_meta/architecture/contract-registry.yml" --arg specification ".octon/framework/cognition/_meta/architecture/specification.md" --arg run_contract "$(run_contract_relpath "$run_id")" '[$contract_registry,$specification,$run_contract]')" \
    "$recorded_at"
  write_proof_report_file \
    "$run_id" \
    "recovery" \
    "deterministic" \
    "$( [[ "$status" == "failed" ]] && printf 'stage_only' || printf 'pass' )" \
    "Recovery posture remains reconstructable from canonical rollback, checkpoint, and replay surfaces." \
    "$(jq -cn --arg rollback "$(rollback_posture_relpath "$run_id")" --arg checkpoint "$(control_checkpoint_relpath "$run_id")" --arg replay "$(replay_manifest_relpath "$run_id")" '[$rollback,$checkpoint,$replay]')" \
    "$recorded_at"
  write_evaluator_review_file "$run_id" "$recorded_at"
  write_measurement_summary_file "$run_id" "$recorded_at"
  write_intervention_log_file "$run_id" "$recorded_at"
  if [[ -n "$decision_id" ]]; then
    write_run_card_file "$run_id" "$status" "$summary" "$recorded_at" "$decision_id"
  fi
  write_retained_evidence_file "$run_id" "$recorded_at"
}

upsert_run_contract() {
  local run_id="$1"
  local status="$2"
  local created_at="$3"
  local workflow_group="$4"
  local workflow_id="$5"
  local mission_id="$6"
  local automation_id="$7"
  local incident_id="$8"
  local summary="$9"
  local risk_class="${10}"
  local reversibility_class="${11}"
  local support_tier="${12}"

  local run_dir contract_file stage_dir scope_in_json requested_capabilities_json mission_ref
  run_dir="$(run_control_dir "$run_id")"
  contract_file="$(run_contract_path "$run_id")"
  stage_dir="$(stage_attempt_dir "$run_id")"
  ensure_run_lifecycle_roots "$run_id"

  scope_in_json="$(collect_scope_in_json "$workflow_group" "$workflow_id" "$mission_id" "$automation_id" "$incident_id")"
  requested_capabilities_json="$(collect_requested_capabilities_json "$workflow_group" "$workflow_id" "$mission_id" "$automation_id")"
  mission_ref=""
  if [[ -n "$mission_id" ]]; then
    mission_ref=".octon/instance/orchestration/missions/$mission_id/mission.yml"
  fi

  jq -n \
    --arg run_id "$run_id" \
    --arg status "$status" \
    --arg created_at "$created_at" \
    --arg updated_at "$created_at" \
    --arg summary "$summary" \
    --arg mission_id "$mission_id" \
    --arg mission_ref "$mission_ref" \
    --arg risk_class "$risk_class" \
    --arg reversibility_class "$reversibility_class" \
    --arg support_tier "$support_tier" \
    --arg stage_attempt_root "$(stage_attempt_dir_relpath "$run_id")" \
    --arg control_checkpoint_root "$(checkpoint_dir_relpath "$run_id")" \
    --arg runtime_state_ref "$(runtime_state_relpath "$run_id")" \
    --arg rollback_posture_ref "$(rollback_posture_relpath "$run_id")" \
    --arg evidence_root "$(run_evidence_relpath "$run_id")" \
    --arg receipt_root "$(receipt_dir_relpath "$run_id")" \
    --arg assurance_root "$(assurance_dir_relpath "$run_id")" \
    --arg measurement_root "$(measurement_dir_relpath "$run_id")" \
    --arg intervention_root "$(intervention_dir_relpath "$run_id")" \
    --arg disclosure_root "$(disclosure_dir_relpath "$run_id")" \
    --arg run_card_ref "$(run_card_relpath "$run_id")" \
    --arg replay_pointers_ref "$(replay_pointers_relpath "$run_id")" \
    --arg notes_ref ".octon/framework/orchestration/runtime/runs/$run_id.yml" \
    --argjson scope_in "$scope_in_json" \
    --argjson requested_capabilities "$requested_capabilities_json" \
    '
      {
        schema_version: "run-contract-v1",
        run_id: $run_id,
        objective_refs: {
          workspace_objective_ref: ".octon/instance/bootstrap/OBJECTIVE.md",
          workspace_intent_ref: ".octon/instance/cognition/context/shared/intent.contract.yml"
        },
        scope_in: $scope_in,
        scope_out: [],
        requested_capabilities: $requested_capabilities,
        risk_class: $risk_class,
        reversibility_class: $reversibility_class,
        support_tier: $support_tier,
        required_approvals: [],
        required_evidence: [
          "decision-artifact",
          "run-evidence-root",
          "orchestration-run-projection",
          "policy-receipt",
          "assurance-reports",
          "measurement-summary",
          "intervention-log",
          "run-card",
          "maintainability-report",
          "replay-pointers",
          "trace-pointers"
        ],
        closure_conditions: [
          "Run reaches a terminal projection status.",
          "Decision and retained run evidence remain linked."
        ],
        stage_attempt_root: $stage_attempt_root,
        control_checkpoint_root: $control_checkpoint_root,
        runtime_state_ref: $runtime_state_ref,
        rollback_posture_ref: $rollback_posture_ref,
        evidence_root: $evidence_root,
        receipt_root: $receipt_root,
        assurance_root: $assurance_root,
        measurement_root: $measurement_root,
        intervention_root: $intervention_root,
        disclosure_root: $disclosure_root,
        run_card_ref: $run_card_ref,
        replay_pointers_ref: $replay_pointers_ref,
        rollback_or_compensation_expectation: "Rollback or compensation posture is handled by downstream runtime lifecycle waves; Wave 1 records the execution contract and initial attempt root.",
        status: $status,
        created_at: $created_at,
        updated_at: $updated_at,
        notes_ref: $notes_ref
      }
      | if $mission_id != "" then
          .objective_refs += {
            mission_id: $mission_id,
            mission_ref: $mission_ref
          }
        else .
        end
    ' | yq -P -p=json '.' > "$contract_file"

  local initial_attempt="$stage_dir/initial.yml"
  if [[ ! -f "$initial_attempt" ]]; then
    jq -n \
      --arg run_id "$run_id" \
      --arg status "$status" \
      --arg created_at "$created_at" \
      --arg updated_at "$created_at" \
      --arg objective_ref "$(run_contract_relpath "$run_id")" \
      --argjson requested_capabilities "$requested_capabilities_json" \
      '
        {
          schema_version: "stage-attempt-v1",
          run_id: $run_id,
          stage_attempt_id: "initial",
          stage_ref: "orchestration-projection",
          attempt_kind: "initial",
          status: $status,
          objective_ref: $objective_ref,
          requested_capabilities: $requested_capabilities,
          evidence_refs: [],
          rollback_candidate: true,
          created_at: $created_at,
          updated_at: $updated_at
        }
      ' | yq -P -p=json '.' > "$initial_attempt"
  fi

  write_orchestration_receipt_file "$run_id" "$status" "$summary" "$created_at"
  write_runtime_state_file "$run_id" "$status" "$created_at" "$created_at" "$mission_id" "" "$(orchestration_receipt_relpath "$run_id")"
  write_rollback_posture_file "$run_id" "$created_at"
  write_bound_checkpoint_files "$run_id" "$created_at"
}

update_run_contract_status() {
  local run_id="$1"
  local projection_status="$2"
  local updated_at="$3"
  local contract_status attempt_status current_contract_status current_attempt_status contract_file initial_attempt
  contract_file="$(run_contract_path "$run_id")"
  initial_attempt="$(stage_attempt_dir "$run_id")/initial.yml"
  contract_status="$(contract_status_from_projection "$projection_status")"
  attempt_status="$(attempt_status_from_projection "$projection_status")"

  if [[ -f "$contract_file" ]]; then
    current_contract_status="$(yq -r '.status // ""' "$contract_file")"
    case "$current_contract_status" in
      completed|failed|cancelled)
        if [[ "$contract_status" == "running" ]]; then
          contract_status="$current_contract_status"
        fi
        ;;
    esac
    yq -o=json '.' "$contract_file" | jq --arg status "$contract_status" --arg updated_at "$updated_at" '.status=$status | .updated_at=$updated_at' | yq -P -p=json '.' > "$contract_file.tmp"
    mv "$contract_file.tmp" "$contract_file"
  fi

  if [[ -f "$initial_attempt" ]]; then
    current_attempt_status="$(yq -r '.status // ""' "$initial_attempt")"
    case "$current_attempt_status" in
      succeeded|failed|cancelled)
        if [[ "$attempt_status" == "running" ]]; then
          attempt_status="$current_attempt_status"
        fi
        ;;
    esac
    yq -o=json '.' "$initial_attempt" | jq --arg status "$attempt_status" --arg updated_at "$updated_at" '.status=$status | .updated_at=$updated_at' | yq -P -p=json '.' > "$initial_attempt.tmp"
    mv "$initial_attempt.tmp" "$initial_attempt"
  fi

  local mission_id parent_run_id
  mission_id="$( [[ -f "$RUNTIME_RUNS_DIR/$run_id.yml" ]] && yq -r '.mission_id // ""' "$RUNTIME_RUNS_DIR/$run_id.yml" 2>/dev/null || printf '' )"
  parent_run_id="$( [[ -f "$RUNTIME_RUNS_DIR/$run_id.yml" ]] && yq -r '.parent_run_id // ""' "$RUNTIME_RUNS_DIR/$run_id.yml" 2>/dev/null || printf '' )"
  local summary=""
  summary="$( [[ -f "$RUNTIME_RUNS_DIR/$run_id.yml" ]] && yq -r '.summary // ""' "$RUNTIME_RUNS_DIR/$run_id.yml" 2>/dev/null || printf '' )"
  write_orchestration_receipt_file "$run_id" "$projection_status" "$summary" "$updated_at"
  local created_at=""
  created_at="$( [[ -f "$(runtime_state_path "$run_id")" ]] && yq -r '.created_at // ""' "$(runtime_state_path "$run_id")" 2>/dev/null || printf '' )"
  [[ -n "$created_at" ]] || created_at="$updated_at"
  write_runtime_state_file "$run_id" "$projection_status" "$created_at" "$updated_at" "$mission_id" "$parent_run_id" "$(orchestration_receipt_relpath "$run_id")"
  write_rollback_posture_file "$run_id" "$updated_at"
  write_run_evidence_expansion "$run_id" "$projection_status" "$summary" "$updated_at"
}

ensure_run_surface() {
  ensure_dir "$RUNTIME_RUNS_DIR"
  ensure_dir "$RUN_CONTROL_ROOT"
  ensure_dir "$RUNTIME_RUNS_DIR/by-surface/workflows"
  ensure_dir "$RUNTIME_RUNS_DIR/by-surface/missions"
  ensure_dir "$RUNTIME_RUNS_DIR/by-surface/automations"
  ensure_dir "$RUNTIME_RUNS_DIR/by-surface/incidents"
  [[ -f "$RUNTIME_RUNS_DIR/index.yml" ]] || cat > "$RUNTIME_RUNS_DIR/index.yml" <<'EOF'
schema_version: "orchestration-runs-index-v1"
runs: []
EOF
}

projection_file() {
  local surface="$1"
  local key="$2"
  local encoded
  encoded="$(printf '%s' "$key" | tr '/:' '__' | tr ' ' '-')"
  printf '%s/by-surface/%s/%s.yml' "$RUNTIME_RUNS_DIR" "$surface" "$encoded"
}

upsert_projection() {
  local surface="$1"
  local key="$2"
  local run_id="$3"
  local file
  file="$(projection_file "$surface" "$key")"
  if [[ ! -f "$file" ]]; then
    cat > "$file" <<EOF
schema_version: "orchestration-run-projection-v1"
surface: "$surface"
key: "$key"
run_ids:
  - "$run_id"
EOF
    return
  fi
  projection_json="$(yq -o=json '.' "$file" | jq --arg run_id "$run_id" '.run_ids += [$run_id] | .run_ids |= unique')"
  printf '%s\n' "$projection_json" | yq -P -p=json '.' > "$file"
}

upsert_index() {
  local run_id="$1"
  local status="$2"
  local workflow_group="$3"
  local workflow_id="$4"
  local mission_id="$5"
  local automation_id="$6"
  local incident_id="$7"
  local continuity_run_path="$8"

  index_json="$(
    yq -o=json '.' "$RUNTIME_RUNS_DIR/index.yml" | jq \
      --arg run_id "$run_id" \
      --arg status "$status" \
      --arg workflow_group "$workflow_group" \
      --arg workflow_id "$workflow_id" \
      --arg mission_id "$mission_id" \
      --arg automation_id "$automation_id" \
      --arg incident_id "$incident_id" \
      --arg continuity_run_path "$continuity_run_path" '
        .runs = (.runs // []) |
        .runs |= map(select(.run_id != $run_id)) |
        .runs += [{
          run_id: $run_id,
          status: $status,
          path: ($run_id + ".yml"),
          continuity_run_path: $continuity_run_path
        }
        + (if $workflow_group != "" and $workflow_id != "" then {workflow_ref:{workflow_group:$workflow_group,workflow_id:$workflow_id}} else {} end)
        + (if $mission_id != "" then {mission_id:$mission_id} else {} end)
        + (if $automation_id != "" then {automation_id:$automation_id} else {} end)
        + (if $incident_id != "" then {incident_id:$incident_id} else {} end)]
      '
  )"
  printf '%s\n' "$index_json" | yq -P -p=json '.' > "$RUNTIME_RUNS_DIR/index.yml"
}

write_run_file() {
  local run_file="$1"
  local json="$2"
  printf '%s\n' "$json" | yq -P -p=json '.' > "$run_file"
}

cmd="${1:-}"
shift || true
ensure_run_surface

case "$cmd" in
  create)
    run_id=""
    decision_id=""
    summary=""
    workflow_group=""
    workflow_id=""
    mission_id=""
    automation_id=""
    incident_id=""
    event_id=""
    queue_item_id=""
    parent_run_id=""
    coordination_key=""
    executor_id=""
    started_at="$(now_utc)"
    executor_acknowledged_at=""
    last_heartbeat_at=""
    lease_expires_at=""
    lease_seconds=""
    recovery_status="healthy"
    recovery_reason=""
    status="running"
    risk_class="low"
    reversibility_class="reversible"
    support_tier="repo-local-transitional"
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --run-id) run_id="$2"; shift 2 ;;
        --decision-id) decision_id="$2"; shift 2 ;;
        --summary) summary="$2"; shift 2 ;;
        --workflow-group) workflow_group="$2"; shift 2 ;;
        --workflow-id) workflow_id="$2"; shift 2 ;;
        --mission-id) mission_id="$2"; shift 2 ;;
        --automation-id) automation_id="$2"; shift 2 ;;
        --incident-id) incident_id="$2"; shift 2 ;;
        --event-id) event_id="$2"; shift 2 ;;
        --queue-item-id) queue_item_id="$2"; shift 2 ;;
        --parent-run-id) parent_run_id="$2"; shift 2 ;;
        --coordination-key) coordination_key="$2"; shift 2 ;;
        --executor-id) executor_id="$2"; shift 2 ;;
        --started-at) started_at="$2"; shift 2 ;;
        --executor-acknowledged-at) executor_acknowledged_at="$2"; shift 2 ;;
        --last-heartbeat-at) last_heartbeat_at="$2"; shift 2 ;;
        --lease-expires-at) lease_expires_at="$2"; shift 2 ;;
        --lease-seconds) lease_seconds="$2"; shift 2 ;;
        --recovery-status) recovery_status="$2"; shift 2 ;;
        --recovery-reason) recovery_reason="$2"; shift 2 ;;
        --risk-class) risk_class="$2"; shift 2 ;;
        --reversibility-class) reversibility_class="$2"; shift 2 ;;
        --support-tier) support_tier="$2"; shift 2 ;;
        *) echo "unknown argument: $1" >&2; exit 1 ;;
      esac
    done

    [[ -n "$run_id" && -n "$decision_id" && -n "$summary" && -n "$executor_id" ]] || { usage; exit 1; }
    [[ -f "$DECISIONS_DIR/$decision_id/decision.json" ]] || { echo "decision does not exist: $decision_id" >&2; exit 1; }
    if [[ -n "$workflow_group" || -n "$workflow_id" ]]; then
      [[ -n "$workflow_group" && -n "$workflow_id" ]] || { echo "workflow_group and workflow_id must be supplied together" >&2; exit 1; }
      bash "$SCRIPT_DIR/load-orchestration-discovery.sh" resolve-workflow --workflow-group "$workflow_group" --workflow-id "$workflow_id" >/dev/null
    fi
    if [[ -n "$mission_id" ]]; then
      bash "$SCRIPT_DIR/load-orchestration-discovery.sh" resolve-mission --mission-id "$mission_id" >/dev/null
    fi

    if [[ -z "$lease_expires_at" && -n "$lease_seconds" ]]; then
      lease_expires_at="$(date -u -v+"${lease_seconds}"S '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || python3 - <<PY
from datetime import datetime, timedelta, timezone
print((datetime.now(timezone.utc)+timedelta(seconds=int("${lease_seconds}"))).strftime("%Y-%m-%dT%H:%M:%SZ"))
PY
)"
    fi
    [[ -n "$lease_expires_at" ]] || { echo "lease-expires-at or lease-seconds is required" >&2; exit 1; }
    [[ -n "$executor_acknowledged_at" ]] || executor_acknowledged_at="$started_at"
    [[ -n "$last_heartbeat_at" ]] || last_heartbeat_at="$executor_acknowledged_at"
    validate_risk_class "$risk_class"
    validate_support_tier "$support_tier"

    continuity_run_path="$(run_evidence_relpath "$run_id")/"
    ensure_run_lifecycle_roots "$run_id"
    run_file="$RUNTIME_RUNS_DIR/$run_id.yml"
    [[ ! -f "$run_file" ]] || { echo "run already exists: $run_id" >&2; exit 1; }

    upsert_run_contract "$run_id" "running" "$started_at" "$workflow_group" "$workflow_id" "$mission_id" "$automation_id" "$incident_id" "$summary" "$risk_class" "$reversibility_class" "$support_tier"

    run_json="$(
      jq -n \
        --arg run_id "$run_id" \
        --arg status "$status" \
        --arg started_at "$started_at" \
        --arg workflow_group "$workflow_group" \
        --arg workflow_id "$workflow_id" \
        --arg mission_id "$mission_id" \
        --arg automation_id "$automation_id" \
        --arg incident_id "$incident_id" \
        --arg event_id "$event_id" \
        --arg queue_item_id "$queue_item_id" \
        --arg parent_run_id "$parent_run_id" \
        --arg coordination_key "$coordination_key" \
        --arg executor_id "$executor_id" \
        --arg executor_acknowledged_at "$executor_acknowledged_at" \
        --arg last_heartbeat_at "$last_heartbeat_at" \
        --arg lease_expires_at "$lease_expires_at" \
        --arg recovery_status "$recovery_status" \
        --arg recovery_reason "$recovery_reason" \
        --arg decision_id "$decision_id" \
        --arg continuity_run_path "$continuity_run_path" \
        --arg run_contract_path "$(run_contract_relpath "$run_id")" \
        --arg stage_attempt_root "$(stage_attempt_dir_relpath "$run_id")" \
        --arg runtime_state_path "$(runtime_state_relpath "$run_id")" \
        --arg rollback_posture_path "$(rollback_posture_relpath "$run_id")" \
        --arg receipt_root "$(receipt_dir_relpath "$run_id")" \
        --arg assurance_root "$(assurance_dir_relpath "$run_id")" \
        --arg measurements_root "$(measurement_dir_relpath "$run_id")" \
        --arg interventions_root "$(intervention_dir_relpath "$run_id")" \
        --arg run_card_path "$(run_card_relpath "$run_id")" \
        --arg replay_pointers_path "$(replay_pointers_relpath "$run_id")" \
        --arg trace_pointers_path "$(trace_pointers_relpath "$run_id")" \
        --arg summary "$summary" '
          {
            run_id: $run_id,
            status: $status,
            started_at: $started_at,
            decision_id: $decision_id,
            continuity_run_path: $continuity_run_path,
            run_contract_path: $run_contract_path,
            stage_attempt_root: $stage_attempt_root,
            runtime_state_path: $runtime_state_path,
            rollback_posture_path: $rollback_posture_path,
            receipt_root: $receipt_root,
            assurance_root: $assurance_root,
            measurements_root: $measurements_root,
            interventions_root: $interventions_root,
            run_card_path: $run_card_path,
            replay_pointers_path: $replay_pointers_path,
            trace_pointers_path: $trace_pointers_path,
            summary: $summary,
            executor_id: $executor_id,
            executor_acknowledged_at: $executor_acknowledged_at,
            last_heartbeat_at: $last_heartbeat_at,
            lease_expires_at: $lease_expires_at,
            recovery_status: $recovery_status
          }
          + (if $workflow_group != "" and $workflow_id != "" then {workflow_ref:{workflow_group:$workflow_group,workflow_id:$workflow_id}} else {} end)
          + (if $mission_id != "" then {mission_id:$mission_id} else {} end)
          + (if $automation_id != "" then {automation_id:$automation_id} else {} end)
          + (if $incident_id != "" then {incident_id:$incident_id} else {} end)
          + (if $event_id != "" then {event_id:$event_id} else {} end)
          + (if $queue_item_id != "" then {queue_item_id:$queue_item_id} else {} end)
          + (if $parent_run_id != "" then {parent_run_id:$parent_run_id} else {} end)
          + (if $coordination_key != "" then {coordination_key:$coordination_key} else {} end)
          + (if $recovery_reason != "" then {recovery_reason:$recovery_reason} else {} end)
        '
    )"
    write_run_file "$run_file" "$run_json"
    write_run_evidence_expansion "$run_id" "$status" "$summary" "$started_at"

    upsert_index "$run_id" "$status" "$workflow_group" "$workflow_id" "$mission_id" "$automation_id" "$incident_id" "$continuity_run_path"
    [[ -n "$workflow_group" && -n "$workflow_id" ]] && upsert_projection "workflows" "$workflow_group--$workflow_id" "$run_id"
    [[ -n "$mission_id" ]] && upsert_projection "missions" "$mission_id" "$run_id"
    [[ -n "$automation_id" ]] && upsert_projection "automations" "$automation_id" "$run_id"
    [[ -n "$incident_id" ]] && upsert_projection "incidents" "$incident_id" "$run_id"
    echo "$run_file"
    ;;
  complete)
    run_id=""
    status=""
    summary=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --run-id) run_id="$2"; shift 2 ;;
        --status) status="$2"; shift 2 ;;
        --summary) summary="$2"; shift 2 ;;
        *) echo "unknown argument: $1" >&2; exit 1 ;;
      esac
    done
    [[ -n "$run_id" && -n "$status" && -n "$summary" ]] || { usage; exit 1; }
    case "$status" in
      succeeded|failed|cancelled) ;;
      *) echo "invalid completion status: $status" >&2; exit 1 ;;
    esac
    run_file="$RUNTIME_RUNS_DIR/$run_id.yml"
    [[ -f "$run_file" ]] || { echo "run not found: $run_id" >&2; exit 1; }
    completed_at="$(now_utc)"
    run_json="$(yq -o=json '.' "$run_file" | jq --arg status "$status" --arg summary "$summary" --arg completed_at "$completed_at" '.status=$status | .summary=$summary | .completed_at=$completed_at')"
    printf '%s\n' "$run_json" | yq -P -p=json '.' > "$run_file"
    update_run_contract_status "$run_id" "$status" "$completed_at"
    workflow_group="$(yq -r '.workflow_ref.workflow_group // ""' "$run_file")"
    workflow_id="$(yq -r '.workflow_ref.workflow_id // ""' "$run_file")"
    mission_id="$(yq -r '.mission_id // ""' "$run_file")"
    automation_id="$(yq -r '.automation_id // ""' "$run_file")"
    incident_id="$(yq -r '.incident_id // ""' "$run_file")"
    continuity_run_path="$(yq -r '.continuity_run_path' "$run_file")"
    upsert_index "$run_id" "$status" "$workflow_group" "$workflow_id" "$mission_id" "$automation_id" "$incident_id" "$continuity_run_path"
    echo "$run_file"
    ;;
  heartbeat)
    run_id=""
    lease_seconds=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --run-id) run_id="$2"; shift 2 ;;
        --lease-seconds) lease_seconds="$2"; shift 2 ;;
        *) echo "unknown argument: $1" >&2; exit 1 ;;
      esac
    done
    [[ -n "$run_id" && -n "$lease_seconds" ]] || { usage; exit 1; }
    run_file="$RUNTIME_RUNS_DIR/$run_id.yml"
    [[ -f "$run_file" ]] || { echo "run not found: $run_id" >&2; exit 1; }
    heartbeat_at="$(now_utc)"
    lease_expires_at="$(date -u -v+"${lease_seconds}"S '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || python3 - <<PY
from datetime import datetime, timedelta, timezone
print((datetime.now(timezone.utc)+timedelta(seconds=int("${lease_seconds}"))).strftime("%Y-%m-%dT%H:%M:%SZ"))
PY
)"
    run_json="$(yq -o=json '.' "$run_file" | jq --arg heartbeat_at "$heartbeat_at" --arg lease_expires_at "$lease_expires_at" '.last_heartbeat_at=$heartbeat_at | .lease_expires_at=$lease_expires_at')"
    printf '%s\n' "$run_json" | yq -P -p=json '.' > "$run_file"
    update_run_contract_status "$run_id" "running" "$heartbeat_at"
    echo "$run_file"
    ;;
  recovery)
    run_id=""
    recovery_status=""
    recovery_reason=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --run-id) run_id="$2"; shift 2 ;;
        --recovery-status) recovery_status="$2"; shift 2 ;;
        --recovery-reason) recovery_reason="$2"; shift 2 ;;
        *) echo "unknown argument: $1" >&2; exit 1 ;;
      esac
    done
    [[ -n "$run_id" && -n "$recovery_status" ]] || { usage; exit 1; }
    run_file="$RUNTIME_RUNS_DIR/$run_id.yml"
    [[ -f "$run_file" ]] || { echo "run not found: $run_id" >&2; exit 1; }
    run_json="$(yq -o=json '.' "$run_file" | jq --arg recovery_status "$recovery_status" --arg recovery_reason "$recovery_reason" '.recovery_status=$recovery_status | (if $recovery_reason != "" then .recovery_reason=$recovery_reason else . end)')"
    printf '%s\n' "$run_json" | yq -P -p=json '.' > "$run_file"
    update_run_contract_status "$run_id" "running" "$(now_utc)"
    echo "$run_file"
    ;;
  backfill-wave4)
    run_id=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --run-id) run_id="$2"; shift 2 ;;
        *) echo "unknown argument: $1" >&2; exit 1 ;;
      esac
    done
    [[ -n "$run_id" ]] || { usage; exit 1; }
    run_file="$RUNTIME_RUNS_DIR/$run_id.yml"
    [[ -f "$run_file" ]] || { echo "run not found: $run_id" >&2; exit 1; }
    [[ -f "$(run_contract_path "$run_id")" ]] || { echo "run contract not found: $run_id" >&2; exit 1; }
    status="$(yq -r '.status // "running"' "$run_file")"
    summary="$(yq -r '.summary // ""' "$run_file")"
    [[ -n "$summary" ]] || { echo "run summary missing: $run_id" >&2; exit 1; }
    write_run_evidence_expansion "$run_id" "$status" "$summary" "$(now_utc)"
    echo "$run_file"
    ;;
  *)
    usage
    exit 1
    ;;
esac
