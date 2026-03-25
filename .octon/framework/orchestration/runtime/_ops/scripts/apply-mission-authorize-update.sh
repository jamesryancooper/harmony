#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../.." && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"
RECEIPT_WRITER="$SCRIPT_DIR/write-mission-control-receipt.sh"
ROUTE_PUBLISHER="$SCRIPT_DIR/publish-mission-effective-route.sh"
SYNC_RUNTIME_ARTIFACTS="$OCTON_DIR/framework/cognition/_ops/runtime/scripts/sync-runtime-artifacts.sh"

MISSION_ID=""
AUTHORIZE_UPDATE_ID=""
ISSUED_BY=""
KIND=""
TTL_SECONDS=3600

usage() {
  cat <<'USAGE'
Usage:
  apply-mission-authorize-update.sh --mission-id <id> --authorize-update-id <id> --issued-by <ref> --kind approve|extend_lease|revoke_lease|raise_budget|grant_exception|reset_breaker|enter_break_glass|exit_break_glass [--ttl-seconds <n>]
USAGE
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --mission-id) MISSION_ID="$2"; shift 2 ;;
      --authorize-update-id) AUTHORIZE_UPDATE_ID="$2"; shift 2 ;;
      --issued-by) ISSUED_BY="$2"; shift 2 ;;
      --kind) KIND="$2"; shift 2 ;;
      --ttl-seconds) TTL_SECONDS="$2"; shift 2 ;;
      -h|--help) usage; exit 0 ;;
      *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    esac
  done

  [[ -n "$MISSION_ID" ]] || { echo "--mission-id is required" >&2; exit 1; }
  [[ -n "$AUTHORIZE_UPDATE_ID" ]] || { echo "--authorize-update-id is required" >&2; exit 1; }
  [[ -n "$ISSUED_BY" ]] || { echo "--issued-by is required" >&2; exit 1; }
  [[ -n "$KIND" ]] || { echo "--kind is required" >&2; exit 1; }

  case "$KIND" in
    break_glass_activate) KIND="enter_break_glass" ;;
    break_glass_clear) KIND="exit_break_glass" ;;
  esac

  local control_dir="$OCTON_DIR/state/control/execution/missions/$MISSION_ID"
  local mode_state_file="$control_dir/mode-state.yml"
  local lease_file="$control_dir/lease.yml"
  local budget_file="$control_dir/autonomy-budget.yml"
  local breaker_file="$control_dir/circuit-breakers.yml"
  local authorize_updates_file="$control_dir/authorize-updates.yml"
  [[ -f "$mode_state_file" ]] || { echo "missing mode-state: ${mode_state_file#$ROOT_DIR/}" >&2; exit 1; }
  [[ -f "$authorize_updates_file" ]] || { echo "missing authorize-updates: ${authorize_updates_file#$ROOT_DIR/}" >&2; exit 1; }

  local ts expires_at revision receipt_type reason_code receipt_path affected_paths=()
  ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  expires_at="$(jq -nr --arg ts "$ts" --argjson seconds "$TTL_SECONDS" '$ts | fromdateiso8601 + $seconds | todateiso8601')"
  revision="$(yq -r '.revision // 0' "$authorize_updates_file")"
  revision="$((revision + 1))"

  UPDATE_ID="$AUTHORIZE_UPDATE_ID" \
  UPDATE_TYPE="$KIND" \
  ISSUER_REF="$ISSUED_BY" \
  ISSUED_AT="$ts" \
  EXPIRES_AT="$expires_at" \
  REVISION="$revision" \
  yq -i '
    .revision = (strenv(REVISION) | tonumber) |
    .authorize_updates += [{
      "update_id": strenv(UPDATE_ID),
      "type": strenv(UPDATE_TYPE),
      "state": "pending",
      "issuer_ref": strenv(ISSUER_REF),
      "issued_at": strenv(ISSUED_AT),
      "expires_at": strenv(EXPIRES_AT),
      "payload": {},
      "applied_by_receipt_ref": null
    }]
  ' "$authorize_updates_file"
  affected_paths+=(".octon/state/control/execution/missions/$MISSION_ID/authorize-updates.yml")

  case "$KIND" in
    approve)
      receipt_type="authorize_update_apply"
      reason_code="MISSION_APPROVED"
      ;;
    extend_lease)
      [[ -f "$lease_file" ]] || { echo "missing lease: ${lease_file#$ROOT_DIR/}" >&2; exit 1; }
      EXPIRES_AT="$expires_at" yq -i '.expires_at = strenv(EXPIRES_AT) | .last_reviewed_at = strenv(EXPIRES_AT)' "$lease_file"
      receipt_type="authorize_update_apply"
      reason_code="MISSION_LEASE_EXTENDED"
      affected_paths+=(".octon/state/control/execution/missions/$MISSION_ID/lease.yml")
      ;;
    revoke_lease)
      [[ -f "$lease_file" ]] || { echo "missing lease: ${lease_file#$ROOT_DIR/}" >&2; exit 1; }
      ISSUED_AT="$ts" yq -i '.state = "revoked" | .revocation_reason = "authorize_update" | .last_reviewed_at = strenv(ISSUED_AT) | .expires_at = strenv(ISSUED_AT)' "$lease_file"
      receipt_type="authorize_update_apply"
      reason_code="MISSION_LEASE_REVOKED"
      affected_paths+=(".octon/state/control/execution/missions/$MISSION_ID/lease.yml")
      ;;
    raise_budget)
      [[ -f "$budget_file" ]] || { echo "missing autonomy-budget: ${budget_file#$ROOT_DIR/}" >&2; exit 1; }
      UPDATED_AT="$ts" yq -i '.state = "healthy" | .updated_at = strenv(UPDATED_AT) | .last_recomputed_at = strenv(UPDATED_AT) | .applied_mode_adjustments += ["authorize_update:raise_budget"]' "$budget_file"
      receipt_type="budget_transition"
      reason_code="MISSION_BUDGET_RAISED"
      affected_paths+=(".octon/state/control/execution/missions/$MISSION_ID/autonomy-budget.yml")
      ;;
    grant_exception)
      receipt_type="authorize_update_apply"
      reason_code="MISSION_EXCEPTION_GRANTED"
      ;;
    reset_breaker)
      [[ -f "$breaker_file" ]] || { echo "missing circuit-breakers: ${breaker_file#$ROOT_DIR/}" >&2; exit 1; }
      UPDATED_AT="$ts" yq -i '.state = "clear" | .trip_reasons = [] | .applied_actions = [] | .tripped_breakers = [] | .reset_ref = "authorize_update" | .reset_receipt_ref = null | .updated_at = strenv(UPDATED_AT)' "$breaker_file"
      BREAKER_STATE="clear" UPDATED_AT="$ts" yq -i '.breaker_state = strenv(BREAKER_STATE) | .updated_at = strenv(UPDATED_AT)' "$mode_state_file"
      receipt_type="breaker_reset"
      reason_code="MISSION_BREAKER_RESET"
      affected_paths+=(".octon/state/control/execution/missions/$MISSION_ID/circuit-breakers.yml")
      affected_paths+=(".octon/state/control/execution/missions/$MISSION_ID/mode-state.yml")
      ;;
    enter_break_glass)
      BREAK_GLASS_EXPIRES_AT="$expires_at" UPDATED_AT="$ts" yq -i '.safety_state = "break_glass" | .break_glass_expires_at = strenv(BREAK_GLASS_EXPIRES_AT) | .updated_at = strenv(UPDATED_AT)' "$mode_state_file"
      receipt_type="break_glass_enter"
      reason_code="BREAK_GLASS_ACTIVATED"
      affected_paths+=(".octon/state/control/execution/missions/$MISSION_ID/mode-state.yml")
      ;;
    exit_break_glass)
      UPDATED_AT="$ts" yq -i '.safety_state = "paused" | .break_glass_expires_at = null | .updated_at = strenv(UPDATED_AT)' "$mode_state_file"
      receipt_type="break_glass_exit"
      reason_code="BREAK_GLASS_CLEARED"
      affected_paths+=(".octon/state/control/execution/missions/$MISSION_ID/mode-state.yml")
      ;;
    *)
      echo "unsupported authorize-update kind: $KIND" >&2
      exit 1
      ;;
  esac

  bash "$ROUTE_PUBLISHER" --mission-id "$MISSION_ID" >/dev/null
  affected_paths+=(".octon/generated/effective/orchestration/missions/$MISSION_ID/scenario-resolution.yml")

  if [[ -x "$SYNC_RUNTIME_ARTIFACTS" ]]; then
    bash "$SYNC_RUNTIME_ARTIFACTS" --target missions >/dev/null
    affected_paths+=(".octon/generated/cognition/summaries/missions/$MISSION_ID/now.md")
    affected_paths+=(".octon/generated/cognition/projections/materialized/missions/$MISSION_ID/mission-view.yml")
  fi

  local -a receipt_args=(
    --mission-id "$MISSION_ID"
    --receipt-type "$receipt_type"
    --issued-by "$ISSUED_BY"
    --reason "Apply mission authorize update $KIND"
    --new-state-ref ".octon/state/control/execution/missions/$MISSION_ID/authorize-updates.yml"
    --reason-code "$reason_code"
    --policy-ref ".octon/instance/governance/policies/mission-autonomy.yml"
    --policy-ref ".octon/framework/capabilities/governance/policy/deny-by-default.v2.yml"
    --authorize-update-ref "$AUTHORIZE_UPDATE_ID"
  )
  local affected_path
  for affected_path in "${affected_paths[@]}"; do
    receipt_args+=(--affected-path "$affected_path")
  done
  receipt_path="$(bash "$RECEIPT_WRITER" "${receipt_args[@]}")"

  RECEIPT_PATH="${receipt_path#$ROOT_DIR/}" \
  UPDATE_ID="$AUTHORIZE_UPDATE_ID" \
  yq -i '
    (.authorize_updates[] | select(.update_id == strenv(UPDATE_ID))).state = "applied" |
    (.authorize_updates[] | select(.update_id == strenv(UPDATE_ID))).applied_by_receipt_ref = strenv(RECEIPT_PATH)
  ' "$authorize_updates_file"
}

main "$@"
