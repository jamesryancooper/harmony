#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-ssot-precedence-drift.sh"
write_validator_report "$release_id" "precedence-resolution-report.yml" "V-PREC-001" "pass" "Normative and epistemic precedence remain bound through one effective precedence path."
