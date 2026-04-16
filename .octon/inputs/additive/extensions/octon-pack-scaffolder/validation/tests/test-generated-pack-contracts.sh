#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../../../../../../.." && pwd)"

pass_count=0
fail_count=0
declare -a CLEANUP_DIRS=()

pass() { echo "PASS: $1"; pass_count=$((pass_count + 1)); }
fail() { echo "FAIL: $1" >&2; fail_count=$((fail_count + 1)); }

cleanup() {
  local dir
  for dir in "${CLEANUP_DIRS[@]}"; do
    [[ -n "$dir" ]] && rm -rf -- "$dir"
  done
}
trap cleanup EXIT

assert_success() {
  local label="$1"
  shift
  if "$@"; then
    pass "$label"
  else
    fail "$label"
  fi
}

copy_file() {
  local fixture_root="$1"
  local rel="$2"
  mkdir -p "$fixture_root/$(dirname "$rel")"
  cp "$REPO_ROOT/$rel" "$fixture_root/$rel"
}

write_file() {
  local path="$1"
  mkdir -p "$(dirname "$path")"
  cat >"$path"
}

create_fixture_repo() {
  local fixture_root
  fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/octon-pack-scaffolder.XXXXXX")"
  CLEANUP_DIRS+=("$fixture_root")

  mkdir -p \
    "$fixture_root/.octon/inputs/additive/extensions" \
    "$fixture_root/.octon/generated/effective/extensions" \
    "$fixture_root/.octon/generated/effective/capabilities" \
    "$fixture_root/.octon/generated/effective/locality" \
    "$fixture_root/.octon/state/evidence/validation/publication/extensions" \
    "$fixture_root/.octon/state/evidence/validation/compatibility/extensions" \
    "$fixture_root/.octon/state/evidence/validation/publication/capabilities" \
    "$fixture_root/.octon/state/control/extensions"

  copy_file "$fixture_root" "README.md"
  copy_file "$fixture_root" ".octon/README.md"
  copy_file "$fixture_root" ".octon/octon.yml"
  copy_file "$fixture_root" ".octon/framework/manifest.yml"
  copy_file "$fixture_root" ".octon/instance/manifest.yml"
  copy_file "$fixture_root" ".octon/instance/ingress/AGENTS.md"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/inputs/additive/extensions/schemas/extension-pack.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/inputs/additive/extensions/schemas/extension-compatibility-profile.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/inputs/additive/extensions/schemas/extension-routing-contract.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/generated/effective/extensions/schemas/extension-effective-catalog.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/generated/effective/extensions/schemas/extension-artifact-map.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/generated/effective/extensions/schemas/extension-generation-lock.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/generated/effective/extensions/schemas/extension-route-resolution.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/state/control/schemas/extension-active-state.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/state/control/schemas/extension-quarantine-state.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/state/evidence/validation/publication/schemas/validation-publication-receipt.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/state/evidence/validation/compatibility/schemas/extension-compatibility-receipt.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/generated/effective/capabilities/schemas/capability-routing-effective.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/generated/effective/capabilities/schemas/capability-routing-artifact-map.schema.json"
  copy_file "$fixture_root" ".octon/framework/cognition/_meta/architecture/generated/effective/capabilities/schemas/capability-routing-generation-lock.schema.json"
  copy_file "$fixture_root" ".octon/framework/engine/governance/extensions/README.md"

  copy_file "$fixture_root" ".octon/framework/orchestration/runtime/_ops/scripts/extensions-common.sh"
  copy_file "$fixture_root" ".octon/framework/orchestration/runtime/_ops/scripts/publish-extension-state.sh"
  copy_file "$fixture_root" ".octon/framework/orchestration/runtime/_ops/scripts/resolve-extension-route.sh"
  copy_file "$fixture_root" ".octon/framework/assurance/runtime/_ops/scripts/validate-extension-pack-contract.sh"
  copy_file "$fixture_root" ".octon/framework/assurance/runtime/_ops/scripts/validate-extension-publication-state.sh"
  copy_file "$fixture_root" ".octon/framework/capabilities/_ops/scripts/publish-capability-routing.sh"
  copy_file "$fixture_root" ".octon/framework/assurance/runtime/_ops/scripts/validate-capability-publication-state.sh"
  mkdir -p "$fixture_root/.octon/framework/capabilities" "$fixture_root/.octon/instance/capabilities"
  cp -R "$REPO_ROOT/.octon/framework/capabilities/runtime" "$fixture_root/.octon/framework/capabilities/"
  cp -R "$REPO_ROOT/.octon/instance/capabilities/runtime" "$fixture_root/.octon/instance/capabilities/"
  copy_file "$fixture_root" ".octon/generated/effective/locality/scopes.effective.yml"
  copy_file "$fixture_root" ".octon/generated/effective/locality/generation.lock.yml"

  write_file "$fixture_root/.octon/instance/extensions.yml" <<'EOF'
schema_version: "octon-instance-extensions-v2"
selection:
  enabled:
    - pack_id: "demo-pack"
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

  printf '%s\n' "$fixture_root"
}

create_demo_pack() {
  local fixture_root="$1"
  local pack_root="$fixture_root/.octon/inputs/additive/extensions/demo-pack"

  write_file "$pack_root/pack.yml" <<'EOF'
schema_version: "octon-extension-pack-v4"
pack_id: "demo-pack"
version: "0.1.0"
origin_class: "first_party_bundled"
compatibility:
  octon_version: "^0.6.25"
  extensions_api_version: "1.0"
  required_contracts: []
  profile_path: "validation/compatibility.yml"
dependencies:
  requires: []
  conflicts: []
provenance:
  source_id: "bundled-first-party"
  imported_from: null
  origin_uri: null
  digest_sha256: null
  attestation_refs: []
trust_hints:
  suggested_action: "allow"
content_entrypoints:
  skills: "skills/"
  commands: "commands/"
  templates: null
  prompts: "prompts/"
  context: "context/"
  validation: "validation/"
EOF

  write_file "$pack_root/README.md" <<'EOF'
# Demo Pack

Minimal pack output fixture generated from the octon-pack-scaffolder contract.
EOF

  write_file "$pack_root/commands/manifest.fragment.yml" <<'EOF'
schema_version: "extensions-commands-fragment-v1"
commands:
  - id: demo-pack-review
    display_name: Demo Pack Review
    path: demo-pack-review.md
    summary: "Review one demo pack surface."
    access: agent
    argument_hint: "[target-path]"
EOF

  write_file "$pack_root/commands/demo-pack-review.md" <<'EOF'
# Demo Pack Review

Thin additive command wrapper for the demo pack.
EOF

  write_file "$pack_root/skills/manifest.fragment.yml" <<'EOF'
schema_version: "extensions-skills-fragment-v1"
skills:
  - id: demo-pack-review
    display_name: Demo Pack Review
    group: extensions
    path: demo-pack-review/
    skill_class: invocable
    summary: "Review one demo pack surface."
    status: active
    tags:
      - demo-pack
      - extension-pack
      - review
    triggers:
      - "demo pack review"
EOF

  write_file "$pack_root/skills/registry.fragment.yml" <<'EOF'
schema_version: "extensions-skills-registry-fragment-v1"
skills:
  demo-pack-review:
    version: "1.0.0"
    commands:
      - /demo-pack-review
    parameters: []
    requires:
      context: []
EOF

  write_file "$pack_root/skills/demo-pack-review/SKILL.md" <<'EOF'
---
name: demo-pack-review
description: >
  Minimal additive skill fixture for extension pack publication tests.
license: MIT
compatibility: Designed for Octon additive extension-pack authoring tests.
metadata:
  author: Octon Framework
  created: "2026-04-15"
  updated: "2026-04-15"
skill_sets: [executor, specialist]
capabilities: [self-validating]
allowed-tools: Read Glob Grep
---

# Demo Pack Review

Minimal additive skill fixture for extension pack publication tests.
EOF

  write_file "$pack_root/skills/demo-pack-review/references/phases.md" <<'EOF'
# Phases

- inspect the requested demo surface
EOF

  write_file "$pack_root/skills/demo-pack-review/references/io-contract.md" <<'EOF'
# IO Contract

- input: target-path
- output: review notes
EOF

  write_file "$pack_root/skills/demo-pack-review/references/validation.md" <<'EOF'
# Validation

- shape is additive and self-contained
EOF

  write_file "$pack_root/context/overview.md" <<'EOF'
# Demo Pack Overview

Pack-local context fixture.
EOF

  write_file "$pack_root/validation/compatibility.yml" <<'EOF'
schema_version: "octon-extension-compatibility-profile-v1"
version: "1.0.0"
compatibility:
  required_files: []
  required_directories:
    - ".octon/generated/effective/extensions"
    - ".octon/generated/effective/capabilities"
  required_commands:
    - ".octon/framework/orchestration/runtime/_ops/scripts/publish-extension-state.sh"
    - ".octon/framework/assurance/runtime/_ops/scripts/validate-extension-pack-contract.sh"
    - ".octon/framework/assurance/runtime/_ops/scripts/validate-extension-publication-state.sh"
    - ".octon/framework/capabilities/_ops/scripts/publish-capability-routing.sh"
    - ".octon/framework/assurance/runtime/_ops/scripts/validate-capability-publication-state.sh"
  minimum_behavior:
    fail_closed_publication: true
    compiled_runtime_consumption_only: true
    host_generated_receipts: true
  optional_features: []
EOF

  write_file "$pack_root/validation/scenarios/create-pack-smoke.md" <<'EOF'
# Create Pack Smoke

## Preconditions

- demo pack does not exist yet

## Invocation

- create pack

## Expected Outputs

- pack root plus additive files only
EOF

  write_file "$pack_root/prompts/review-surface/README.md" <<'EOF'
# Review Surface

Minimal prompt bundle fixture.
EOF

  write_file "$pack_root/prompts/review-surface/manifest.yml" <<'EOF'
schema_version: "octon-extension-prompt-set-v1"
prompt_set_id: "demo-pack-review-surface"
version: "0.1.0"
stages:
  - stage_id: "inspect"
    prompt_id: "demo-pack-review-surface-inspect"
    path: "stages/01-inspect.md"
    role_class: "stage"
    order: 1
companions:
  - prompt_id: "demo-pack-review-surface-align-bundle"
    path: "companions/01-align-bundle.md"
    role_class: "maintenance-companion"
references:
  - ref_id: "bundle-contract"
    path: "references/bundle-contract.md"
shared_references: []
required_repo_anchors:
  - ".octon/instance/ingress/AGENTS.md"
alignment_policy:
  default_mode: "auto"
  stale_behavior: "realign_or_fail_closed"
  skip_mode_policy: "degraded-retained-explicit"
  receipt_root: ".octon/state/evidence/validation/extensions/prompt-alignment"
invalidation_conditions:
  - "prompt-manifest-sha-changed"
  - "prompt-asset-sha-changed"
  - "required-anchor-sha-changed"
  - "extension-desired-config-sha-changed"
  - "root-manifest-sha-changed"
artifact_policy:
  internal_artifacts: []
  packet_support_files: []
EOF

  write_file "$pack_root/prompts/review-surface/companions/01-align-bundle.md" <<'EOF'
Re-align this prompt bundle to the current repo before proceeding when drift is detected.
EOF

  write_file "$pack_root/prompts/review-surface/stages/01-inspect.md" <<'EOF'
Review one demo pack surface and summarize the additive result.
EOF

  write_file "$pack_root/prompts/review-surface/references/bundle-contract.md" <<'EOF'
# Bundle Contract

This bundle stays minimal and additive.
EOF
}

run_fixture_validation() {
  local fixture_root="$1"
  (
    cd "$fixture_root"
    OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" \
      bash .octon/framework/assurance/runtime/_ops/scripts/validate-extension-pack-contract.sh >/dev/null
    OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" \
      bash .octon/framework/orchestration/runtime/_ops/scripts/publish-extension-state.sh >/dev/null
    OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" \
      bash .octon/framework/assurance/runtime/_ops/scripts/validate-extension-publication-state.sh >/dev/null
    OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" \
      bash .octon/framework/capabilities/_ops/scripts/publish-capability-routing.sh >/dev/null
    OCTON_DIR_OVERRIDE="$fixture_root/.octon" OCTON_ROOT_DIR="$fixture_root" \
      bash .octon/framework/assurance/runtime/_ops/scripts/validate-capability-publication-state.sh >/dev/null
  )
}

assert_published_prompt_bundle() {
  local fixture_root="$1"
  local prompt_projection="$fixture_root/.octon/generated/effective/extensions/published/demo-pack/bundled-first-party/prompts/review-surface/manifest.yml"
  if [[ -f "$prompt_projection" ]]; then
    pass "prompt bundle projected into published extension surface"
  else
    find "$fixture_root/.octon/generated/effective/extensions/published" -type f | LC_ALL=C sort >&2 || true
    fail "prompt bundle projected into published extension surface"
  fi
}

assert_published_skill_and_command() {
  local fixture_root="$1"
  local skill_projection="$fixture_root/.octon/generated/effective/extensions/published/demo-pack/bundled-first-party/skills/demo-pack-review/SKILL.md"
  local command_projection="$fixture_root/.octon/generated/effective/extensions/published/demo-pack/bundled-first-party/commands/demo-pack-review.md"
  if [[ -f "$skill_projection" ]]; then
    pass "skill projected into published extension surface"
  else
    find "$fixture_root/.octon/generated/effective/extensions/published" -type f | LC_ALL=C sort >&2 || true
    fail "skill projected into published extension surface"
  fi
  if [[ -f "$command_projection" ]]; then
    pass "command projected into published extension surface"
  else
    find "$fixture_root/.octon/generated/effective/extensions/published" -type f | LC_ALL=C sort >&2 || true
    fail "command projected into published extension surface"
  fi
}

main() {
  local fixture_root
  fixture_root="$(create_fixture_repo)"
  create_demo_pack "$fixture_root"

  assert_success "sample generated pack passes extension and capability validators" run_fixture_validation "$fixture_root"
  assert_published_skill_and_command "$fixture_root"
  assert_published_prompt_bundle "$fixture_root"

  echo "Passed: $pass_count"
  echo "Failed: $fail_count"
  if [[ $fail_count -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
