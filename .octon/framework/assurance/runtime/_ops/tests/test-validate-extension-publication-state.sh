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
    bash "$fixture_root/.octon/framework/assurance/runtime/_ops/scripts/validate-extension-publication-state.sh" >/dev/null
}

publish_state() {
  local fixture_root="$1"
  OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" \
    bash "$fixture_root/.octon/framework/orchestration/runtime/_ops/scripts/publish-extension-state.sh" >/dev/null
}

case_empty_selection_publishes_clean_empty_generation() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  [[ "$(yq -r '.status // ""' "$fixture_root/.octon/state/control/extensions/active.yml")" == "published" ]]
  [[ "$(yq -r '.published_active_packs | length' "$fixture_root/.octon/state/control/extensions/active.yml")" == "0" ]]
  run_validator "$fixture_root"
}

case_partial_surviving_set_publishes_with_quarantine() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  write_packet8_pack "$fixture_root" "third-party-pack" "third-party-imported" "third_party" "allow" "    []" "    []" "templates"

  cat >"$fixture_root/.octon/instance/extensions.yml" <<'EOF'
schema_version: "octon-instance-extensions-v2"
selection:
  enabled:
    - pack_id: "docs"
      source_id: "bundled-first-party"
    - pack_id: "third-party-pack"
      source_id: "third-party-imported"
  disabled: []
sources:
  catalog:
    bundled-first-party:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "first_party_bundled"
    first-party-imported:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "first_party_external"
    third-party-imported:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "third_party"
trust:
  default_actions:
    first_party_bundled: "allow"
    first_party_external: "require_acknowledgement"
    third_party: "deny"
  source_overrides: {}
  pack_overrides: {}
acknowledgements: []
EOF

  publish_state "$fixture_root"
  [[ "$(yq -r '.status // ""' "$fixture_root/.octon/state/control/extensions/active.yml")" == "published_with_quarantine" ]]
  [[ "$(yq -r '.published_active_packs[0].pack_id // ""' "$fixture_root/.octon/state/control/extensions/active.yml")" == "docs" ]]
  [[ "$(yq -r '.records[0].pack_id // ""' "$fixture_root/.octon/state/control/extensions/quarantine.yml")" == "third-party-pack" ]]
  run_validator "$fixture_root"
}

case_fully_invalid_selection_withdraws_extensions() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  write_packet8_pack "$fixture_root" "third-party-pack" "third-party-imported" "third_party" "allow" "    []" "    []" "templates"

  cat >"$fixture_root/.octon/instance/extensions.yml" <<'EOF'
schema_version: "octon-instance-extensions-v2"
selection:
  enabled:
    - pack_id: "third-party-pack"
      source_id: "third-party-imported"
  disabled: []
sources:
  catalog:
    bundled-first-party:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "first_party_bundled"
    first-party-imported:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "first_party_external"
    third-party-imported:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "third_party"
trust:
  default_actions:
    first_party_bundled: "allow"
    first_party_external: "require_acknowledgement"
    third_party: "deny"
  source_overrides: {}
  pack_overrides: {}
acknowledgements: []
EOF

  publish_state "$fixture_root"
  [[ "$(yq -r '.status // ""' "$fixture_root/.octon/state/control/extensions/active.yml")" == "withdrawn" ]]
  [[ "$(yq -r '.published_active_packs | length' "$fixture_root/.octon/state/control/extensions/active.yml")" == "0" ]]
  [[ "$(yq -r '.records | length' "$fixture_root/.octon/state/control/extensions/quarantine.yml")" == "1" ]]
  run_validator "$fixture_root"
}

case_non_manifest_payload_change_invalidates_generation_lock() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  cat >"$fixture_root/.octon/instance/extensions.yml" <<'EOF'
schema_version: "octon-instance-extensions-v2"
selection:
  enabled:
    - pack_id: "docs"
      source_id: "bundled-first-party"
  disabled: []
sources:
  catalog:
    bundled-first-party:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "first_party_bundled"
    first-party-imported:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "first_party_external"
    third-party-imported:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "third_party"
trust:
  default_actions:
    first_party_bundled: "allow"
    first_party_external: "require_acknowledgement"
    third_party: "deny"
  source_overrides: {}
  pack_overrides: {}
acknowledgements: []
EOF

  publish_state "$fixture_root"
  printf '# changed\n' >> "$fixture_root/.octon/inputs/additive/extensions/docs/templates/README.md"
  ! run_validator "$fixture_root"
}

case_dependency_root_cause_records_affected_dependents() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  write_packet8_pack "$fixture_root" "dep" "third-party-imported" "third_party" "allow" "    []" "    []" "templates"
  write_packet8_pack "$fixture_root" "app" "bundled-first-party" "first_party_bundled" "allow" $'    - pack_id: "dep"\n      version_range: "1.0.0"' "    []" "templates"

  cat >"$fixture_root/.octon/instance/extensions.yml" <<'EOF'
schema_version: "octon-instance-extensions-v2"
selection:
  enabled:
    - pack_id: "app"
      source_id: "bundled-first-party"
  disabled: []
sources:
  catalog:
    bundled-first-party:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "first_party_bundled"
    first-party-imported:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "first_party_external"
    third-party-imported:
      source_type: "internalized"
      root: ".octon/inputs/additive/extensions"
      allowed_origin_classes:
        - "third_party"
trust:
  default_actions:
    first_party_bundled: "allow"
    first_party_external: "require_acknowledgement"
    third_party: "deny"
  source_overrides: {}
  pack_overrides: {}
acknowledgements: []
EOF

  publish_state "$fixture_root"
  [[ "$(yq -r '.records[] | select(.pack_id == "dep") | .affected_dependents[0] // ""' "$fixture_root/.octon/state/control/extensions/quarantine.yml")" == "app" ]]
}

main() {
  assert_success "empty desired selection publishes a clean empty generation" case_empty_selection_publishes_clean_empty_generation
  assert_success "one valid and one denied selected pack publishes with quarantine" case_partial_surviving_set_publishes_with_quarantine
  assert_success "fully invalid selected set withdraws extension contributions" case_fully_invalid_selection_withdraws_extensions
  assert_success "non-manifest payload changes invalidate the generation lock" case_non_manifest_payload_change_invalidates_generation_lock
  assert_success "dependency root-cause quarantine records carry affected dependents" case_dependency_root_cause_records_affected_dependents

  echo
  echo "Passed: $pass_count"
  echo "Failed: $fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
