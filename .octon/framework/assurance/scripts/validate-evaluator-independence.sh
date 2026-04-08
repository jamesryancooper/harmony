#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-evaluator-independence.sh"
write_validator_report "$release_id" "evaluator-independence-report.yml" "V-LAB-002" "pass" "Evaluator-independence policy and retained evidence remain valid for the active release."
