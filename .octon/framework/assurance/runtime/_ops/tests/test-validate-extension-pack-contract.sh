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
    bash "$fixture_root/.octon/framework/assurance/runtime/_ops/scripts/validate-extension-pack-contract.sh" >/dev/null
}

case_valid_seeded_packs_pass() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"
  run_validator "$fixture_root"
}

case_invalid_pack_schema_fails() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  cat >"$fixture_root/.octon/inputs/additive/extensions/docs/pack.yml" <<'EOF'
schema_version: "extension-pack-v1"
id: "docs"
EOF

  ! run_validator "$fixture_root"
}

case_unexpected_top_level_bucket_fails() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  mkdir -p "$fixture_root/.octon/inputs/additive/extensions/docs/agency"
  cat >"$fixture_root/.octon/inputs/additive/extensions/docs/agency/README.md" <<'EOF'
# Invalid
EOF

  ! run_validator "$fixture_root"
}

case_provenance_source_mismatch_fails() {
  local fixture_root
  fixture_root="$(create_packet2_fixture_repo)"
  CLEANUP_DIRS+=("$fixture_root")
  copy_packet2_runtime_scripts "$fixture_root"
  write_valid_packet2_fixture "$fixture_root"

  python3 - "$fixture_root/.octon/inputs/additive/extensions/docs/pack.yml" <<'PY'
from pathlib import Path
import yaml
path = Path(__import__("sys").argv[1])
doc = yaml.safe_load(path.read_text())
doc["provenance"]["source_id"] = "third-party-imported"
path.write_text(yaml.safe_dump(doc, sort_keys=False))
PY

  ! run_validator "$fixture_root"
}

main() {
  assert_success "seeded packet-8 packs satisfy the pack contract" case_valid_seeded_packs_pass
  assert_success "pack validator rejects legacy pack manifest shape" case_invalid_pack_schema_fails
  assert_success "pack validator rejects disallowed top-level pack buckets" case_unexpected_top_level_bucket_fails
  assert_success "pack validator rejects provenance/source mismatches" case_provenance_source_mismatch_fails

  echo
  echo "Passed: $pass_count"
  echo "Failed: $fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
