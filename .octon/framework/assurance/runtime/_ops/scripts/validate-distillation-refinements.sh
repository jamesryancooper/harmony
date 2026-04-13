#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"

FAILURE_BUNDLE_DIR="$OCTON_DIR/state/evidence/validation/failure-distillation/2026-04-11-selected-harness-concepts-integration"
REVIEW_DISAGREEMENT_DIR="$OCTON_DIR/state/evidence/validation/failure-distillation/2026-04-13-review-disagreement-calibration"
DISTILLATION_BUNDLE_DIR="$OCTON_DIR/state/evidence/validation/distillation/2026-04-11-selected-harness-concepts-integration"
SUMMARY_FILE="$OCTON_DIR/generated/cognition/distillation/2026-04-11-selected-harness-concepts-integration/summary.md"
REVIEW_DISAGREEMENT_SUMMARY="$OCTON_DIR/generated/cognition/distillation/2026-04-13-review-disagreement-calibration/summary.md"
FAILURE_WORKFLOW="$OCTON_DIR/instance/governance/contracts/failure-distillation-workflow.yml"
DISTILLATION_WORKFLOW="$OCTON_DIR/instance/governance/contracts/evidence-distillation-workflow.yml"
REVIEW_DISAGREEMENT_HELPER="$OCTON_DIR/framework/assurance/evaluators/runtime/_ops/scripts/distill-review-disagreements.sh"

errors=0
fail() { echo "[ERROR] $1"; errors=$((errors + 1)); }
pass() { echo "[OK] $1"; }

main() {
  echo "== Distillation Refinements Validation =="

  for path in \
    "$OCTON_DIR/framework/constitution/contracts/assurance/failure-classification-v1.schema.json" \
    "$OCTON_DIR/framework/constitution/contracts/assurance/hardening-recommendation-v1.schema.json" \
    "$OCTON_DIR/framework/constitution/contracts/assurance/distillation-bundle-v1.schema.json" \
    "$FAILURE_WORKFLOW" \
    "$DISTILLATION_WORKFLOW" \
    "$REVIEW_DISAGREEMENT_HELPER" \
    "$FAILURE_BUNDLE_DIR/bundle.yml" \
    "$REVIEW_DISAGREEMENT_DIR/bundle.yml" \
    "$DISTILLATION_BUNDLE_DIR/bundle.yml" \
    "$SUMMARY_FILE" \
    "$REVIEW_DISAGREEMENT_SUMMARY"
  do
    [[ -f "$path" ]] && pass "found ${path#$ROOT_DIR/}" || fail "missing ${path#$ROOT_DIR/}"
  done

  for artifact in evidence.md commands.md validation.md inventory.md; do
    [[ -f "$REVIEW_DISAGREEMENT_DIR/$artifact" ]] \
      && pass "found ${REVIEW_DISAGREEMENT_DIR#$ROOT_DIR/}/$artifact" \
      || fail "missing ${REVIEW_DISAGREEMENT_DIR#$ROOT_DIR/}/$artifact"
  done

  [[ -x "$REVIEW_DISAGREEMENT_HELPER" ]] \
    && pass "review disagreement distillation helper is executable" \
    || fail "review disagreement distillation helper must be executable"

  yq -e '.promotion_mode == "proposal_gated" and .auto_promote == false' "$FAILURE_WORKFLOW" >/dev/null 2>&1 \
    && pass "failure distillation workflow remains proposal-gated" \
    || fail "failure distillation workflow must remain proposal-gated"

  yq -e '.disagreement_support.review_findings_root == ".octon/state/evidence/runs/**/assurance/review-findings.ndjson" and .disagreement_support.review_dispositions_root == ".octon/state/control/execution/runs/**/authority/review-dispositions.yml" and (.disagreement_support.required_bundle_fields[] | select(. == "disagreement_cases")) and (.disagreement_support.required_bundle_fields[] | select(. == "calibration_candidates"))' "$FAILURE_WORKFLOW" >/dev/null 2>&1 \
    && pass "failure distillation workflow declares disagreement calibration support" \
    || fail "failure distillation workflow must declare disagreement calibration support"

  yq -e '.promotion_mode == "proposal_gated" and .auto_promote == false and .generated_outputs_non_authoritative == true' "$DISTILLATION_WORKFLOW" >/dev/null 2>&1 \
    && pass "evidence distillation workflow remains proposal-gated and non-authoritative" \
    || fail "evidence distillation workflow must remain proposal-gated and non-authoritative"

  yq -e '.schema_version == "distillation-bundle-v1" and .bundle_kind == "failure-distillation" and .promotion_mode == "proposal_gated"' "$FAILURE_BUNDLE_DIR/bundle.yml" >/dev/null 2>&1 \
    && pass "failure bundle uses distillation-bundle-v1" \
    || fail "failure bundle must use distillation-bundle-v1"

  yq -e '.classifications[]? | select(.schema_version == "failure-classification-v1")' "$FAILURE_BUNDLE_DIR/bundle.yml" >/dev/null 2>&1 \
    && pass "failure bundle retains canonical failure classifications" \
    || fail "failure bundle must retain canonical failure classifications"

  yq -e '.recommendations[]? | select(.schema_version == "hardening-recommendation-v1" and .promotion_path == "proposal_gated")' "$FAILURE_BUNDLE_DIR/bundle.yml" >/dev/null 2>&1 \
    && pass "failure bundle recommendations remain proposal-gated" \
    || fail "failure bundle recommendations must remain proposal-gated"

  yq -e '.schema_version == "distillation-bundle-v1" and .bundle_kind == "evidence-distillation" and .promotion_mode == "proposal_gated"' "$DISTILLATION_BUNDLE_DIR/bundle.yml" >/dev/null 2>&1 \
    && pass "evidence distillation bundle uses distillation-bundle-v1" \
    || fail "evidence distillation bundle must use distillation-bundle-v1"

  yq -e '.schema_version == "distillation-bundle-v1" and .bundle_kind == "failure-distillation" and .promotion_mode == "proposal_gated"' "$REVIEW_DISAGREEMENT_DIR/bundle.yml" >/dev/null 2>&1 \
    && pass "review disagreement bundle uses distillation-bundle-v1" \
    || fail "review disagreement bundle must use distillation-bundle-v1"

  yq -e '.disagreement_cases[]? | select(.evaluator_review_ref != "" and (.review_finding_refs | length) > 0 and (.review_disposition_refs | length) > 0 and (.calibration_candidate_refs | length) > 0)' "$REVIEW_DISAGREEMENT_DIR/bundle.yml" >/dev/null 2>&1 \
    && pass "review disagreement bundle retains evaluator, finding, disposition, and calibration linkage" \
    || fail "review disagreement bundle must link evaluator evidence, findings, dispositions, and calibration candidates"

  yq -e '.calibration_candidates[]? | select((.target_refs | length) > 0 and .status == "proposed")' "$REVIEW_DISAGREEMENT_DIR/bundle.yml" >/dev/null 2>&1 \
    && pass "review disagreement bundle retains proposal-gated calibration candidates" \
    || fail "review disagreement bundle must retain proposal-gated calibration candidates"

  if grep -Fq "Non-authoritative" "$SUMMARY_FILE"; then
    pass "generated distillation summary is explicitly non-authoritative"
  else
    fail "generated distillation summary must be explicitly non-authoritative"
  fi

  if grep -Fq "Non-authoritative" "$REVIEW_DISAGREEMENT_SUMMARY"; then
    pass "generated review disagreement summary is explicitly non-authoritative"
  else
    fail "generated review disagreement summary must be explicitly non-authoritative"
  fi

  echo "Validation summary: errors=$errors"
  [[ $errors -eq 0 ]]
}

main "$@"
