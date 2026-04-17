#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FIXTURES_ROOT="$PACK_ROOT/validation/fixtures/packets"
PACKET_CONTRACT="$PACK_ROOT/prompts/shared/packet-contract.md"
pass_count=0
fail_count=0

pass() { echo "PASS: $1"; pass_count=$((pass_count + 1)); }
fail() { echo "FAIL: $1" >&2; fail_count=$((fail_count + 1)); }

require_file() {
  local file="$1" label="$2"
  if [[ -f "$file" ]]; then
    pass "$label"
  else
    fail "$label"
  fi
}

require_dir() {
  local dir="$1" label="$2"
  if [[ -d "$dir" ]]; then
    pass "$label"
  else
    fail "$label"
  fi
}

validate_manifest() {
  local packet_dir="$1" expected_mode="$2"
  local manifest="$packet_dir/packet.yml"

  if yq -e '.' "$manifest" >/dev/null 2>&1; then
    pass "$(basename "$packet_dir") packet manifest parses"
  else
    fail "$(basename "$packet_dir") packet manifest parses"
    return
  fi

  [[ "$(yq -r '.schema_version // ""' "$manifest")" == "octon-drift-triage-packet-v1" ]] && pass "$(basename "$packet_dir") schema version" || fail "$(basename "$packet_dir") schema version"
  [[ "$(yq -r '.mode // ""' "$manifest")" == "$expected_mode" ]] && pass "$(basename "$packet_dir") mode" || fail "$(basename "$packet_dir") mode"

  for field in packet_id generated_at input_mode changed_paths diff_base diff_head mode selected_checks recommended_bundles repo_hygiene ranking_model_version remediation_items; do
    if yq -e "has(\"$field\")" "$manifest" >/dev/null 2>&1; then
      pass "$(basename "$packet_dir") manifest field $field"
    else
      fail "$(basename "$packet_dir") manifest field $field"
    fi
  done
}

validate_fixture() {
  local packet_dir="$1" expected_mode="$2"
  require_file "$packet_dir/README.md" "$(basename "$packet_dir") README exists"
  require_file "$packet_dir/packet.yml" "$(basename "$packet_dir") packet.yml exists"
  require_file "$packet_dir/reports/changed-paths.md" "$(basename "$packet_dir") changed-paths report exists"
  require_file "$packet_dir/reports/check-selection.md" "$(basename "$packet_dir") check-selection report exists"
  require_file "$packet_dir/reports/check-results.md" "$(basename "$packet_dir") check-results report exists"
  require_file "$packet_dir/reports/ranked-remediation.md" "$(basename "$packet_dir") ranked-remediation report exists"
  require_file "$packet_dir/plans/remediation-plan.md" "$(basename "$packet_dir") remediation plan exists"
  require_file "$packet_dir/prompts/maintainer-remediation-prompt.md" "$(basename "$packet_dir") maintainer prompt exists"
  validate_manifest "$packet_dir" "$expected_mode"

  if [[ "$expected_mode" == "run" ]]; then
    require_dir "$packet_dir/support/raw-check-output" "$(basename "$packet_dir") raw-check-output dir exists"
  else
    if [[ ! -e "$packet_dir/support/raw-check-output" ]]; then
      pass "$(basename "$packet_dir") select mode omits raw-check-output"
    else
      fail "$(basename "$packet_dir") select mode omits raw-check-output"
    fi
  fi
}

validate_contract_doc() {
  for token in \
    'packet.yml' \
    'reports/changed-paths.md' \
    'reports/check-selection.md' \
    'reports/check-results.md' \
    'reports/ranked-remediation.md' \
    'plans/remediation-plan.md' \
    'prompts/maintainer-remediation-prompt.md' \
    'octon-drift-triage-packet-v1'
  do
    if grep -Fq "$token" "$PACKET_CONTRACT"; then
      pass "packet contract mentions $token"
    else
      fail "packet contract mentions $token"
    fi
  done
}

main() {
  validate_contract_doc
  validate_fixture "$FIXTURES_ROOT/select-mode-demo" "select"
  validate_fixture "$FIXTURES_ROOT/run-mode-demo" "run"

  echo
  echo "Passed: $pass_count"
  echo "Failed: $fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
