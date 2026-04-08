#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-cross-artifact-support-tuple-consistency.sh"
bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/validate-disclosure-wording-coherence.sh"
while IFS= read -r path; do
  yq -e '.claim_status == "supported"' "$path" >/dev/null
done < <(representative_run_card_paths)
write_validator_report "$release_id" "run-card-truth-report.yml" "V-DISC-001" "pass" "Representative RunCards are regenerated from canonical run artifacts and remain truthful for admitted tuples."
