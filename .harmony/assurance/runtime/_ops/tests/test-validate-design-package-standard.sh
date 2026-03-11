#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
RUNTIME_DIR="$(cd "$OPS_DIR/.." && pwd)"
ASSURANCE_DIR="$(cd "$RUNTIME_DIR/.." && pwd)"
HARMONY_DIR="$(cd "$ASSURANCE_DIR/.." && pwd)"
REPO_ROOT="$(cd "$HARMONY_DIR/.." && pwd)"
VALIDATE_SCRIPT=".harmony/assurance/runtime/_ops/scripts/validate-design-package-standard.sh"

pass_count=0
fail_count=0

declare -a CLEANUP_DIRS=()

cleanup() {
  local dir
  for dir in "${CLEANUP_DIRS[@]}"; do
    [[ -n "$dir" ]] && rm -r "$dir"
  done
}
trap cleanup EXIT

pass() {
  echo "PASS: $1"
  pass_count=$((pass_count + 1))
}

fail() {
  echo "FAIL: $1" >&2
  fail_count=$((fail_count + 1))
}

assert_success() {
  local name="$1"
  shift
  if "$@"; then
    pass "$name"
  else
    fail "$name"
  fi
}

assert_failure_contains() {
  local name="$1"
  local needle="$2"
  shift 2

  local output=""
  local rc=0
  output="$("$@" 2>&1)" || rc=$?

  if (( rc != 0 )) && grep -Fq "$needle" <<<"$output"; then
    pass "$name"
    return 0
  fi

  fail "$name"
  echo "  expected failure containing: $needle" >&2
  echo "  exit code: $rc" >&2
  echo "  output:" >&2
  echo "$output" >&2
  return 1
}

create_fixture_repo() {
  local fixture_root
  fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/design-package-standard.XXXXXX")"
  CLEANUP_DIRS+=("$fixture_root")

  mkdir -p "$fixture_root/.harmony/assurance/runtime/_ops/scripts" "$fixture_root/.design-packages"
  cp "$REPO_ROOT/.harmony/assurance/runtime/_ops/scripts/validate-design-package-standard.sh" \
    "$fixture_root/.harmony/assurance/runtime/_ops/scripts/validate-design-package-standard.sh"

  cat >"$fixture_root/.design-packages/registry.yml" <<'EOF'
schema_version: "design-package-registry-v1"
active: []
archived: []
EOF

  printf '%s\n' "$fixture_root"
}

run_validator_in_fixture() {
  local fixture_root="$1"
  shift
  (
    cd "$fixture_root"
    bash "$VALIDATE_SCRIPT" "$@"
  )
}

write_registry_file() {
  local fixture_root="$1"
  local active_yaml="$2"
  local archived_yaml="$3"
  cat >"$fixture_root/.design-packages/registry.yml" <<EOF
schema_version: "design-package-registry-v1"
active:
$active_yaml
archived:
$archived_yaml
EOF
}

write_manifest() {
  local file="$1"
  local package_id="$2"
  local package_class="$3"
  local selected_modules="$4"
  local implementation_targets="$5"
  local status="$6"
  local archive_block="$7"
  local package_validator_path="$8"
  local conformance_validator_path="$9"

  cat >"$file" <<EOF
schema_version: "design-package-v1"
package_id: "$package_id"
title: "Fixture ${package_id}"
summary: "Fixture package for validator testing."
package_class: "$package_class"
selected_modules:
$selected_modules
implementation_targets:
$implementation_targets
status: "$status"
$archive_block
lifecycle:
  temporary: true
  exit_expectation: "Promote durable outputs and archive the package after implementation."
validation:
  default_audit_mode: "rigorous"
  package_validator_path: $package_validator_path
  conformance_validator_path: $conformance_validator_path
EOF
}

create_common_readme() {
  local file="$1"
  local archived="$2"
  local disposition="$3"
  cat >"$file" <<EOF
# Fixture Package

This is a temporary, implementation-scoped design package for \`fixture\`.
It is a build aid for engineers. It is not a canonical runtime, documentation,
policy, or contract authority.
EOF

  if [[ "$archived" == "1" ]]; then
    cat >>"$file" <<EOF

Status: \`archived\`
Archive Disposition: \`$disposition\`
EOF
  fi

  cat >>"$file" <<'EOF'

## Implementation Targets

- `.harmony/example/target.md`

## Exit Path

Promote durable outputs and archive the package after implementation.
EOF
}

create_active_standard_package() {
  local fixture_root="$1"
  local package_id="${2:-runtime-package}"
  local package_dir="$fixture_root/.design-packages/$package_id"
  mkdir -p \
    "$package_dir/navigation" \
    "$package_dir/implementation" \
    "$package_dir/normative/architecture" \
    "$package_dir/normative/execution" \
    "$package_dir/normative/assurance" \
    "$package_dir/reference" \
    "$package_dir/history" \
    "$package_dir/contracts/schemas" \
    "$package_dir/contracts/fixtures/valid" \
    "$package_dir/contracts/fixtures/invalid" \
    "$package_dir/conformance/scenarios" \
    "$fixture_root/.harmony/example"

  create_common_readme "$package_dir/README.md" 0 ""
  cat >"$package_dir/navigation/artifact-catalog.md" <<'EOF'
# Artifact Catalog
EOF
  cat >"$package_dir/navigation/source-of-truth-map.md" <<'EOF'
# Source Of Truth Map
EOF
  cat >"$package_dir/navigation/canonicalization-target-map.md" <<'EOF'
# Canonicalization Target Map
EOF
  cat >"$package_dir/implementation/README.md" <<'EOF'
# Implementation
EOF
  cat >"$package_dir/implementation/minimal-implementation-blueprint.md" <<'EOF'
# Minimal Implementation Blueprint
EOF
  cat >"$package_dir/implementation/first-implementation-plan.md" <<'EOF'
# First Implementation Plan
EOF
  cat >"$package_dir/normative/architecture/domain-model.md" <<'EOF'
# Domain Model
EOF
  cat >"$package_dir/normative/architecture/runtime-architecture.md" <<'EOF'
# Runtime Architecture
EOF
  cat >"$package_dir/normative/execution/behavior-model.md" <<'EOF'
# Behavior Model
EOF
  cat >"$package_dir/normative/assurance/implementation-readiness.md" <<'EOF'
# Implementation Readiness
EOF
  cat >"$package_dir/reference/README.md" <<'EOF'
# Reference
EOF
  cat >"$package_dir/history/README.md" <<'EOF'
# History
EOF
  cat >"$package_dir/contracts/README.md" <<'EOF'
# Contracts
EOF
  cat >"$package_dir/conformance/README.md" <<'EOF'
# Conformance
EOF
  cat >"$package_dir/conformance/validate_scenarios.py" <<'EOF'
#!/usr/bin/env python3
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
scenario_dir = root / "conformance" / "scenarios"
print(f"[OK] {scenario_dir}")
EOF
  cat >"$fixture_root/.harmony/example/target.md" <<'EOF'
# Live Target
EOF

  write_manifest \
    "$package_dir/design-package.yml" \
    "$package_id" \
    "domain-runtime" \
    '  - reference
  - history
  - contracts
  - conformance
  - canonicalization' \
    '  - ".harmony/example/target.md"' \
    "draft" \
    "" \
    'null' \
    '".design-packages/'"$package_id"'/conformance/validate_scenarios.py"'

  write_registry_file "$fixture_root" \
    "  - id: \"$package_id\"
    path: \".design-packages/$package_id\"
    title: \"Fixture $package_id\"
    package_class: \"domain-runtime\"
    status: \"draft\"
    implementation_targets:
      - \".harmony/example/target.md\"" \
    "  []"

  printf '%s\n' "$package_dir"
}

create_archived_package() {
  local fixture_root="$1"
  local package_id="$2"
  local disposition="$3"
  local original_path="$4"
  local package_dir="$fixture_root/.design-packages/.archive/$package_id"
  mkdir -p "$package_dir" "$fixture_root/.harmony/example"

  create_common_readme "$package_dir/README.md" 1 "$disposition"
  cat >"$package_dir/notes.md" <<'EOF'
# Historical Notes
EOF
  cat >"$fixture_root/.harmony/example/target.md" <<'EOF'
# Live Target
EOF

  local evidence_yaml='    - ".design-packages/.archive/'"$package_id"'/notes.md"'
  if [[ "$disposition" == "historical" ]]; then
    evidence_yaml=""
  fi

  write_manifest \
    "$package_dir/design-package.yml" \
    "$package_id" \
    "domain-runtime" \
    '  []' \
    '  - ".harmony/example/target.md"' \
    "archived" \
    "archive:
  archived_at: \"2026-03-11\"
  archived_from_status: \"legacy-unknown\"
  disposition: \"$disposition\"
  original_path: \"$original_path\"
  promotion_evidence:
$evidence_yaml" \
    'null' \
    'null'

  write_registry_file "$fixture_root" \
    "  []" \
    "  - id: \"$package_id\"
    path: \".design-packages/.archive/$package_id\"
    title: \"Fixture $package_id\"
    package_class: \"domain-runtime\"
    status: \"archived\"
    disposition: \"$disposition\"
    archived_at: \"2026-03-11\"
    archived_from_status: \"legacy-unknown\"
    original_path: \"$original_path\"
    implementation_targets:
      - \".harmony/example/target.md\""

  printf '%s\n' "$package_dir"
}

case_valid_active_package_passes() {
  local fixture_root
  fixture_root="$(create_fixture_repo)"
  create_active_standard_package "$fixture_root" >/dev/null
  run_validator_in_fixture "$fixture_root" --all-standard-packages
}

case_valid_archived_implemented_package_passes() {
  local fixture_root
  fixture_root="$(create_fixture_repo)"
  create_archived_package "$fixture_root" "implemented-archive" "implemented" ".archive/.design-packages/implemented-archive" >/dev/null
  run_validator_in_fixture "$fixture_root" --all-standard-packages
}

case_valid_archived_historical_package_passes() {
  local fixture_root
  fixture_root="$(create_fixture_repo)"
  create_archived_package "$fixture_root" "historical-archive" "historical" ".archive/.design-packages/historical-archive" >/dev/null
  run_validator_in_fixture "$fixture_root" --all-standard-packages
}

case_archived_package_outside_archive_fails() {
  local fixture_root package_dir
  fixture_root="$(create_fixture_repo)"
  package_dir="$(create_active_standard_package "$fixture_root" "bad-archive")"
  perl -0pi -e 's/status: "draft"/status: "archived"\narchive:\n  archived_at: "2026-03-11"\n  archived_from_status: "legacy-unknown"\n  disposition: "historical"\n  original_path: ".archive\/.design-packages\/bad-archive"\n  promotion_evidence: []/' \
    "$package_dir/design-package.yml"
  cat >"$fixture_root/.design-packages/registry.yml" <<'EOF'
schema_version: "design-package-registry-v1"
active: []
archived:
  - id: "bad-archive"
    path: ".design-packages/bad-archive"
    title: "Fixture bad-archive"
    package_class: "domain-runtime"
    status: "archived"
    disposition: "historical"
    archived_at: "2026-03-11"
    archived_from_status: "legacy-unknown"
    original_path: ".archive/.design-packages/bad-archive"
    implementation_targets:
      - ".harmony/example/target.md"
EOF
  run_validator_in_fixture "$fixture_root" --package ".design-packages/bad-archive"
}

case_implemented_archive_missing_evidence_fails() {
  local fixture_root package_dir
  fixture_root="$(create_fixture_repo)"
  package_dir="$(create_archived_package "$fixture_root" "implemented-archive" "implemented" ".archive/.design-packages/implemented-archive")"
  perl -0pi -e 's/promotion_evidence:\n(?:    - ".*"\n)?/promotion_evidence: []\n/' "$package_dir/design-package.yml"
  run_validator_in_fixture "$fixture_root" --package ".design-packages/.archive/implemented-archive"
}

case_registry_mismatch_fails() {
  local fixture_root
  fixture_root="$(create_fixture_repo)"
  create_active_standard_package "$fixture_root" >/dev/null
  cat >"$fixture_root/.design-packages/registry.yml" <<'EOF'
schema_version: "design-package-registry-v1"
active:
  - id: "runtime-package"
    path: ".design-packages/wrong-path"
    title: "Fixture runtime-package"
    package_class: "domain-runtime"
    status: "draft"
    implementation_targets:
      - ".harmony/example/target.md"
archived: []
EOF
  run_validator_in_fixture "$fixture_root" --all-standard-packages
}

case_live_target_backreference_fails() {
  local fixture_root package_dir
  fixture_root="$(create_fixture_repo)"
  package_dir="$(create_active_standard_package "$fixture_root" "backref-package")"
  cat >"$fixture_root/.harmony/example/target.md" <<'EOF'
# Live Target

This still depends on `.design-packages/backref-package/navigation/source-of-truth-map.md`.
EOF
  run_validator_in_fixture "$fixture_root" --package ".design-packages/backref-package"
}

main() {
  assert_success \
    "design-package standard validator accepts active manifest-governed packages" \
    case_valid_active_package_passes

  assert_success \
    "design-package standard validator accepts archived implemented packages in .archive" \
    case_valid_archived_implemented_package_passes

  assert_success \
    "design-package standard validator accepts reduced historical legacy archives" \
    case_valid_archived_historical_package_passes

  assert_failure_contains \
    "design-package standard validator rejects archived packages outside .archive" \
    "archived package must live under .design-packages/.archive/" \
    case_archived_package_outside_archive_fails

  assert_failure_contains \
    "design-package standard validator rejects implemented archives without promotion evidence" \
    "implemented archive requires promotion evidence" \
    case_implemented_archive_missing_evidence_fails

  assert_failure_contains \
    "design-package standard validator rejects registry mismatches" \
    "registry entry points to manifest-bearing package: .design-packages/wrong-path" \
    case_registry_mismatch_fails

  assert_failure_contains \
    "design-package standard validator rejects implementation target backreferences" \
    "implementation target retains temporary package dependency" \
    case_live_target_backreference_fails

  echo
  echo "Passed: $pass_count"
  echo "Failed: $fail_count"

  if [[ "$fail_count" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
