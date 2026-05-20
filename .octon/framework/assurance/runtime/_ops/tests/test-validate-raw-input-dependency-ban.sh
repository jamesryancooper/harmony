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

run_validator() {
  local fixture_root="$1"
  OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" \
    bash "$fixture_root/.octon/framework/assurance/runtime/_ops/scripts/validate-raw-input-dependency-ban.sh" >/dev/null
}

case_engine_governance_reference_fails() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"
  cp "$REPO_ROOT/.octon/framework/assurance/runtime/_ops/scripts/validate-raw-input-dependency-ban.sh" \
    "$fixture_root/.octon/framework/assurance/runtime/_ops/scripts/validate-raw-input-dependency-ban.sh"
  chmod +x "$fixture_root/.octon/framework/assurance/runtime/_ops/scripts/validate-raw-input-dependency-ban.sh"

  mkdir -p "$fixture_root/.octon/framework/engine/governance"
  cat >"$fixture_root/.octon/framework/engine/governance/raw-input-leak.md" <<'EOF'
# Invalid

Runtime policy must read `.octon/inputs/additive/.incoming/example/pack.yml`.
EOF

  ! run_validator "$fixture_root"
}

case_allowed_intake_governance_passes() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  run_validator "$fixture_root"
}

write_leak_and_expect_failure() {
  local rel="$1"
  local body="$2"
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  mkdir -p "$(dirname "$fixture_root/$rel")"
  printf '%s\n' "$body" >"$fixture_root/$rel"

  ! run_validator "$fixture_root"
}

case_generated_capability_routing_incoming_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/generated/effective/capabilities/routing.effective.yml" \
    'source_path: ".octon/inputs/additive/.incoming/bad-intake/README.md"'
}

case_generated_extension_catalog_archive_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/generated/effective/extensions/catalog.effective.yml" \
    'manifest_path: ".octon/inputs/additive/.archive/bad-intake/README.md"'
}

case_state_control_incoming_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/state/control/extensions/active.yml" \
    'path: ".octon/inputs/additive/.incoming/bad-intake/README.md"'
}

case_host_projection_incoming_leak_fails() {
  write_leak_and_expect_failure \
    ".codex/commands/raw-intake-leak.md" \
    'Read `.octon/inputs/additive/.incoming/bad-intake/README.md` as live command authority.'
}

case_workflow_registry_incoming_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/framework/orchestration/runtime/workflows/registry.yml" \
    'path: "/.octon/inputs/additive/.incoming/bad-intake/"'
}

case_command_manifest_incoming_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/framework/capabilities/runtime/commands/manifest.yml" \
    'source_path: ".octon/inputs/additive/.incoming/bad-intake/README.md"'
}

case_instance_governance_incoming_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/instance/governance/policies/raw-intake.yml" \
    'policy_source: ".octon/inputs/additive/.incoming/bad-intake/README.md"'
}

case_generated_cognition_archive_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/generated/cognition/projections/raw-intake.yml" \
    'source_path: ".octon/inputs/additive/.archive/bad-intake/README.md"'
}

case_generated_proposals_incoming_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/generated/proposals/registry.yml" \
    'path: ".octon/inputs/additive/.incoming/bad-intake/README.md"'
}

case_rust_incoming_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/framework/engine/runtime/spec/raw_intake.rs" \
    'const RAW_INTAKE: &str = ".octon/inputs/additive/.incoming/bad-intake/README.md";'
}

case_python_archive_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/framework/capabilities/_ops/scripts/raw_intake.py" \
    'RAW_INTAKE = ".octon/inputs/additive/.archive/bad-intake/README.md"'
}

case_toml_incoming_leak_fails() {
  write_leak_and_expect_failure \
    ".octon/framework/engine/runtime/config/raw-intake.toml" \
    'source_path = ".octon/inputs/additive/.incoming/bad-intake/README.md"'
}

case_allowed_governance_requires_non_authority_semantics() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  cat >"$fixture_root/.octon/framework/engine/governance/inputs/additive/incoming-intake-processing.md" <<'EOF'
# Incoming Intake Processing

Raw intake lives at `inputs/additive/.incoming/<intake-id>/`.
EOF

  ! run_validator "$fixture_root"
}

main() {
  assert_success "raw-input dependency validator allows governed intake references" case_allowed_intake_governance_passes
  assert_success "raw-input dependency validator rejects governance references to raw inputs" case_engine_governance_reference_fails
  assert_success "raw-input dependency validator rejects generated capability incoming leaks" case_generated_capability_routing_incoming_leak_fails
  assert_success "raw-input dependency validator rejects generated extension archive leaks" case_generated_extension_catalog_archive_leak_fails
  assert_success "raw-input dependency validator rejects state/control incoming leaks" case_state_control_incoming_leak_fails
  assert_success "raw-input dependency validator rejects host projection incoming leaks" case_host_projection_incoming_leak_fails
  assert_success "raw-input dependency validator rejects workflow registry incoming leaks" case_workflow_registry_incoming_leak_fails
  assert_success "raw-input dependency validator rejects command manifest incoming leaks" case_command_manifest_incoming_leak_fails
  assert_success "raw-input dependency validator rejects instance governance incoming leaks" case_instance_governance_incoming_leak_fails
  assert_success "raw-input dependency validator rejects generated cognition archive leaks" case_generated_cognition_archive_leak_fails
  assert_success "raw-input dependency validator rejects generated proposals incoming leaks" case_generated_proposals_incoming_leak_fails
  assert_success "raw-input dependency validator rejects rust incoming leaks" case_rust_incoming_leak_fails
  assert_success "raw-input dependency validator rejects python archive leaks" case_python_archive_leak_fails
  assert_success "raw-input dependency validator rejects toml incoming leaks" case_toml_incoming_leak_fails
  assert_success "raw-input dependency validator requires allowed governance non-authority semantics" case_allowed_governance_requires_non_authority_semantics

  echo
  echo "Passed: $pass_count"
  echo "Failed: $fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
