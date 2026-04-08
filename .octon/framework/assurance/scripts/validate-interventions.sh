#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-intervention-disclosure-completeness.sh"
bash "$OCTON_DIR/framework/assurance/governance/_ops/scripts/validate-hidden-repair-intervention-disclosure.sh"
write_validator_report "$release_id" "intervention-completeness.yml" "V-OBS-001" "pass" "Intervention logs and hidden-repair checks remain complete for the admitted support universe."
