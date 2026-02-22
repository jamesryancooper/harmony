#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COGNITION_DIR="$(cd -- "$SCRIPT_DIR/../../.." && pwd)"
SYNC_SCRIPT="$SCRIPT_DIR/sync-runtime-artifacts.sh"

errors=0

fail() {
  echo "[ERROR] $1"
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

extract_ids() {
  local file="$1"
  awk '
    /^[[:space:]]+- id:[[:space:]]*/ {
      line=$0
      sub(/^[[:space:]]+- id:[[:space:]]*/, "", line)
      gsub(/"/, "", line)
      print line
    }
  ' "$file"
}

check_sorted_and_unique() {
  local file="$1"
  local label="$2"
  local enforce_sorted="${3:-true}"
  local ids

  if [[ ! -f "$file" ]]; then
    fail "missing file for sorted/unique check: ${file#$COGNITION_DIR/}"
    return
  fi

  ids="$(extract_ids "$file")"
  if [[ -z "$ids" ]]; then
    pass "$label has no id records (allowed)"
    return
  fi

  local dupes
  dupes="$(printf '%s\n' "$ids" | sort | uniq -d || true)"
  if [[ -n "$dupes" ]]; then
    fail "$label contains duplicate ids: $(echo "$dupes" | paste -sd ', ' -)"
  else
    pass "$label ids are unique"
  fi

  if [[ "$enforce_sorted" != "true" ]]; then
    pass "$label order enforcement skipped"
    return
  fi

  local sorted
  sorted="$(printf '%s\n' "$ids" | sort)"
  if [[ "$sorted" != "$ids" ]]; then
    fail "$label ids must be sorted lexicographically"
  else
    pass "$label ids are sorted"
  fi
}

check_decisions_summary_contract() {
  local summary="$COGNITION_DIR/runtime/context/decisions.md"
  if [[ ! -f "$summary" ]]; then
    fail "missing generated decisions summary: runtime/context/decisions.md"
    return
  fi

  if rg -q '^mutability:[[:space:]]*generated$' "$summary"; then
    pass "decisions summary mutability contract is generated"
  else
    fail "decisions summary must declare mutability: generated"
  fi

  if rg -q '^generated_from:' "$summary"; then
    pass "decisions summary generated_from contract present"
  else
    fail "decisions summary missing generated_from contract"
  fi
}

main() {
  echo "== Validate Generated Cognition Runtime Artifacts =="

  if [[ ! -f "$SYNC_SCRIPT" ]]; then
    fail "missing sync script: ${SYNC_SCRIPT#$COGNITION_DIR/}"
  elif bash "$SYNC_SCRIPT" --check; then
    pass "generated artifact sync check passed"
  else
    fail "generated artifact sync check failed"
  fi

  check_sorted_and_unique "$COGNITION_DIR/runtime/decisions/index.yml" "runtime decision index"
  check_sorted_and_unique "$COGNITION_DIR/runtime/migrations/index.yml" "runtime migration index" false
  check_sorted_and_unique "$COGNITION_DIR/runtime/evaluations/actions/open-actions.yml" "evaluation open-action ledger"
  check_decisions_summary_contract

  echo "Validation summary: errors=$errors"
  if [[ $errors -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
