#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"

CONTRACT_REGISTRY="$OCTON_DIR/framework/constitution/contracts/registry.yml"
RETENTION_FAMILY="$OCTON_DIR/framework/constitution/contracts/retention/family.yml"
RUN_CONTINUITY_ROOT="$OCTON_DIR/state/continuity/runs"
EXTERNAL_INDEX_ROOT="$OCTON_DIR/state/evidence/external-index"
GOVERNANCE_CONTRACTS="$OCTON_DIR/instance/governance/contracts"
CLOSEOUT_REVIEWS="$OCTON_DIR/state/evidence/validation/publication/execution-closeout/2026-03-28"
RUN3="$OCTON_DIR/framework/orchestration/runtime/runs/run-wave3-runtime-bridge-20260327.yml"
RUN4="$OCTON_DIR/framework/orchestration/runtime/runs/run-wave4-benchmark-evaluator-20260327.yml"
RUNCARD3="$OCTON_DIR/state/evidence/runs/run-wave3-runtime-bridge-20260327/disclosure/run-card.yml"
RUNCARD4="$OCTON_DIR/state/evidence/runs/run-wave4-benchmark-evaluator-20260327/disclosure/run-card.yml"

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

main() {
  echo "== Execution Constitution Closeout Validation =="

  require_file "$CONTRACT_REGISTRY"
  require_file "$RETENTION_FAMILY"
  require_dir "$RUN_CONTINUITY_ROOT"
  require_dir "$EXTERNAL_INDEX_ROOT"
  require_dir "$GOVERNANCE_CONTRACTS"
  require_dir "$CLOSEOUT_REVIEWS"
  require_file "$GOVERNANCE_CONTRACTS/retirement-policy.yml"
  require_file "$GOVERNANCE_CONTRACTS/closeout-reviews.yml"
  require_file "$GOVERNANCE_CONTRACTS/disclosure-retention.yml"
  require_file "$RUN3"
  require_file "$RUN4"
  require_file "$RUNCARD3"
  require_file "$RUNCARD4"
  require_file "$RUN_CONTINUITY_ROOT/run-wave3-runtime-bridge-20260327/handoff.yml"
  require_file "$RUN_CONTINUITY_ROOT/run-wave4-benchmark-evaluator-20260327/handoff.yml"
  require_file "$CLOSEOUT_REVIEWS/drift-review.yml"
  require_file "$CLOSEOUT_REVIEWS/support-target-review.yml"
  require_file "$CLOSEOUT_REVIEWS/adapter-review.yml"
  require_file "$CLOSEOUT_REVIEWS/deletion-review.yml"

  require_yq '.families[] | select(.family_id == "retention" and .status == "active")' "$CONTRACT_REGISTRY" "constitutional registry activates retention family"
  require_yq '.integration_surfaces.run_continuity_root.path == ".octon/state/continuity/runs/**"' "$CONTRACT_REGISTRY" "contract registry exposes run continuity root"
  require_yq '.integration_surfaces.external_evidence_index_root.path == ".octon/state/evidence/external-index/**"' "$CONTRACT_REGISTRY" "contract registry exposes external evidence index root"
  require_yq '.status == "active"' "$RETENTION_FAMILY" "retention family is active"

  require_yq '.continuity_run_path == ".octon/state/continuity/runs/run-wave3-runtime-bridge-20260327/"' "$RUN3" "Wave 3 run projection points at run continuity root"
  require_yq '.continuity_run_path == ".octon/state/continuity/runs/run-wave4-benchmark-evaluator-20260327/"' "$RUN4" "Wave 4 run projection points at run continuity root"
  require_yq '.authority_decision_ref | test("^\\.octon/state/evidence/control/execution/")' "$RUN3" "Wave 3 run projection points at canonical authority evidence"
  require_yq '.authority_decision_ref | test("^\\.octon/state/evidence/control/execution/")' "$RUN4" "Wave 4 run projection points at canonical authority evidence"

  require_yq '.authority_refs.decision_artifact | test("^\\.octon/state/evidence/control/execution/")' "$RUNCARD3" "Wave 3 RunCard cites canonical authority decision"
  require_yq '.authority_refs.grant_bundle | test("^\\.octon/state/evidence/control/execution/")' "$RUNCARD3" "Wave 3 RunCard cites canonical authority grant bundle"
  require_yq '.proof_plane_refs.structural | test("/assurance/structural\\.yml$")' "$RUNCARD3" "Wave 3 RunCard cites structural proof"
  require_yq '.proof_plane_refs.governance | test("/assurance/governance\\.yml$")' "$RUNCARD3" "Wave 3 RunCard cites governance proof"
  require_yq '.authority_refs.decision_artifact | test("^\\.octon/state/evidence/control/execution/")' "$RUNCARD4" "Wave 4 RunCard cites canonical authority decision"
  require_yq '.authority_refs.grant_bundle | test("^\\.octon/state/evidence/control/execution/")' "$RUNCARD4" "Wave 4 RunCard cites canonical authority grant bundle"
  require_yq '.proof_plane_refs.structural | test("/assurance/structural\\.yml$")' "$RUNCARD4" "Wave 4 RunCard cites structural proof"
  require_yq '.proof_plane_refs.governance | test("/assurance/governance\\.yml$")' "$RUNCARD4" "Wave 4 RunCard cites governance proof"

  echo "Validation summary: errors=$errors"
  [[ $errors -eq 0 ]]
}

main "$@"
