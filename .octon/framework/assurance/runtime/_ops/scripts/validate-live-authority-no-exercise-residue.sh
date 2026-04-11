#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/closure-packet-common.sh"

errors=0

fail() {
  echo "[ERROR] $1" >&2
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

echo "== Live Authority No-Exercise-Residue Validation =="

check_file() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  if rg -n 'safe-stage|governance/exercise|example\.invalid|LIVE_SAFE_STAGE' "$file" >/dev/null 2>&1; then
    fail "exercise residue detected in $file"
  else
    pass "no exercise residue in $file"
  fi
}

while IFS= read -r run_id; do
  check_file "$(run_contract_path "$run_id")"
  approval_ref="$(yq -r '.required_approvals[0] // ""' "$(run_contract_path "$run_id")")"
  [[ -n "$approval_ref" ]] && check_file "$ROOT_DIR/$approval_ref"
  decision_ref="$(yq -r '.decision_artifact_ref // ""' "$(run_manifest_path "$run_id")")"
  [[ -n "$decision_ref" ]] && check_file "$ROOT_DIR/$decision_ref"
  grant_ref="$(yq -r '.authority_grant_bundle_ref // ""' "$(run_manifest_path "$run_id")")"
  [[ -n "$grant_ref" ]] && check_file "$ROOT_DIR/$grant_ref"
  if [[ -n "$decision_ref" ]]; then
    while IFS= read -r ref; do
      [[ -n "$ref" ]] && check_file "$ROOT_DIR/$ref"
    done < <(yq -r '.exception_refs[]?, .revocation_refs[]?' "$ROOT_DIR/$decision_ref" 2>/dev/null || true)
  fi
done < <(representative_run_ids)

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
