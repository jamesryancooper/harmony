#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../.." && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"
RECEIPT_WRITER="$SCRIPT_DIR/write-mission-control-receipt.sh"

MISSION_ID=""
ISSUED_BY=""

usage() {
  cat <<'USAGE'
Usage:
  seed-mission-autonomy-state.sh --mission-id <id> [--issued-by <ref>]
USAGE
}

read_array_yaml() {
  local file="$1"
  local query="$2"
  yq -r "$query[]?" "$file" 2>/dev/null || true
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --mission-id) MISSION_ID="$2"; shift 2 ;;
      --issued-by) ISSUED_BY="$2"; shift 2 ;;
      -h|--help) usage; exit 0 ;;
      *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    esac
  done

  [[ -n "$MISSION_ID" ]] || { echo "--mission-id is required" >&2; exit 1; }

  local mission_dir="$OCTON_DIR/instance/orchestration/missions/$MISSION_ID"
  local mission_file="$mission_dir/mission.yml"
  local policy_file="$OCTON_DIR/instance/governance/policies/mission-autonomy.yml"
  local control_dir="$OCTON_DIR/state/control/execution/missions/$MISSION_ID"
  local continuity_dir="$OCTON_DIR/state/continuity/repo/missions/$MISSION_ID"
  [[ -f "$mission_file" ]] || { echo "missing mission charter: ${mission_file#$ROOT_DIR/}" >&2; exit 1; }
  [[ -f "$policy_file" ]] || { echo "missing mission autonomy policy: ${policy_file#$ROOT_DIR/}" >&2; exit 1; }

  local mission_class owner_ref overlap_policy backfill_policy oversight_mode execution_posture
  mission_class="$(yq -r '.mission_class // ""' "$mission_file")"
  owner_ref="$(yq -r '.owner_ref // ""' "$mission_file")"
  [[ -n "$mission_class" ]] || { echo "mission_class missing in ${mission_file#$ROOT_DIR/}" >&2; exit 1; }
  [[ -n "$owner_ref" ]] || { echo "owner_ref missing in ${mission_file#$ROOT_DIR/}" >&2; exit 1; }
  [[ -n "$ISSUED_BY" ]] || ISSUED_BY="$owner_ref"

  oversight_mode="$(yq -r ".mode_defaults.\"$mission_class\" // \"notify\"" "$policy_file")"
  execution_posture="$(yq -r ".execution_postures.\"$mission_class\" // \"interruptible_scheduled\"" "$policy_file")"
  overlap_policy="$(yq -r ".overlap_defaults.\"$mission_class\" // .default_overlap_policy // \"skip\"" "$policy_file")"
  backfill_policy="$(yq -r ".backfill_defaults.\"$mission_class\" // \"none\"" "$policy_file")"

  mkdir -p "$control_dir" "$continuity_dir"

  local ts
  ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  {
    printf 'schema_version: "mission-control-lease-v1"\n'
    printf 'mission_id: "%s"\n' "$MISSION_ID"
    printf 'lease_id: "seed-%s"\n' "$MISSION_ID"
    printf 'status: "paused"\n'
    printf 'granted_by: "%s"\n' "$ISSUED_BY"
    printf 'granted_at: "%s"\n' "$ts"
    printf 'expires_at: "2099-01-01T00:00:00Z"\n'
    printf 'max_concurrent_runs: 1\n'
    printf 'allowed_action_classes:\n'
    while IFS= read -r value; do
      [[ -n "$value" ]] || continue
      printf '  - "%s"\n' "$value"
    done < <(read_array_yaml "$mission_file" '.allowed_action_classes')
    printf 'default_safing_subset:\n'
    while IFS= read -r value; do
      [[ -n "$value" ]] || continue
      printf '  - "%s"\n' "$value"
    done < <(read_array_yaml "$mission_file" '.default_safing_subset')
  } > "$control_dir/lease.yml"

  cat > "$control_dir/mode-state.yml" <<EOF
schema_version: "mode-state-v1"
mission_id: "$MISSION_ID"
oversight_mode: "$oversight_mode"
execution_posture: "$execution_posture"
safety_state: "paused"
phase: "planning"
active_run_id: null
current_slice_id: null
next_safe_interrupt_boundary: null
autonomy_budget_state: "healthy"
breaker_state: "healthy"
EOF

  cat > "$control_dir/intent-register.yml" <<EOF
schema_version: "intent-register-v1"
mission_id: "$MISSION_ID"
version: 1
entries: []
EOF

  cat > "$control_dir/directives.yml" <<EOF
schema_version: "control-directives-v1"
mission_id: "$MISSION_ID"
directives: []
EOF

  cat > "$control_dir/schedule.yml" <<EOF
schema_version: "schedule-control-v1"
mission_id: "$MISSION_ID"
future_run_status: "active"
active_run_pause: "paused-until-resume"
overlap_policy: "$overlap_policy"
backfill_policy: "$backfill_policy"
pause_on_failure:
  enabled: true
  triggers:
EOF
  while IFS= read -r trigger; do
    [[ -n "$trigger" ]] || continue
    printf '    - "%s"\n' "$trigger" >> "$control_dir/schedule.yml"
  done < <(read_array_yaml "$policy_file" '.pause_on_failure.default_triggers')

  cat > "$control_dir/autonomy-budget.yml" <<EOF
schema_version: "autonomy-budget-v1"
mission_id: "$MISSION_ID"
state: "healthy"
updated_at: "$ts"
counters: {}
EOF

  cat > "$control_dir/circuit-breakers.yml" <<EOF
schema_version: "circuit-breaker-v1"
mission_id: "$MISSION_ID"
state: "healthy"
updated_at: "$ts"
tripped_breakers: []
EOF

  cat > "$control_dir/subscriptions.yml" <<EOF
schema_version: "mission-subscriptions-v1"
mission_id: "$MISSION_ID"
owner_routes:
  - "$owner_ref"
subscribers: []
EOF

  cat > "$continuity_dir/next-actions.yml" <<EOF
schema_version: "mission-next-actions-v1"
mission_id: "$MISSION_ID"
next_actions: []
EOF

  cat > "$continuity_dir/handoff.md" <<EOF
# Mission Handoff

- mission_id: \`$MISSION_ID\`
- status: \`seeded\`
- next_safe_action: \`review mission charter and resume the paused lease intentionally\`
EOF

  bash "$RECEIPT_WRITER" \
    --mission-id "$MISSION_ID" \
    --receipt-type "mission-seed" \
    --issued-by "$ISSUED_BY" \
    --reason "Seed mission autonomy control and continuity state" \
    --affected-path ".octon/state/control/execution/missions/$MISSION_ID/lease.yml" \
    --affected-path ".octon/state/control/execution/missions/$MISSION_ID/mode-state.yml" \
    --affected-path ".octon/state/control/execution/missions/$MISSION_ID/intent-register.yml" \
    --affected-path ".octon/state/control/execution/missions/$MISSION_ID/directives.yml" \
    --affected-path ".octon/state/control/execution/missions/$MISSION_ID/schedule.yml" \
    --affected-path ".octon/state/control/execution/missions/$MISSION_ID/autonomy-budget.yml" \
    --affected-path ".octon/state/control/execution/missions/$MISSION_ID/circuit-breakers.yml" \
    --affected-path ".octon/state/control/execution/missions/$MISSION_ID/subscriptions.yml" \
    --affected-path ".octon/state/continuity/repo/missions/$MISSION_ID/next-actions.yml" \
    --affected-path ".octon/state/continuity/repo/missions/$MISSION_ID/handoff.md" \
    >/dev/null
}

main "$@"
