#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"
FAILURE_WORKFLOW="$OCTON_DIR/instance/governance/contracts/failure-distillation-workflow.yml"

RUN_ID="run-wave4-benchmark-evaluator-20260327"
BUNDLE_ID="2026-04-13-review-disagreement-calibration"
FINDING_ID="wf-benchmark-maintainability-followup"
CANDIDATE_ID="calibration/review-traceability-gap"

usage() {
  cat <<'USAGE'
Usage:
  distill-review-disagreements.sh [--run-id <id>] [--bundle-id <id>] [--finding-id <id>] [--candidate-id <id>]

Defaults generate the retained disagreement-calibration bundle for
run-wave4-benchmark-evaluator-20260327.
USAGE
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --run-id) RUN_ID="$2"; shift 2 ;;
      --bundle-id) BUNDLE_ID="$2"; shift 2 ;;
      --finding-id) FINDING_ID="$2"; shift 2 ;;
      --candidate-id) CANDIDATE_ID="$2"; shift 2 ;;
      -h|--help) usage; exit 0 ;;
      *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    esac
  done

  command -v jq >/dev/null 2>&1 || {
    echo "jq is required" >&2
    exit 1
  }
  command -v yq >/dev/null 2>&1 || {
    echo "yq is required" >&2
    exit 1
  }

  local bundle_root_rel summary_root_rel bundle_root summary_root
  local evaluator_review review_findings review_dispositions maintainability_report
  local review_routing anthropic_adapter openai_adapter subject_ref timestamp
  local finding_json disposition_json finding_summary finding_details
  local classification_summary recommendation_summary

  bundle_root_rel="$(yq -r '.outputs.bundle_root' "$FAILURE_WORKFLOW")"
  summary_root_rel="$(yq -r '.outputs.generated_summary_root' "$FAILURE_WORKFLOW")"
  bundle_root="$ROOT_DIR/$bundle_root_rel/$BUNDLE_ID"
  summary_root="$ROOT_DIR/$summary_root_rel/$BUNDLE_ID"

  evaluator_review=".octon/state/evidence/runs/$RUN_ID/assurance/evaluator.yml"
  review_findings=".octon/state/evidence/runs/$RUN_ID/assurance/review-findings.ndjson"
  review_dispositions=".octon/state/control/execution/runs/$RUN_ID/authority/review-dispositions.yml"
  maintainability_report=".octon/state/evidence/runs/$RUN_ID/assurance/maintainability.yml"
  review_routing=".octon/framework/assurance/evaluators/review-routing.yml"
  anthropic_adapter=".octon/framework/assurance/evaluators/adapters/anthropic-review.yml"
  openai_adapter=".octon/framework/assurance/evaluators/adapters/openai-review.yml"

  [[ -f "$ROOT_DIR/$evaluator_review" ]] || { echo "missing evaluator review: $evaluator_review" >&2; exit 1; }
  [[ -f "$ROOT_DIR/$review_findings" ]] || { echo "missing review findings: $review_findings" >&2; exit 1; }
  [[ -f "$ROOT_DIR/$review_dispositions" ]] || { echo "missing review dispositions: $review_dispositions" >&2; exit 1; }
  [[ -f "$ROOT_DIR/$maintainability_report" ]] || { echo "missing maintainability report: $maintainability_report" >&2; exit 1; }

  finding_json="$(jq -c --arg finding_id "$FINDING_ID" 'select(.finding_id == $finding_id)' "$ROOT_DIR/$review_findings" | head -n 1)"
  [[ -n "$finding_json" ]] || { echo "finding not found: $FINDING_ID" >&2; exit 1; }

  disposition_json="$(yq -o=json '.entries[]' "$ROOT_DIR/$review_dispositions" | jq -c --arg finding_id "$FINDING_ID" 'select(.finding_id == $finding_id)' | head -n 1)"
  [[ -n "$disposition_json" ]] || { echo "disposition not found for finding: $FINDING_ID" >&2; exit 1; }

  subject_ref="$(yq -r '.subject_ref' "$ROOT_DIR/$evaluator_review")"
  timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  finding_summary="$(jq -r '.summary' <<<"$finding_json")"
  finding_details="$(jq -r '.details // ""' <<<"$finding_json")"
  classification_summary="Evaluator approval and later canonical review traceability formalization diverged enough to justify a retained disagreement-calibration bundle."
  recommendation_summary="Promote reusable disagreement capture and evaluator calibration support through the existing distillation bundle family, failure-distillation workflow, and review-disagreement authoring path."

  mkdir -p "$bundle_root" "$summary_root"

  cat > "$bundle_root/bundle.yml" <<EOF
schema_version: "distillation-bundle-v1"
bundle_id: "$BUNDLE_ID"
bundle_kind: "failure-distillation"
subject_ref: "$evaluator_review"
source_index_refs:
  - "$evaluator_review"
  - "$review_findings"
  - "$review_dispositions"
clusters:
  - cluster_id: "review-disagreement-traceability-gap"
    signal_kind: "evaluator-disagreement"
    summary: "$finding_summary"
    source_evidence_refs:
      - "$evaluator_review"
      - "$maintainability_report"
      - "$review_findings"
      - "$review_dispositions"
classifications:
  - schema_version: "failure-classification-v1"
    class_id: "failure-class/review-disagreement-traceability-gap"
    failure_kind: "governance"
    subject_ref: "$subject_ref"
    recurrence_window: "P30D"
    signal_count: 2
    summary: "$classification_summary"
    source_evidence_refs:
      - "$evaluator_review"
      - "$review_findings"
      - "$review_dispositions"
      - "$maintainability_report"
    recorded_at: "$timestamp"
recommendations:
  - schema_version: "hardening-recommendation-v1"
    recommendation_id: "hardening/review-disagreement-calibration"
    failure_class_ref: "failure-class/review-disagreement-traceability-gap"
    target_refs:
      - ".octon/framework/constitution/contracts/assurance/distillation-bundle-v1.schema.json"
      - ".octon/instance/governance/contracts/failure-distillation-workflow.yml"
      - ".octon/framework/assurance/evaluators/runtime/_ops/scripts/distill-review-disagreements.sh"
    summary: "$recommendation_summary"
    promotion_path: "proposal_gated"
    confidence: "high"
    evidence_refs:
      - "$evaluator_review"
      - "$review_findings"
      - "$review_dispositions"
    recorded_at: "$timestamp"
disagreement_cases:
  - case_id: "case/review-disagreement-traceability-gap"
    evaluator_review_ref: "$evaluator_review"
    review_finding_refs:
      - "$review_findings"
    review_disposition_refs:
      - "$review_dispositions"
    summary: "The evaluator approved the run, but canonical retained review traceability later required an explicit finding/disposition pair and a governed follow-up."
    source_evidence_refs:
      - "$evaluator_review"
      - "$maintainability_report"
      - "$review_findings"
      - "$review_dispositions"
    calibration_candidate_refs:
      - "$CANDIDATE_ID"
calibration_candidates:
  - candidate_id: "$CANDIDATE_ID"
    target_refs:
      - "$review_routing"
      - "$anthropic_adapter"
      - "$openai_adapter"
    summary: "Teach higher-scrutiny evaluator routing to flag missing canonical finding/disposition linkage as a disagreement case instead of approving on evaluator summary alone."
    proposed_change: "Require evaluator review flows that approve higher-scrutiny runs to check for canonical finding/disposition traceability whenever maintainability or governance proof indicates a gap."
    intended_effect: "Turn evaluator-vs-review traceability drift into retained calibration input rather than ad hoc prompt tuning."
    evidence_refs:
      - "$evaluator_review"
      - "$review_findings"
      - "$review_dispositions"
      - "$maintainability_report"
    status: "proposed"
promotion_mode: "proposal_gated"
generated_summary_ref: ".octon/generated/cognition/distillation/$BUNDLE_ID/summary.md"
recorded_at: "$timestamp"
EOF

  cat > "$bundle_root/evidence.md" <<EOF
# Evidence

- Evaluator approval remained retained at \`$evaluator_review\`.
- Canonical finding and disposition linkage now exists at:
  - \`$review_findings\`
  - \`$review_dispositions\`
- The disagreement bundle records the gap between evaluator approval and later
  canonical traceability formalization as calibration input, not as authority.
- Detail from the original retained finding:

> $finding_details
EOF

  cat > "$bundle_root/commands.md" <<EOF
# Commands

1. \`bash .octon/framework/assurance/evaluators/runtime/_ops/scripts/distill-review-disagreements.sh\`
2. \`bash .octon/framework/assurance/runtime/_ops/scripts/validate-distillation-refinements.sh\`
EOF

  cat > "$bundle_root/validation.md" <<EOF
# Validation

- disagreement bundle remains \`distillation-bundle-v1\`
- disagreement case links evaluator review, canonical finding, canonical disposition, and calibration candidate
- calibration candidate remains proposal-gated and non-authoritative
- generated summary remains explicitly non-authoritative
EOF

  cat > "$bundle_root/inventory.md" <<EOF
# Inventory

- \`bundle.yml\`
- \`evidence.md\`
- \`commands.md\`
- \`validation.md\`
- \`inventory.md\`
EOF

  cat > "$summary_root/summary.md" <<EOF
# Distillation Summary

Non-authoritative derived summary.

- Evaluator approval for \`$RUN_ID\` diverged from the later canonical review
  traceability follow-up.
- The retained disagreement case now links evaluator evidence, finding,
  disposition, and a proposal-gated calibration candidate.
- The candidate targets evaluator routing and review adapters without minting
  new authority.
EOF
}

main "$@"
