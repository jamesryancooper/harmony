#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

validators=(
  "validate-architecture-conformance.sh"
  "validate-runtime-resolution.sh"
  "validate-runtime-effective-route-bundle.sh"
  "validate-runtime-effective-artifact-handles.sh"
  "validate-no-raw-generated-effective-runtime-reads.sh"
  "validate-material-side-effect-inventory.sh"
  "validate-authorization-boundary-coverage.sh"
  "validate-run-lifecycle-transition-coverage.sh"
  "validate-support-target-path-normalization.sh"
  "validate-support-target-proofing.sh"
  "validate-proof-bundle-executability.sh"
  "validate-support-pack-admission-alignment.sh"
  "validate-publication-freshness-gates.sh"
  "validate-extension-active-state-compactness.sh"
  "validate-operator-read-models.sh"
  "validate-compatibility-retirement-readiness.sh"
  "validate-compatibility-retirement-cutover.sh"
  "validate-operator-boot-surface.sh"
  "validate-proof-plane-completeness.sh"
)

dimensions=(
  "structural_contract:semantic:validate-architecture-conformance.sh"
  "runtime_effective_handles:runtime:validate-runtime-effective-route-bundle.sh"
  "runtime_effective_handles:runtime:validate-runtime-effective-artifact-handles.sh"
  "freshness_modes:runtime:validate-publication-freshness-gates.sh"
  "authorization_coverage:runtime:validate-authorization-boundary-coverage.sh"
  "capability_pack_cutover:runtime:validate-support-pack-admission-alignment.sh"
  "extension_lifecycle:runtime:validate-extension-active-state-compactness.sh"
  "support_proof:proof:validate-support-target-proofing.sh"
  "support_proof:proof:validate-proof-bundle-executability.sh"
  "operator_read_models:semantic:validate-operator-read-models.sh"
  "compatibility_retirement:semantic:validate-compatibility-retirement-cutover.sh"
  "closure_grade:closure-grade:validate-architecture-health.sh"
)

errors=0
passes=0

run_validator() {
  local validator="$1"
  if bash "$SCRIPT_DIR/$validator" >/dev/null; then
    echo "- PASS \`$validator\`"
    passes=$((passes + 1))
  else
    echo "- FAIL \`$validator\`"
    errors=$((errors + 1))
  fi
}

echo "## Architecture Health"
for validator in "${validators[@]}"; do
  run_validator "$validator"
done
echo
echo "## Dimension Depths"
for dimension in "${dimensions[@]}"; do
  IFS=":" read -r name depth validator <<<"$dimension"
  echo "- \`$name\`: required_depth=\`$depth\`, validator=\`$validator\`"
done
echo
echo "Summary: pass=$passes fail=$errors"
[[ $errors -eq 0 ]]
