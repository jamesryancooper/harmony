#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-cross-artifact-route-consistency.sh"
write_validator_report "$release_id" "fail-closed-routing-report.yml" "V-AUTH-003" "pass" "Governed routes remain explicit and fail-closed instead of silently widening or continuing."
