#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_packet2_fixture_lib.sh"

pass_count=0
fail_count=0
declare -a CLEANUP_DIRS=()

cleanup() {
  local dir
  for dir in "${CLEANUP_DIRS[@]}"; do
    [[ -n "$dir" ]] && rm -r -f -- "$dir"
  done
}
trap cleanup EXIT

pass() { echo "PASS: $1"; pass_count=$((pass_count + 1)); }
fail() { echo "FAIL: $1" >&2; fail_count=$((fail_count + 1)); }

assert_success() {
  local name="$1"
  shift
  if "$@"; then
    pass "$name"
  else
    fail "$name"
  fi
}

prepare_fixture() {
  local fixture_root="$1"
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"
}

run_validator() {
  local fixture_root="$1"
  OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" \
    bash "$fixture_root/.octon/framework/assurance/runtime/_ops/scripts/validate-architecture-conformance.sh" >/dev/null
}

case_valid_fixture_passes() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  prepare_fixture "$fixture_root"
  run_validator "$fixture_root"
}

case_net_http_default_fails() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  prepare_fixture "$fixture_root"

  cat >>"$fixture_root/.octon/framework/engine/runtime/config/policy.yml" <<'EOF'
      - net.http
EOF

  ! run_validator "$fixture_root"
}

case_legacy_state_dir_fails() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  prepare_fixture "$fixture_root"

  cat >"$fixture_root/.octon/framework/engine/runtime/crates/core/src/config.rs" <<'EOF'
pub struct RuntimeConfig {
    pub state_dir: String,
}
EOF

  ! run_validator "$fixture_root"
}

case_missing_registry_fails() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  prepare_fixture "$fixture_root"

  rm "$fixture_root/.octon/framework/cognition/_meta/architecture/contract-registry.yml"

  ! run_validator "$fixture_root"
}

main() {
  assert_success "architecture conformance validator passes for coherent fixture" case_valid_fixture_passes
  assert_success "architecture conformance validator fails when execution/flow regains ambient net.http" case_net_http_default_fails
  assert_success "architecture conformance validator fails when legacy runtime state_dir returns" case_legacy_state_dir_fails
  assert_success "architecture conformance validator fails when the contract registry is missing" case_missing_registry_fails

  echo
  echo "Passed: $pass_count"
  echo "Failed: $fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
