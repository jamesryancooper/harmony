#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"
SUPPORT_TARGETS="$OCTON_DIR/instance/governance/support-targets.yml"

errors=0
fail() { echo "[ERROR] $1"; errors=$((errors + 1)); }
pass() { echo "[OK] $1"; }

echo "== Proof Bundle Executability Validation =="

while IFS= read -r ref; do
  [[ -n "$ref" ]] || continue
  file="$ROOT_DIR/$ref"
  if [[ ! -f "$file" ]]; then
    fail "missing proof bundle: $ref"
    continue
  fi
  yq -e '.proof_planes | length > 0' "$file" >/dev/null 2>&1 \
    && pass "proof planes present for $ref" \
    || fail "proof planes missing for $ref"
  yq -e '.scenario_evidence.representative_run_refs | length > 0' "$file" >/dev/null 2>&1 \
    && pass "representative run refs present for $ref" \
    || fail "representative run refs missing for $ref"
  yq -e '.scenario_evidence.negative_control_refs | length > 0' "$file" >/dev/null 2>&1 \
    && pass "negative control refs present for $ref" \
    || fail "negative control refs missing for $ref"
  yq -e '.disclosure_evidence.run_card_refs | length > 0' "$file" >/dev/null 2>&1 \
    && pass "run card refs present for $ref" \
    || fail "run card refs missing for $ref"
  yq -e '.freshness.reviewed_at and .freshness.review_due_at and .sufficiency.status' "$file" >/dev/null 2>&1 \
    && pass "freshness and sufficiency present for $ref" \
    || fail "freshness or sufficiency missing for $ref"
  yq -e '.command_or_evaluator and .evaluator_version and .result' "$file" >/dev/null 2>&1 \
    && pass "evaluator identity and result present for $ref" \
    || fail "evaluator identity or result missing for $ref"
  yq -e '.input_digests | length > 0' "$file" >/dev/null 2>&1 \
    && pass "input digests present for $ref" \
    || fail "input digests missing for $ref"
  yq -e '.output_digests | length > 0' "$file" >/dev/null 2>&1 \
    && pass "output digests present for $ref" \
    || fail "output digests missing for $ref"
  yq -e '.pass_fail_criteria | length > 0' "$file" >/dev/null 2>&1 \
    && pass "pass/fail criteria present for $ref" \
    || fail "pass/fail criteria missing for $ref"
  yq -e '.receipt_refs | length > 0' "$file" >/dev/null 2>&1 \
    && pass "receipt refs present for $ref" \
    || fail "receipt refs missing for $ref"
done < <(yq -r '.tuple_admissions[]?.proof_bundle_ref // ""' "$SUPPORT_TARGETS")

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
