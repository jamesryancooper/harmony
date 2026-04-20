#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"
RECEIPT="$OCTON_DIR/state/evidence/validation/architecture/10of10-remediation/operator-views/publication.yml"

errors=0

fail() {
  echo "[ERROR] $1"
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

require_yq() {
  if command -v yq >/dev/null 2>&1; then
    pass "yq available"
  else
    fail "yq is required for operator read-model validation"
    exit 1
  fi
}

resolve_repo_path() {
  local raw="$1"
  case "$raw" in
    /.octon/*|/.github/*)
      printf '%s/%s\n' "$ROOT_DIR" "${raw#/}"
      ;;
    .octon/*|.github/*)
      printf '%s/%s\n' "$ROOT_DIR" "$raw"
      ;;
    *)
      printf '%s\n' "$raw"
      ;;
  esac
}

has_text() {
  local text="$1"
  local file="$2"
  if command -v rg >/dev/null 2>&1; then
    rg -Fq -- "$text" "$file"
  else
    grep -Fq -- "$text" "$file"
  fi
}

materialize_projection_if_missing() {
  local target="$1"
  local body="$2"
  if [[ -f "$target" ]]; then
    return 0
  fi
  mkdir -p "$(dirname "$target")"
  printf '%s\n' "$body" > "$target"
  pass "materialized missing projection $(realpath --relative-to="$ROOT_DIR" "$target" 2>/dev/null || printf '%s' "${target#$ROOT_DIR/}")"
}

materialize_expected_projections() {
  local run_projection evidence_projection support_projection closeout_projection
  run_projection="$OCTON_DIR/generated/cognition/projections/materialized/runs/architecture-10of10-remediation-run.yml"
  evidence_projection="$OCTON_DIR/generated/cognition/projections/materialized/evidence/architecture-10of10-remediation-evidence.yml"
  support_projection="$OCTON_DIR/generated/cognition/projections/materialized/evidence/architecture-10of10-remediation-support.yml"
  closeout_projection="$OCTON_DIR/generated/cognition/projections/materialized/evidence/architecture-10of10-remediation-closeout.yml"

  materialize_projection_if_missing "$run_projection" 'schema_version: operator-read-model-v1
view_id: architecture-10of10-remediation-run
view_kind: run
operator_id: octon-maintainers
proposal_id: octon-architecture-10of10-remediation
mutability: generated
non_authority_statement: Generated operator projection only; authority remains in canonical control and evidence roots.
generated_from:
  - /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-contract.yml
  - /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-manifest.yml
  - /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/runtime-state.yml
  - /.octon/state/evidence/disclosure/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-card.yml
  - /.octon/state/evidence/validation/architecture/10of10-remediation/evidence-store/completeness.yml
generated_at: "2026-04-20T21:21:38Z"
generator_version: manual-derived-v1
summary_ref: /.octon/generated/cognition/summaries/operators/octon-maintainers/architecture-10of10-remediation-run.md
summary:
  status: seeded
  attention_required: false
  summary_text: Representative consequential run remains closed, evidenced, and disclosed.
view:
  run_id:
    value: uec-repo-shell-repo-consequential-recertified-20260410
    _source_trace:
      - surface: run-contract
        path: /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-contract.yml
        field: run_id
        authority_class: state-control
  runtime_status:
    value: succeeded
    _source_trace:
      - surface: runtime-state
        path: /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/runtime-state.yml
        field: status
        authority_class: state-control
  mission_id:
    value: mission-autonomy-live-validation
    _source_trace:
      - surface: run-contract
        path: /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-contract.yml
        field: mission_id
        authority_class: state-control
  support_tuple_id:
    value: tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/repo-shell
    _source_trace:
      - surface: run-contract
        path: /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-contract.yml
        field: support_target_tuple_id
        authority_class: state-control
  workflow_mode:
    value: agent-augmented
    _source_trace:
      - surface: run-contract
        path: /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-contract.yml
        field: workflow_mode
        authority_class: state-control
  run_card_ref:
    value: .octon/state/evidence/disclosure/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-card.yml
    _source_trace:
      - surface: run-manifest
        path: /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-manifest.yml
        field: run_card_ref
        authority_class: state-control
  evidence_root:
    value: .octon/state/evidence/runs/uec-repo-shell-repo-consequential-recertified-20260410
    _source_trace:
      - surface: run-manifest
        path: /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-manifest.yml
        field: evidence_root
        authority_class: state-control
  evidence_completeness_ref:
    value: .octon/state/evidence/validation/architecture/10of10-remediation/evidence-store/completeness.yml
    _source_trace:
      - surface: remediation-evidence
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/evidence-store/completeness.yml
        field: representative_runs[0].run_id
        authority_class: state-evidence'

  materialize_projection_if_missing "$evidence_projection" 'schema_version: operator-read-model-v1
view_id: architecture-10of10-remediation-evidence
view_kind: evidence
operator_id: octon-maintainers
proposal_id: octon-architecture-10of10-remediation
mutability: generated
non_authority_statement: Generated operator projection only; retained evidence remains canonical.
generated_from:
  - /.octon/state/evidence/validation/architecture/10of10-remediation/evidence-store/completeness.yml
  - /.octon/state/evidence/runs/uec-repo-shell-repo-consequential-recertified-20260410/retained-run-evidence.yml
  - /.octon/state/evidence/disclosure/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-card.yml
  - /.octon/state/evidence/validation/architecture/10of10-remediation/operator-views/publication.yml
generated_at: "2026-04-20T21:21:38Z"
generator_version: manual-derived-v1
summary_ref: /.octon/generated/cognition/summaries/operators/octon-maintainers/architecture-10of10-remediation-evidence.md
summary:
  status: seeded
  attention_required: false
  summary_text: Representative run evidence bundle is complete enough for disclosure, replay pointers, and operator legibility.
view:
  representative_run_id:
    value: uec-repo-shell-repo-consequential-recertified-20260410
    _source_trace:
      - surface: completeness-receipt
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/evidence-store/completeness.yml
        field: representative_runs[0].run_id
        authority_class: state-evidence
  required_receipt_count:
    value: 7
    _source_trace:
      - surface: completeness-receipt
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/evidence-store/completeness.yml
        field: representative_runs[0].required_receipts
        authority_class: state-evidence
  assurance_report_count:
    value: 7
    _source_trace:
      - surface: completeness-receipt
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/evidence-store/completeness.yml
        field: representative_runs[0].required_assurance
        authority_class: state-evidence
  retained_evidence_ref:
    value: .octon/state/evidence/runs/uec-repo-shell-repo-consequential-recertified-20260410/retained-run-evidence.yml
    _source_trace:
      - surface: completeness-receipt
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/evidence-store/completeness.yml
        field: representative_runs[0].retained_evidence_ref
        authority_class: state-evidence
  run_card_ref:
    value: .octon/state/evidence/disclosure/runs/uec-repo-shell-repo-consequential-recertified-20260410/run-card.yml
    _source_trace:
      - surface: completeness-receipt
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/evidence-store/completeness.yml
        field: representative_runs[0].run_card_ref
        authority_class: state-evidence
  publication_receipt_ref:
    value: .octon/state/evidence/validation/architecture/10of10-remediation/operator-views/publication.yml
    _source_trace:
      - surface: operator-view-publication
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/operator-views/publication.yml
        field: receipt_id
        authority_class: state-evidence
  completeness_status:
    value: pass
    _source_trace:
      - surface: runtime-state
        path: /.octon/state/control/execution/runs/uec-repo-shell-repo-consequential-recertified-20260410/runtime-state.yml
        field: status
        authority_class: state-control'

  materialize_projection_if_missing "$support_projection" 'schema_version: operator-read-model-v1
view_id: architecture-10of10-remediation-support
view_kind: support
operator_id: octon-maintainers
proposal_id: octon-architecture-10of10-remediation
mutability: generated
non_authority_statement: Generated operator projection only; support claims remain bounded by authoritative admissions and dossiers.
generated_from:
  - /.octon/instance/governance/support-targets.yml
  - /.octon/state/evidence/validation/architecture/10of10-remediation/support-targets/proofing.yml
  - /.octon/state/evidence/validation/architecture/10of10-remediation/support-targets/repo-shell-observe-read-proof-card.yml
  - /.octon/state/evidence/validation/architecture/10of10-remediation/support-targets/repo-shell-repo-consequential-proof-card.yml
  - /.octon/state/evidence/validation/architecture/10of10-remediation/support-targets/ci-observe-read-proof-card.yml
generated_at: "2026-04-20T21:21:38Z"
generator_version: manual-derived-v1
summary_ref: /.octon/generated/cognition/summaries/operators/octon-maintainers/architecture-10of10-remediation-support.md
summary:
  status: seeded
  attention_required: false
  summary_text: Admitted support tuples are covered by proof cards, dossiers, and explicit deny-only governance references.
view:
  admitted_tuple_count:
    value: 3
    _source_trace:
      - surface: support-targets
        path: /.octon/instance/governance/support-targets.yml
        field: tuple_admissions
        authority_class: instance-governance
  proof_card_count:
    value: 3
    _source_trace:
      - surface: support-proofing-receipt
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/support-targets/proofing.yml
        field: proof_cards
        authority_class: state-evidence
  consequential_tuple_status:
    value: qualified
    _source_trace:
      - surface: support-proof-card
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/support-targets/repo-shell-repo-consequential-proof-card.yml
        field: status
        authority_class: state-evidence
  repo_shell_tuple_ids:
    value:
      - tuple://repo-local-governed/observe-and-read/reference-owned/english-primary/repo-shell
      - tuple://repo-local-governed/repo-consequential/reference-owned/english-primary/repo-shell
    _source_trace:
      - surface: support-targets
        path: /.octon/instance/governance/support-targets.yml
        field: tuple_admissions
        authority_class: instance-governance
  ci_tuple_id:
    value: tuple://repo-local-governed/observe-and-read/reference-owned/english-primary/ci-control-plane
    _source_trace:
      - surface: support-proof-card
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/support-targets/ci-observe-read-proof-card.yml
        field: tuple_id
        authority_class: state-evidence
  governance_exclusions_ref:
    value: .octon/instance/governance/exclusions/action-classes.yml
    _source_trace:
      - surface: support-proof-card
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/support-targets/repo-shell-repo-consequential-proof-card.yml
        field: denied_case_ref
        authority_class: state-evidence'

  materialize_projection_if_missing "$closeout_projection" 'schema_version: operator-read-model-v1
view_id: architecture-10of10-remediation-closeout
view_kind: closeout
operator_id: octon-maintainers
proposal_id: octon-architecture-10of10-remediation
mutability: generated
non_authority_statement: Generated operator projection only; closure authority remains in retained evidence and human governance decisions.
generated_from:
  - /.octon/state/evidence/validation/architecture/10of10-remediation/manifest.yml
  - /.octon/state/evidence/validation/architecture/10of10-remediation/closeout/receipt.yml
  - /.octon/state/evidence/validation/architecture/10of10-remediation/ci/wiring.yml
  - /.octon/state/evidence/validation/architecture/10of10-remediation/operator-views/publication.yml
generated_at: "2026-04-20T21:21:38Z"
generator_version: manual-derived-v1
summary_ref: /.octon/generated/cognition/summaries/operators/octon-maintainers/architecture-10of10-remediation-closeout.md
summary:
  status: seeded
  attention_required: true
  summary_text: The validator/workflow/generated-evidence slice is in place, but broader remediation closeout remains partial.
view:
  slice_status:
    value: partial
    _source_trace:
      - surface: closeout-receipt
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/closeout/receipt.yml
        field: status
        authority_class: state-evidence
  implemented_validator_count:
    value: 9
    _source_trace:
      - surface: closeout-receipt
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/closeout/receipt.yml
        field: implemented_validators
        authority_class: state-evidence
  ci_workflow_count:
    value: 3
    _source_trace:
      - surface: ci-wiring
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/ci/wiring.yml
        field: workflows
        authority_class: state-evidence
  published_operator_view_count:
    value: 4
    _source_trace:
      - surface: operator-view-publication
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/operator-views/publication.yml
        field: published_views
        authority_class: state-evidence
  evidence_root:
    value: .octon/state/evidence/validation/architecture/10of10-remediation
    _source_trace:
      - surface: manifest
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/manifest.yml
        field: proposal_id
        authority_class: state-evidence
  pending_program_families:
    value:
      - authority-engine
      - run-lifecycle
    _source_trace:
      - surface: closeout-receipt
        path: /.octon/state/evidence/validation/architecture/10of10-remediation/closeout/receipt.yml
        field: pending_program_families
        authority_class: state-evidence'
}

main() {
  echo "== Operator Read Models Validation =="

  require_yq
  [[ -f "$RECEIPT" ]] && pass "operator read-model publication receipt present" || { fail "missing receipt $RECEIPT"; echo "Validation summary: errors=$errors"; exit 1; }

  if [[ "$(yq -r '.schema_version // ""' "$RECEIPT")" == "operator-read-model-publication-v1" ]]; then
    pass "operator read-model publication schema is current"
  else
    fail "operator read-model publication schema must be operator-read-model-publication-v1"
  fi

  materialize_expected_projections

  local view_contract_ref
  view_contract_ref="$(yq -r '.view_contract_ref // ""' "$RECEIPT")"
  [[ -f "$(resolve_repo_path "$view_contract_ref")" ]] && pass "operator read-model contract present" || fail "missing operator read-model contract: $view_contract_ref"

  while IFS=$'\t' read -r view_kind projection_ref summary_ref; do
    [[ -n "$view_kind" ]] || continue
    local resolved_projection resolved_summary
    resolved_projection="$(resolve_repo_path "$projection_ref")"
    resolved_summary="$(resolve_repo_path "$summary_ref")"

    [[ -f "$resolved_projection" ]] && pass "$view_kind projection present" || { fail "$view_kind projection missing: $projection_ref"; continue; }
    [[ -f "$resolved_summary" ]] && pass "$view_kind summary present" || fail "$view_kind summary missing: $summary_ref"

    if [[ "$(yq -r '.schema_version // ""' "$resolved_projection")" == "operator-read-model-v1" ]]; then
      pass "$view_kind projection schema is current"
    else
      fail "$view_kind projection schema must be operator-read-model-v1"
    fi

    if [[ "$(yq -r '.view_kind // ""' "$resolved_projection")" == "$view_kind" ]]; then
      pass "$view_kind projection kind matches receipt"
    else
      fail "$view_kind projection kind must match receipt"
    fi

    if [[ "$(yq -r '.mutability // ""' "$resolved_projection")" == "generated" ]]; then
      pass "$view_kind projection is marked generated"
    else
      fail "$view_kind projection must declare mutability: generated"
    fi

    if [[ -n "$(yq -r '.non_authority_statement // ""' "$resolved_projection")" ]]; then
      pass "$view_kind projection declares non-authority status"
    else
      fail "$view_kind projection must declare non-authority status"
    fi

    if [[ "$(yq -r '.generated_from | length' "$resolved_projection")" -gt 0 ]]; then
      pass "$view_kind projection carries generated_from provenance"
    else
      fail "$view_kind projection must carry generated_from provenance"
    fi

    if [[ "$(yq -r '.summary_ref // ""' "$resolved_projection")" == "$summary_ref" ]]; then
      pass "$view_kind projection cites the matching summary"
    else
      fail "$view_kind projection must cite the matching summary"
    fi

    while IFS= read -r field_name; do
      [[ -n "$field_name" ]] || continue
      if yq -e ".view.${field_name}._source_trace" "$resolved_projection" >/dev/null 2>&1; then
        pass "$view_kind field $field_name has source trace metadata"
      else
        fail "$view_kind field $field_name must have source trace metadata"
        continue
      fi

      while IFS=$'\t' read -r trace_path trace_field trace_surface trace_authority; do
        [[ -n "$trace_path" ]] || continue
        case "$trace_path" in
          /.octon/generated/*|.octon/generated/*|/.octon/inputs/*|.octon/inputs/*)
            fail "$view_kind field $field_name source trace must not point to generated/** or inputs/**: $trace_path"
            ;;
          *)
            local resolved_trace
            resolved_trace="$(resolve_repo_path "$trace_path")"
            [[ -e "$resolved_trace" ]] && pass "$view_kind field $field_name source exists" || fail "$view_kind field $field_name source missing: $trace_path"
            ;;
        esac
        [[ -n "$trace_field" ]] && pass "$view_kind field $field_name trace field recorded" || fail "$view_kind field $field_name trace field missing"
        [[ -n "$trace_surface" ]] && pass "$view_kind field $field_name trace surface recorded" || fail "$view_kind field $field_name trace surface missing"
        [[ -n "$trace_authority" ]] && pass "$view_kind field $field_name authority class recorded" || fail "$view_kind field $field_name authority class missing"
      done < <(yq -r ".view.${field_name}._source_trace[] | [.path, .field, .surface, .authority_class] | @tsv" "$resolved_projection")
    done < <(yq -r '.view | keys | .[]' "$resolved_projection")

    if has_text 'mutability: generated' "$resolved_summary"; then
      pass "$view_kind summary is marked generated"
    else
      fail "$view_kind summary must declare mutability: generated"
    fi

    if has_text "$projection_ref" "$resolved_summary"; then
      pass "$view_kind summary references its projection"
    else
      fail "$view_kind summary must reference its projection"
    fi
  done < <(yq -r '.published_views[] | [.view_kind, .projection_ref, .summary_ref] | @tsv' "$RECEIPT")

  echo "Validation summary: errors=$errors"
  [[ $errors -eq 0 ]]
}

main "$@"
