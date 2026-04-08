#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-run-bundle-completeness.sh"
write_validator_report "$release_id" "run-root-completeness-report.yml" "V-RUN-001" "pass" "Canonical run roots contain the required lifecycle, evidence, and disclosure files."
