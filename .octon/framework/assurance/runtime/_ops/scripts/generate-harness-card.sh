#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/closure-packet-common.sh"
release_id="$(resolve_release_id "${1:-}")"
out="$(release_root "$release_id")/harness-card.yml"
mkdir -p "$(dirname "$out")"
summary_file="$(release_root "$release_id")/closure/closure-summary.yml"
blocker_ledger="$(effective_closure_root)/blocker-ledger.yml"
residual_ledger="$(release_root "$release_id")/closure/residual-ledger.yml"
claim_status="$(yq -r '.claim_status // "incomplete"' "$summary_file" 2>/dev/null || printf 'incomplete')"
claim_summary="Octon's full Unified Execution Constitution attainment is not yet supportable; this release discloses open certification blockers without overstating closure."
if [[ "$claim_status" == "complete" ]]; then
  claim_summary="Octon materially substantiates a bounded Unified Execution Constitution for the admitted live support universe, with release disclosure, support claims, exemplar run evidence, and dual-pass certification regenerated from canonical repo surfaces."
fi
support_mode="$(yq -r '.support_claim_mode // "bounded-admitted-finite"' "$SUPPORT_TARGETS_DECLARATION")"
{
  echo "schema_version: harness-card-v2"
  echo "card_id: hc-target-state-closure-$release_id"
  echo "claim_kind: release"
  echo "claim_status: $claim_status"
  echo "claim_summary: >-"
  printf '  %s\n' "$claim_summary"
  echo "support_target_ref: .octon/instance/governance/support-targets.yml"
  echo "governance_exclusions_ref: .octon/instance/governance/exclusions/action-classes.yml"
  echo "support_universe:"
  yq -P '.live_support_universe' "$SUPPORT_TARGETS_DECLARATION" | sed 's/^/  /'
  echo "retained_adapters:"
  echo "  host_adapters:"
  yq -r '.live_support_universe.host_adapters[]' "$SUPPORT_TARGETS_DECLARATION" | sed 's/^/    - /'
  echo "  model_adapters:"
  yq -r '.live_support_universe.model_adapters[]' "$SUPPORT_TARGETS_DECLARATION" | sed 's/^/    - /'
  echo "capability_packs:"
  yq -r '.live_support_universe.capability_packs[]' "$SUPPORT_TARGETS_DECLARATION" | sed 's/^/  - /'
  echo "coverage_ledger_ref: .octon/state/evidence/disclosure/releases/$release_id/closure/support-universe-coverage.yml"
  echo "proof_bundle_refs:"
  echo "  - .octon/framework/constitution/claim-truth-conditions.yml"
  echo "  - .octon/generated/effective/closure/claim-status.yml"
  echo "  - .octon/instance/governance/disclosure/release-lineage.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/gate-status.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/closure-summary.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/closure-certificate.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/recertification-status.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/support-universe-coverage.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/proof-plane-coverage.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/cross-artifact-consistency.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/claim-drift-report.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/projection-parity-report.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/residual-ledger.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/disclosure-calibration-report.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/lab-reference-integrity-report.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/host-authority-purity-report.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/runtime-family-depth-report.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/continuity-linkage-report.yml"
  echo "  - .octon/state/evidence/disclosure/releases/$release_id/closure/retirement-rationale-report.yml"
  while IFS= read -r run_id; do
    echo "  - .octon/state/evidence/disclosure/runs/$run_id/run-card.yml"
  done < <(representative_run_ids)
  if [[ -f "$residual_ledger" ]] && yq -e '(.known_limits // []) | length > 0' "$residual_ledger" >/dev/null 2>&1; then
    echo "known_limits:"
    yq -r '.known_limits[]' "$residual_ledger" | sed 's/^/  - /'
  elif [[ "$claim_status" != "complete" ]]; then
    echo "known_limits:"
    yq -r '.open_blockers[].title' "$blocker_ledger" 2>/dev/null | sed 's/^/  - Open blocker: /'
    if [[ "$(yq -r '.open_blocker_count' "$blocker_ledger")" == "0" ]]; then
      echo "  - Full attainment remains blocked until certification artifacts are regenerated from the current canonical state."
    fi
  else
    echo "known_limits: []"
  fi
  echo "generated_at: \"$(deterministic_generated_at)\""
} >"$out"
