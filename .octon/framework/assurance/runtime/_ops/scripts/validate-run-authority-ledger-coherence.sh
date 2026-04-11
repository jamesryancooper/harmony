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

echo "== Run Authority Ledger Coherence Validation =="

while IFS= read -r run_id; do
  contract="$(run_contract_path "$run_id")"
  approval_ref="$(yq -r '.required_approvals[0] // ""' "$contract")"
  [[ -n "$approval_ref" ]] || continue
  approval_file="$ROOT_DIR/$approval_ref"
  [[ -f "$approval_file" ]] || { fail "$run_id missing linked approval request"; continue; }

  contract_tier="$(yq -r '.support_tier // .support_target.workload_tier // ""' "$contract")"
  approval_tier="$(yq -r '.support_tier // ""' "$approval_file")"
  [[ -n "$approval_tier" ]] || continue
  [[ "$contract_tier" == "$approval_tier" ]] && pass "$run_id support tier is coherent" || fail "$run_id support tier mismatch: contract=$contract_tier approval=$approval_tier"

  contract_run_id="$(yq -r '.run_id // ""' "$contract")"
  approval_run_id="$(yq -r '.run_id // ""' "$approval_file")"
  [[ "$contract_run_id" == "$approval_run_id" ]] && pass "$run_id run ids are coherent" || fail "$run_id run id mismatch between contract and approval"
done < <(representative_run_ids)

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
