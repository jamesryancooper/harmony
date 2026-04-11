#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"

HOST_TOOLS_DIR="$OCTON_DIR/framework/capabilities/runtime/host-tools"
REGISTRY="$HOST_TOOLS_DIR/registry.yml"
COMMAND_MANIFEST="$OCTON_DIR/framework/capabilities/runtime/commands/manifest.yml"
COMMAND_DOC="$OCTON_DIR/framework/capabilities/runtime/commands/provision-host-tools.md"
PROVISION_SCRIPT="$OCTON_DIR/framework/scaffolding/runtime/_ops/scripts/provision-host-tools.sh"
REQUIREMENTS="$OCTON_DIR/instance/capabilities/runtime/host-tools/requirements.yml"
POLICY="$OCTON_DIR/instance/governance/policies/host-tool-resolution.yml"
REPO_HYGIENE_POLICY="$OCTON_DIR/instance/governance/policies/repo-hygiene.yml"
REPO_HYGIENE_README="$OCTON_DIR/instance/capabilities/runtime/commands/repo-hygiene/README.md"
START_DOC="$OCTON_DIR/instance/bootstrap/START.md"
CATALOG_DOC="$OCTON_DIR/instance/bootstrap/catalog.md"
TEST_SCRIPT="$OCTON_DIR/framework/assurance/runtime/_ops/tests/test-host-tool-governance.sh"

errors=0

fail() {
  echo "[ERROR] $1"
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

require_file() {
  local path="$1"
  if [[ -f "$path" ]]; then
    pass "found ${path#$ROOT_DIR/}"
  else
    fail "missing ${path#$ROOT_DIR/}"
  fi
}

require_yq() {
  local expr="$1"
  local file="$2"
  local label="$3"
  if yq -e "$expr" "$file" >/dev/null 2>&1; then
    pass "$label"
  else
    fail "$label"
  fi
}

require_text() {
  local needle="$1"
  local file="$2"
  local label="$3"
  if command -v rg >/dev/null 2>&1; then
    if rg -Fq -- "$needle" "$file"; then
      pass "$label"
    else
      fail "$label"
    fi
  elif grep -Fq -- "$needle" "$file"; then
    pass "$label"
  else
    fail "$label"
  fi
}

run_test() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    pass "$label"
  else
    fail "$label"
  fi
}

main() {
  echo "== Host Tool Governance Validation =="

  require_file "$HOST_TOOLS_DIR/README.md"
  require_file "$REGISTRY"
  require_file "$HOST_TOOLS_DIR/contracts/shellcheck.yml"
  require_file "$HOST_TOOLS_DIR/contracts/cargo-machete.yml"
  require_file "$HOST_TOOLS_DIR/contracts/cargo-udeps.yml"
  require_file "$COMMAND_MANIFEST"
  require_file "$COMMAND_DOC"
  require_file "$PROVISION_SCRIPT"
  require_file "$REQUIREMENTS"
  require_file "$POLICY"
  require_file "$REPO_HYGIENE_POLICY"
  require_file "$REPO_HYGIENE_README"
  require_file "$START_DOC"
  require_file "$CATALOG_DOC"
  require_file "$TEST_SCRIPT"

  require_yq '.schema_version == "octon-host-tool-registry-v1"' "$REGISTRY" "host-tool registry schema is correct"
  require_yq '.tools[] | select(.tool_id == "shellcheck")' "$REGISTRY" "registry includes shellcheck"
  require_yq '.tools[] | select(.tool_id == "cargo-machete")' "$REGISTRY" "registry includes cargo-machete"
  require_yq '.tools[] | select(.tool_id == "cargo-udeps")' "$REGISTRY" "registry includes cargo-udeps"
  require_yq '.consumers."repo-hygiene".mode_requirements.audit.mandatory_tools."cargo-udeps".version == "0.1.60"' "$REQUIREMENTS" "repo-hygiene audit requires cargo-udeps"
  require_yq '.consumers."repo-hygiene".mode_requirements.enforce.mandatory_tools."shellcheck".version == "0.10.0"' "$REQUIREMENTS" "repo-hygiene enforce requires shellcheck"
  require_yq '.installer_posture.init_must_not_install == true' "$POLICY" "host-tool policy keeps /init repo-local"
  require_yq '.commands[] | select(.id == "provision-host-tools" and .path == "provision-host-tools.md")' "$COMMAND_MANIFEST" "framework command manifest registers provision-host-tools"

  require_text 'host_tool_requirements_ref' "$REPO_HYGIENE_POLICY" "repo-hygiene policy binds host-tool requirements"
  require_text 'provision-host-tools' "$REPO_HYGIENE_README" "repo-hygiene README documents provisioning command"
  require_text 'provision-host-tools' "$START_DOC" "bootstrap START documents provisioning command"
  require_text 'provision-host-tools' "$CATALOG_DOC" "bootstrap catalog documents provisioning command"
  require_text 'host-tools/' "$OCTON_DIR/framework/capabilities/runtime/README.md" "runtime README publishes host-tools family"

  if find "$HOST_TOOLS_DIR" -type f ! \( -name '*.md' -o -name '*.yml' \) | grep -q .; then
    fail "host-tool family contains unexpected non-doc, non-yaml files"
  else
    pass "host-tool family contains only docs and yaml contracts"
  fi

  run_test "host-tool registry parses" yq -e '.' "$REGISTRY"
  run_test "host-tool requirements parse" yq -e '.' "$REQUIREMENTS"
  run_test "host-tool policy parses" yq -e '.' "$POLICY"
  run_test "provision-host-tools script parses" bash -n "$PROVISION_SCRIPT"
  run_test "host-tool governance validator parses" bash -n "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-host-tool-governance.sh"
  run_test "host-tool multi-repo test passes" bash "$TEST_SCRIPT"
  run_test "git diff check is clean" git diff --check

  echo "Validation summary: errors=$errors"
  [[ $errors -eq 0 ]]
}

main "$@"
