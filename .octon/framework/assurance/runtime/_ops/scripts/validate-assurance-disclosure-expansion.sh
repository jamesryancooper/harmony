#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"

ASSURANCE_FAMILY="$OCTON_DIR/framework/constitution/contracts/assurance/family.yml"
DISCLOSURE_FAMILY="$OCTON_DIR/framework/constitution/contracts/disclosure/family.yml"
CONTRACT_REGISTRY="$OCTON_DIR/framework/constitution/contracts/registry.yml"
EVIDENCE_OBLIGATIONS="$OCTON_DIR/framework/constitution/obligations/evidence.yml"
FAIL_CLOSED="$OCTON_DIR/framework/constitution/obligations/fail-closed.yml"
ROOT_MANIFEST="$OCTON_DIR/octon.yml"
POLICY_CONFIG="$OCTON_DIR/framework/engine/runtime/config/policy-interface.yml"
RUNS_README="$OCTON_DIR/state/evidence/runs/README.md"
STATE_EVIDENCE_README="$OCTON_DIR/state/evidence/README.md"
WRITE_RUN_SCRIPT="$OCTON_DIR/framework/orchestration/runtime/_ops/scripts/write-run.sh"
HARNESS_CARD_WRITER="$OCTON_DIR/framework/lab/runtime/_ops/scripts/write-harness-card.sh"
EVALUATOR_WRITER="$OCTON_DIR/framework/assurance/evaluators/runtime/_ops/scripts/write-evaluator-review.sh"
LAB_CATALOG="$OCTON_DIR/framework/lab/governance/catalog.yml"
EVALUATOR_ROUTING="$OCTON_DIR/framework/assurance/evaluators/review-routing.yml"
RUN_CARD="$OCTON_DIR/state/evidence/runs/run-wave3-runtime-bridge-20260327/disclosure/run-card.yml"
BEHAVIORAL_REPORT="$OCTON_DIR/state/evidence/runs/run-wave3-runtime-bridge-20260327/assurance/behavioral.yml"
MAINTAINABILITY_REPORT="$OCTON_DIR/state/evidence/runs/run-wave3-runtime-bridge-20260327/assurance/maintainability.yml"
HARNESS_CARD="$OCTON_DIR/state/evidence/lab/harness-cards/hc-wave4-assurance-disclosure-20260327.yml"
SCENARIO_PROOF="$OCTON_DIR/state/evidence/lab/scenarios/scn-wave4-assurance-disclosure-20260327/scenario-proof.yml"
BENCHMARK_CARD="$OCTON_DIR/state/evidence/lab/harness-cards/hc-wave4-benchmark-disclosure-20260327.yml"
BENCHMARK_SCENARIO="$OCTON_DIR/state/evidence/lab/scenarios/scn-wave4-benchmark-disclosure-20260327/scenario-proof.yml"
BENCHMARK_SUMMARY="$OCTON_DIR/state/evidence/lab/benchmarks/bmk-wave4-disclosure-parity-20260327/summary.yml"
BENCHMARK_EVALUATOR="$OCTON_DIR/state/evidence/lab/evaluator-reviews/evr-wave4-benchmark-disclosure-20260327.yml"
MIGRATION_PLAN="$OCTON_DIR/instance/cognition/context/shared/migrations/2026-03-27-wave4-gap-remediation-cutover/plan.md"

errors=0

fail() {
  echo "[ERROR] $1"
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

require_file() {
  local path="$1"
  if [[ -f "$path" ]]; then
    pass "found ${path#$ROOT_DIR/}"
  else
    fail "missing ${path#$ROOT_DIR/}"
  fi
}

require_dir() {
  local path="$1"
  if [[ -d "$path" ]]; then
    pass "found ${path#$ROOT_DIR/}"
  else
    fail "missing ${path#$ROOT_DIR/}"
  fi
}

require_yq() {
  local expr="$1"
  local file="$2"
  local label="$3"
  if yq -e "$expr" "$file" >/dev/null 2>&1; then
    pass "$label"
  else
    fail "$label"
  fi
}

require_text() {
  local needle="$1"
  local file="$2"
  local label="$3"
  if command -v rg >/dev/null 2>&1; then
    if rg -Fq "$needle" "$file"; then
      pass "$label"
    else
      fail "$label"
    fi
  else
    if grep -Fq -- "$needle" "$file"; then
      pass "$label"
    else
      fail "$label"
    fi
  fi
}

main() {
  echo "== Assurance, Lab, And Disclosure Expansion Validation =="

  require_file "$ASSURANCE_FAMILY"
  require_file "$DISCLOSURE_FAMILY"
  require_file "$MIGRATION_PLAN"
  require_file "$LAB_CATALOG"
  require_file "$EVALUATOR_ROUTING"
  require_file "$HARNESS_CARD_WRITER"
  require_file "$EVALUATOR_WRITER"
  require_file "$RUN_CARD"
  require_file "$BEHAVIORAL_REPORT"
  require_file "$MAINTAINABILITY_REPORT"
  require_file "$HARNESS_CARD"
  require_file "$SCENARIO_PROOF"
  require_file "$BENCHMARK_CARD"
  require_file "$BENCHMARK_SCENARIO"
  require_file "$BENCHMARK_SUMMARY"
  require_file "$BENCHMARK_EVALUATOR"
  require_dir "$OCTON_DIR/state/evidence/lab"

  require_yq '.families[] | select(.family_id == "assurance" and .status == "active-transitional")' "$CONTRACT_REGISTRY" "constitutional registry activates assurance contract family"
  require_yq '.families[] | select(.family_id == "disclosure" and .status == "active-transitional")' "$CONTRACT_REGISTRY" "constitutional registry activates disclosure contract family"
  require_yq '.integration_surfaces.assurance_contract_family.root == ".octon/framework/constitution/contracts/assurance/**"' "$CONTRACT_REGISTRY" "constitutional registry exposes assurance contract family root"
  require_yq '.integration_surfaces.disclosure_contract_family.root == ".octon/framework/constitution/contracts/disclosure/**"' "$CONTRACT_REGISTRY" "constitutional registry exposes disclosure contract family root"
  require_yq '.profile_selection_receipt_ref == ".octon/instance/cognition/context/shared/migrations/2026-03-27-wave4-gap-remediation-cutover/plan.md"' "$ASSURANCE_FAMILY" "assurance family points to latest Wave 4 remediation receipt"
  require_yq '.profile_selection_receipt_ref == ".octon/instance/cognition/context/shared/migrations/2026-03-27-wave4-gap-remediation-cutover/plan.md"' "$DISCLOSURE_FAMILY" "disclosure family points to latest Wave 4 remediation receipt"
  require_yq '.retained_evidence_roots[] | select(. == ".octon/state/evidence/lab/**")' "$EVIDENCE_OBLIGATIONS" "evidence obligations include retained lab evidence root"
  require_yq '.obligations[] | select(.id == "EVI-006" and .adoption_status == "active-transitional")' "$EVIDENCE_OBLIGATIONS" "RunCard disclosure obligation is active-transitional"
  require_yq '.obligations[] | select(.id == "EVI-007" and .adoption_status == "active-transitional")' "$EVIDENCE_OBLIGATIONS" "HarnessCard disclosure obligation is active-transitional"
  require_yq '.obligations[] | select(.id == "EVI-010" and .adoption_status == "active-transitional")' "$EVIDENCE_OBLIGATIONS" "behavioral evidence gate obligation is active-transitional"
  require_yq '.rules[] | select(.id == "FCR-013" and .route == "STAGE_ONLY")' "$FAIL_CLOSED" "fail-closed rules gate missing behavioral/disclosure evidence"

  require_yq '.resolution.runtime_inputs.assurance_contract_family == ".octon/framework/constitution/contracts/assurance"' "$ROOT_MANIFEST" "root manifest exposes assurance contract family"
  require_yq '.resolution.runtime_inputs.disclosure_contract_family == ".octon/framework/constitution/contracts/disclosure"' "$ROOT_MANIFEST" "root manifest exposes disclosure contract family"
  require_yq '.resolution.runtime_inputs.lab_framework_root == ".octon/framework/lab"' "$ROOT_MANIFEST" "root manifest exposes lab framework root"
  require_yq '.resolution.runtime_inputs.observability_framework_root == ".octon/framework/observability"' "$ROOT_MANIFEST" "root manifest exposes observability framework root"
  require_yq '.resolution.runtime_inputs.lab_evidence_root == ".octon/state/evidence/lab"' "$ROOT_MANIFEST" "root manifest exposes retained lab evidence root"
  require_yq '.paths.assurance_contract_family == ".octon/framework/constitution/contracts/assurance"' "$POLICY_CONFIG" "policy config exposes assurance contract family"
  require_yq '.paths.disclosure_contract_family == ".octon/framework/constitution/contracts/disclosure"' "$POLICY_CONFIG" "policy config exposes disclosure contract family"
  require_yq '.paths.lab_evidence_root == ".octon/state/evidence/lab"' "$POLICY_CONFIG" "policy config exposes retained lab evidence root"

  require_text "state/evidence/lab/**" "$STATE_EVIDENCE_README" "state evidence README documents lab evidence"
  require_text "assurance/" "$RUNS_README" "run evidence README documents assurance root"
  require_text "disclosure/" "$RUNS_README" "run evidence README documents disclosure root"
  require_text "write_run_card_file" "$WRITE_RUN_SCRIPT" "write-run script generates RunCards"
  require_text "write_run_evidence_expansion" "$WRITE_RUN_SCRIPT" "write-run script expands retained run evidence with proof and disclosure families"
  require_text "backfill-wave4" "$WRITE_RUN_SCRIPT" "write-run script exposes Wave 4 backfill path"
  require_text "claim_kind: \"benchmark\"" "$LAB_CATALOG" "lab catalog includes a benchmark claim"
  require_text "approved" "$EVALUATOR_ROUTING" "evaluator routing declares approved review paths"

  require_yq '.support_target_ref == ".octon/instance/governance/support-targets.yml"' "$RUN_CARD" "RunCard stays subordinate to support-target authority"
  require_yq '.proof_plane_refs.behavioral == ".octon/state/evidence/runs/run-wave3-runtime-bridge-20260327/assurance/behavioral.yml"' "$RUN_CARD" "RunCard references retained behavioral proof"
  require_yq '.proof_plane_refs.maintainability == ".octon/state/evidence/runs/run-wave3-runtime-bridge-20260327/assurance/maintainability.yml"' "$RUN_CARD" "RunCard references retained maintainability proof"
  require_yq '.evidence_refs[] | select(test("state/evidence/runs/.+/replay/manifest\\.yml$"))' "$BEHAVIORAL_REPORT" "behavioral proof references retained replay evidence"
  require_yq '.support_target_ref == ".octon/instance/governance/support-targets.yml"' "$HARNESS_CARD" "HarnessCard cites support-target authority"
  require_yq '.compatibility_tuple.model_tier == "MT-B"' "$HARNESS_CARD" "HarnessCard records model support tier"
  require_yq '.compatibility_tuple.workload_tier == "WT-2"' "$HARNESS_CARD" "HarnessCard records workload support tier"
  require_yq '.proof_bundle_refs[] | select(. == ".octon/state/evidence/lab/scenarios/scn-wave4-assurance-disclosure-20260327/scenario-proof.yml")' "$HARNESS_CARD" "HarnessCard references retained lab scenario proof"
  require_yq '.claim_kind == "benchmark"' "$BENCHMARK_CARD" "benchmark HarnessCard records benchmark claim kind"
  require_yq '.evaluator_review_ref == ".octon/state/evidence/lab/evaluator-reviews/evr-wave4-benchmark-disclosure-20260327.yml"' "$BENCHMARK_CARD" "benchmark HarnessCard references retained evaluator review"
  require_yq '.disposition == "approved"' "$BENCHMARK_EVALUATOR" "benchmark evaluator review is approved"
  require_yq '.metrics[] | select(.metric_id == "proof-coverage")' "$BENCHMARK_SUMMARY" "benchmark measurement summary records proof coverage metric"

  echo "Validation summary: errors=$errors"
  [[ $errors -eq 0 ]]
}

main "$@"
