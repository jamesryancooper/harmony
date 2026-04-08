#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-evidence-classification-schema.sh"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-evidence-classification-nonempty.sh"
bash "$OCTON_DIR/framework/assurance/governance/_ops/scripts/validate-replay-sufficiency.sh"
write_validator_report "$release_id" "evidence-retention-proof.yml" "V-EVD-001" "pass" "Tri-class evidence classification, replay pointers, and retention linkage remain valid for the admitted release."
