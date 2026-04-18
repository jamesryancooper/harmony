#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="$(cd -- "$OCTON_DIR/.." && pwd)"

errors=0
fail() { echo "[ERROR] $1"; errors=$((errors + 1)); }
pass() { echo "[OK] $1"; }

echo "== Bounded Claim Nomenclature Validation =="
support_mode="$(yq -r '.support_claim_mode' "$OCTON_DIR/instance/governance/support-targets.yml")"
[[ "$support_mode" == "bounded-admitted-finite" ]] && pass "support-target declaration uses bounded admitted-finite wording" || fail "support-target declaration still uses incorrect bounded wording"

claim_scope="$(yq -r '.active_release.claim_scope' "$OCTON_DIR/instance/governance/disclosure/release-lineage.yml")"
[[ "$claim_scope" == "bounded-admitted-finite" ]] && pass "active release lineage uses bounded admitted-finite claim scope" || fail "active release lineage does not use bounded admitted-finite claim scope"

status_mode="$(yq -r '.summary.support_universe_mode' "$OCTON_DIR/generated/effective/closure/claim-status.yml")"
[[ "$status_mode" == "bounded-admitted-finite" ]] && pass "effective claim-status uses bounded admitted-finite support universe mode" || fail "effective claim-status still uses incorrect support universe mode"

closure_mode="$(yq -r '.support_universe_mode' "$OCTON_DIR/instance/governance/closure/closure-summary.yml")"
[[ "$closure_mode" == "bounded-admitted-finite" ]] && pass "closure summary uses bounded admitted-finite support universe mode" || fail "closure summary still uses incorrect support universe mode"

if /usr/bin/grep -Fq "full-attainment" "$OCTON_DIR/instance/governance/closure/unified-execution-constitution-status.yml"; then
  fail "status matrix still contains active full-attainment wording"
else
  pass "status matrix uses bounded-attainment wording"
fi

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
