#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/closure-packet-common.sh"

require_yq
errors=0

fail() {
  echo "[ERROR] $1" >&2
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

echo "== Run Card Ledger Parity Validation =="

while IFS= read -r run_id; do
  card="$(run_card_path "$run_id")"
  contract="$(run_contract_path "$run_id")"
  [[ -f "$contract" ]] || continue

  card_tier="$(yq -r '.support_tier // .support_target_tuple.workload_tier // ""' "$card")"
  contract_tier="$(yq -r '.support_tier // .support_target.workload_tier // ""' "$contract")"
  [[ "$card_tier" == "$contract_tier" ]] && pass "$run_id run-card support tier matches contract" || fail "$run_id run-card support tier mismatch"

  card_run_id="$(yq -r '.run_id // ""' "$card")"
  contract_run_id="$(yq -r '.run_id // ""' "$contract")"
  [[ "$card_run_id" == "$contract_run_id" ]] && pass "$run_id run-card run id matches contract" || fail "$run_id run-card run id mismatch"
done < <(representative_run_ids)

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
