#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"
POLICY_FILE="${GITHUB_ACTION_PIN_POLICY_FILE:-$OCTON_DIR/framework/assurance/runtime/contracts/github-action-pin-policy.yml}"

errors=0

fail() {
  echo "[ERROR] $1"
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

require_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    pass "found file: ${file#$ROOT_DIR/}"
  else
    fail "missing file: ${file#$ROOT_DIR/}"
  fi
}

is_local_action() {
  local action_ref="$1"
  [[ "$action_ref" == ./* || "$action_ref" == .github/* ]]
}

ref_is_disallowed() {
  local ref="$1"
  local pattern
  while IFS= read -r pattern; do
    [[ -n "$pattern" ]] || continue
    if [[ "$ref" =~ $pattern ]]; then
      return 0
    fi
  done < <(yq -r '.disallowed_ref_patterns[]?' "$POLICY_FILE")
  return 1
}

main() {
  echo "== GitHub Action Pin Validation =="

  require_file "$POLICY_FILE"

  if ! command -v yq >/dev/null 2>&1; then
    fail "yq is required for GitHub Action pin validation"
    exit 1
  fi

  if [[ "$(yq -r '.schema_version // ""' "$POLICY_FILE")" == "github-action-pin-policy-v1" ]]; then
    pass "GitHub Action pin policy schema version is correct"
  else
    fail "GitHub Action pin policy schema version must be github-action-pin-policy-v1"
  fi

  local workflow_path
  while IFS= read -r workflow_path; do
    [[ -n "$workflow_path" ]] || continue
    require_file "$ROOT_DIR/$workflow_path"

    local match
    while IFS= read -r match; do
      [[ -n "$match" ]] || continue
      local line_no line uses_value action_source action_ref
      line_no="${match%%:*}"
      line="${match#*:}"
      uses_value="$(printf '%s\n' "$line" | sed -E 's/^[[:space:]]*uses:[[:space:]]*//; s/[[:space:]]+#.*$//')"
      action_source="${uses_value%@*}"
      action_ref="${uses_value##*@}"

      if yq -e '.allow_local_actions == true' "$POLICY_FILE" >/dev/null 2>&1 && is_local_action "$action_source"; then
        continue
      fi

      if [[ ! "$action_ref" =~ ^[0-9a-f]{40}$ ]]; then
        fail "$workflow_path:$line_no must pin '$action_source' to a full 40-character commit SHA"
        continue
      fi

      if ref_is_disallowed "$action_ref"; then
        fail "$workflow_path:$line_no uses a disallowed mutable ref: $action_ref"
      else
        pass "$workflow_path:$line_no pins '$action_source' immutably"
      fi
    done < <(rg -n '^[[:space:]]*uses:[[:space:]]*[^[:space:]#]+@[^[:space:]#]+' "$ROOT_DIR/$workflow_path" || true)
  done < <(yq -r '.workflow_globs[]?' "$POLICY_FILE")

  echo "Validation summary: errors=$errors"
  if [[ "$errors" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
