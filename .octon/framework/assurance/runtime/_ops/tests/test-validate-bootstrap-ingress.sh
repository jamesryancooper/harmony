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

copy_runtime_scripts() {
  local fixture_root="$1"
  mkdir -p "$fixture_root/.octon/framework/assurance/runtime/_ops/scripts"
  cp "$REPO_ROOT/.octon/framework/assurance/runtime/_ops/scripts/validate-bootstrap-ingress.sh" \
    "$fixture_root/.octon/framework/assurance/runtime/_ops/scripts/validate-bootstrap-ingress.sh"
  chmod +x "$fixture_root/.octon/framework/assurance/runtime/_ops/scripts/validate-bootstrap-ingress.sh"
}

write_valid_fixture() {
  local fixture_root="$1"

  mkdir -p \
    "$fixture_root/.octon/instance/charter" \
    "$fixture_root/.octon/instance/bootstrap" \
    "$fixture_root/.octon/instance/ingress" \
    "$fixture_root/.octon/instance/cognition/context/shared"

  cp "$REPO_ROOT/.octon/AGENTS.md" "$fixture_root/.octon/AGENTS.md"

  cp "$fixture_root/.octon/AGENTS.md" "$fixture_root/AGENTS.md"
  cp "$fixture_root/.octon/AGENTS.md" "$fixture_root/CLAUDE.md"

  cat >"$fixture_root/.octon/instance/ingress/AGENTS.md" <<'EOF'
# Instance Ingress

## Execution Profile Governance

Use `change_profile`.
EOF

  cat >"$fixture_root/.octon/instance/charter/workspace.md" <<'EOF'
# Workspace Charter

This fixture provides a canonical workspace charter narrative.
EOF

  cat >"$fixture_root/.octon/instance/charter/workspace.yml" <<'EOF'
schema_version: "workspace-charter-v1"
workspace_id: "fixture"
EOF

  cat >"$fixture_root/.octon/instance/bootstrap/OBJECTIVE.md" <<'EOF'
---
schema_version: "objective-brief-v1"
objective_id: "fixture"
intent_id: "intent://fixture/test"
intent_version: "1.0.0"
owner: "fixture-owner"
approved_by: "fixture-owner"
generated_at: "2026-03-19T00:00:00Z"
---

# Objective: Fixture

## Workspace Goal

Keep the fixture coherent.

## What Octon Should Optimize For

- correctness

## In Scope

- fixture

## Out of Scope

- none

## Success Signals

- validation passes

## Initial Focus

- ingress
EOF

  cat >"$fixture_root/.octon/instance/cognition/context/shared/intent.contract.yml" <<'EOF'
schema_version: "intent-contract-v1"
intent_id: "intent://fixture/test"
version: "1.0.0"
owner: "fixture-owner"
approved_by: "fixture-owner"
EOF
}

run_validator() {
  local fixture_root="$1"
  OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" \
    bash "$fixture_root/.octon/framework/assurance/runtime/_ops/scripts/validate-bootstrap-ingress.sh" >/dev/null
}

case_valid_fixture_passes() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_runtime_scripts "$fixture_root"
  write_valid_fixture "$fixture_root"

  run_validator "$fixture_root"
}

case_root_agents_extra_text_fails() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_runtime_scripts "$fixture_root"
  write_valid_fixture "$fixture_root"

  cat >>"$fixture_root/AGENTS.md" <<'EOF'

## Extra Authority

Do something different.
EOF

  ! run_validator "$fixture_root"
}

case_root_claude_wrong_symlink_fails() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_runtime_scripts "$fixture_root"
  write_valid_fixture "$fixture_root"

  rm -f "$fixture_root/CLAUDE.md"
  ln -s ".octon/instance/ingress/AGENTS.md" "$fixture_root/CLAUDE.md"

  ! run_validator "$fixture_root"
}

main() {
  assert_success "bootstrap ingress validator accepts parity-copy adapters" case_valid_fixture_passes
  assert_success "bootstrap ingress validator rejects extra root AGENTS.md content" case_root_agents_extra_text_fails
  assert_success "bootstrap ingress validator rejects wrong CLAUDE.md symlink target" case_root_claude_wrong_symlink_fails

  echo
  echo "Passed: $pass_count"
  echo "Failed: $fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
