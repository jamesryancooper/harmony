#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
registry="$OCTON_DIR/instance/capabilities/runtime/packs/registry.yml"
for pack in repo git shell telemetry browser api; do
  test -f "$OCTON_DIR/instance/governance/capability-packs/$pack.yml"
done
yq -e '.packs[] | select(.pack_id == "browser" and .admission_status == "admitted" and .default_route == "escalate")' "$registry" >/dev/null
yq -e '.packs[] | select(.pack_id == "api" and .admission_status == "admitted" and .default_route == "escalate")' "$registry" >/dev/null
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-cross-artifact-capability-pack-consistency.sh"
write_validator_report "$release_id" "capability-pack-governance-report.yml" "V-CAP-001" "pass" "Governed capability-pack manifests exist for all admitted packs and browser/API remain explicitly routed and disclosed."
