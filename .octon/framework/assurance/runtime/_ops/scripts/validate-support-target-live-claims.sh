#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="$(cd -- "$OCTON_DIR/.." && pwd)"

SUPPORT_TARGETS="$OCTON_DIR/instance/governance/support-targets.yml"
AUTHORED_CARD="$OCTON_DIR/instance/governance/disclosure/harness-card.yml"
RELEASE_LINEAGE="$OCTON_DIR/instance/governance/disclosure/release-lineage.yml"
RELEASE_CARD="$ROOT_DIR/$(yq -r '.active_release.harness_card_ref' "$RELEASE_LINEAGE")"
COVERAGE_LEDGER="$ROOT_DIR/$(yq -r '.coverage_ledger_ref' "$AUTHORED_CARD")"
PACK_REGISTRY="$OCTON_DIR/instance/capabilities/runtime/packs/registry.yml"

errors=0
fail() { echo "[ERROR] $1"; errors=$((errors + 1)); }
pass() { echo "[OK] $1"; }
require_yq() { yq -e "$1" "$2" >/dev/null 2>&1 && pass "$3" || fail "$3"; }

main() {
  echo "== Support-Target Live Claim Validation =="

  require_yq '.support_claim_mode == "global-complete-finite"' "$SUPPORT_TARGETS" "support-target declaration uses final global-complete claim mode"
  require_yq '[.tuple_admissions[] | select(.support_status == "supported")] | length == 6' "$SUPPORT_TARGETS" "all six target tuples are live supported"
  require_yq '.live_support_universe.host_adapters[] | select(. == "github-control-plane")' "$SUPPORT_TARGETS" "github host adapter is live supported"
  require_yq '.live_support_universe.host_adapters[] | select(. == "ci-control-plane")' "$SUPPORT_TARGETS" "ci host adapter is live supported"
  require_yq '.live_support_universe.host_adapters[] | select(. == "studio-control-plane")' "$SUPPORT_TARGETS" "studio host adapter is live supported"
  require_yq '.packs[] | select(.pack_id == "browser" and .admission_status == "admitted")' "$PACK_REGISTRY" "browser pack is admitted"
  require_yq '.packs[] | select(.pack_id == "api" and .admission_status == "admitted")' "$PACK_REGISTRY" "api pack is admitted"

  require_yq '.claim_summary == load("'"$AUTHORED_CARD"'").claim_summary' "$RELEASE_CARD" "active release HarnessCard wording matches authored disclosure"
  require_yq '(.known_limits | length) == 0' "$AUTHORED_CARD" "authored HarnessCard has no in-scope exclusions"
  require_yq '(.known_limits | length) == 0' "$RELEASE_CARD" "active release HarnessCard has no in-scope exclusions"
  require_yq '(.excluded_surfaces | length) == 0' "$COVERAGE_LEDGER" "coverage ledger contains no excluded in-scope surfaces"

  echo "Validation summary: errors=$errors"
  [[ $errors -eq 0 ]]
}

main "$@"
