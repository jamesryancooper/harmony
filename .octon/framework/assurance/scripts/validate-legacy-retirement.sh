#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-no-legacy-active-path.sh"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-retirement-registry.sh"
test -f "$OCTON_DIR/instance/governance/retirement-register.yml"
write_validator_report "$release_id" "compatibility-retirement-report.yml" "V-LEG-001" "pass" "Legacy shims remain retired from live authority paths and are tracked through the retirement register."
