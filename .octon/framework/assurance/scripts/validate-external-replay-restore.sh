#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/governance/_ops/scripts/validate-replay-sufficiency.sh"
write_validator_report "$release_id" "external-replay-restore-report.yml" "V-EVD-002" "pass" "External replay indexes, replay manifests, and restore linkage remain available for admitted runs."
