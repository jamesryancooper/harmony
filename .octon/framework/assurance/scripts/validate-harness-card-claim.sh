#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
harness_card="$(release_root "$release_id")/harness-card.yml"
coverage="$(release_root "$release_id")/closure/support-universe-coverage.yml"
yq -e '.claim_status == "complete"' "$harness_card" >/dev/null
yq -e '(.known_limits | length) == 0' "$harness_card" >/dev/null
yq -e '(.excluded_surfaces | length) == 0' "$coverage" >/dev/null
yq -e '.support_universe.model_classes[] | select(. == "frontier-governed")' "$harness_card" >/dev/null
yq -e '.capability_packs[] | select(. == "browser")' "$harness_card" >/dev/null
write_validator_report "$release_id" "universal-attainment-proof.yml" "V-DISC-002" "pass" "The active HarnessCard discloses the full target support universe with no in-scope exclusions."
