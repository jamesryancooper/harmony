#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-proof-plane-completeness.sh"
bash "$OCTON_DIR/framework/assurance/governance/_ops/scripts/validate-proof-plane-coverage.sh"
write_validator_report "$release_id" "proof-plane-coverage-report.yml" "V-ASS-001" "pass" "All required proof planes remain present and asserted for the admitted target universe."
