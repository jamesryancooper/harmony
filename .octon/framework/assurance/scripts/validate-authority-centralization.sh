#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-host-projection-non-authority.sh"
write_validator_report "$release_id" "authority-centralization-report.yml" "V-AUTH-001" "pass" "Host workflows remain projection-only and canonical authority artifacts remain the sole authority source."
