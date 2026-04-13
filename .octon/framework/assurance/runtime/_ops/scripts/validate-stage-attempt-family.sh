#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/closure-packet-common.sh"
require_yq
yq -e '.execution_binding.stage_attempt_schema_ref == ".octon/framework/constitution/contracts/runtime/stage-attempt-v2.schema.json"' "$OCTON_DIR/instance/charter/workspace.yml" >/dev/null
errors=0
while IFS= read -r stage_file; do
  run_id="$(basename "$(dirname "$(dirname "$stage_file")")")"
  [[ "$(yq -r '.schema_version // ""' "$stage_file")" == "stage-attempt-v2" ]] || {
    echo "[ERROR] $run_id stage attempt is not v2" >&2
    errors=$((errors + 1))
    continue
  }
  if [[ "$(yq -r '.mission_mode // ""' "$(run_contract_path "$run_id")")" == "mission-bound" && "$(yq -r '.requires_mission // false' "$(run_contract_path "$run_id")")" == "true" ]]; then
    receipt_path="$OCTON_DIR/state/evidence/runs/$run_id/receipts/stage-action-slice-binding.yml"
    [[ -n "$(yq -r '.action_slice_ref // ""' "$stage_file")" ]] || {
      echo "[ERROR] $run_id representative mission-bound stage attempt is missing action_slice_ref" >&2
      errors=$((errors + 1))
    }
    [[ -f "$receipt_path" ]] || {
      echo "[ERROR] $run_id representative mission-bound stage attempt is missing retained binding receipt" >&2
      errors=$((errors + 1))
    }
  fi
done < <(find "$OCTON_DIR/state/control/execution/runs" -path '*/stage-attempts/*.yml' -print | sort)
[[ $errors -eq 0 ]]
