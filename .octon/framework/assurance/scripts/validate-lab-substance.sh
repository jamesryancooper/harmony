#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-lab-hidden-check-coverage.sh"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-adversarial-scenario-coverage.sh"
write_validator_report "$release_id" "lab-substance-report.yml" "V-LAB-001" "pass" "Lab scenarios, hidden checks, and adversarial coverage remain populated for the admitted target universe."
