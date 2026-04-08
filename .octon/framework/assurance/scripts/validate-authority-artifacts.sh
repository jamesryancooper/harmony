#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-approval-grant-lease-revocation-linkage.sh"
write_validator_report "$release_id" "authority-artifact-completeness-report.yml" "V-AUTH-002" "pass" "Canonical approval, grant, lease, revocation, and decision linkages resolve for the admitted governed paths."
