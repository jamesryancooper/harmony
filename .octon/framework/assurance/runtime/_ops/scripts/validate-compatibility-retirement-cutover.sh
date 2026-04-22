#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
REGISTER="$OCTON_DIR/instance/governance/retirement-register.yml"

errors=0
fail() { echo "[ERROR] $1"; errors=$((errors + 1)); }
pass() { echo "[OK] $1"; }

echo "== Compatibility Retirement Cutover Validation =="

[[ -f "$REGISTER" ]] && pass "retirement register present" || fail "missing retirement register"

for surface in ingress-projection-adapters runtime-capability-pack-projection; do
  yq -e ".entries[] | select(.surface == \"$surface\")" "$REGISTER" >/dev/null 2>&1 \
    && pass "$surface entry present" \
    || fail "$surface entry missing"
done

yq -e '.entries[] | select(.surface == "runtime-capability-pack-projection") | select(.canonical_successor_ref == ".octon/generated/effective/capabilities/pack-routes.effective.yml")' "$REGISTER" >/dev/null 2>&1 \
  && pass "runtime capability pack projection successor current" \
  || fail "runtime capability pack projection successor invalid"
yq -e '.entries[] | select(.surface == "runtime-capability-pack-projection") | select(.future_widening_blocker == true)' "$REGISTER" >/dev/null 2>&1 \
  && pass "runtime capability pack projection widening blocker active" \
  || fail "runtime capability pack projection widening blocker missing"

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
