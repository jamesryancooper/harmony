#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/../runtime/_ops/scripts/closure-packet-common.sh"

require_yq
errors=0

while IFS= read -r run_id; do
  contract="$(run_contract_path "$run_id")"
  expected_mission="$(requires_mission_for_run "$run_id")"
  expected_ref="$(admission_ref_for_run "$run_id")"
  [[ "$(yq -r '.requires_mission // false' "$contract")" == "$expected_mission" ]] || {
    echo "[ERROR] requires_mission mismatch for $run_id" >&2
    errors=$((errors + 1))
  }
  [[ "$(yq -r '.support_target_admission_ref // ""' "$contract")" == "$expected_ref" ]] || {
    echo "[ERROR] admission ref mismatch for $run_id" >&2
    errors=$((errors + 1))
  }
done < <(representative_run_ids)

[[ $errors -eq 0 ]]
