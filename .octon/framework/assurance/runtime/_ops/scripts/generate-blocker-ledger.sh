#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/closure-packet-common.sh"

require_yq

out="$(effective_closure_root)/blocker-ledger.yml"
mkdir -p "$(dirname "$out")"

declare -a open_ids=()
declare -a titles=()

if yq -e 'has("compatibility_matrix")' "$SUPPORT_TARGETS_DECLARATION" >/dev/null 2>&1; then
  open_ids+=("A")
  titles+=("support-target-tuple-inconsistency")
fi

if [[ -e "$OCTON_DIR/state/control/execution/exceptions/leases.yml" || -e "$OCTON_DIR/state/control/execution/revocations/grants.yml" ]]; then
  open_ids+=("B")
  titles+=("canonical-authority-leakage-into-compatibility-files")
fi

if rg -n -i "stage-only and excluded from the live claim envelope|excluded from the bounded live claim|bounded live claim envelope" \
  "$OCTON_DIR/state/control/execution/runs" \
  "$OCTON_DIR/state/evidence/runs" \
  "$OCTON_DIR/state/evidence/disclosure/runs" \
  "$OCTON_DIR/state/evidence/disclosure/releases/$(resolve_release_id)/harness-card.yml" >/dev/null 2>&1; then
  open_ids+=("C")
  titles+=("stale-claim-calibration-wording")
fi

while IFS= read -r run_id; do
  [[ "$(yq -r '.schema_version // ""' "$(stage_attempt_path "$run_id")")" == "stage-attempt-v2" ]] || {
    open_ids+=("D")
    titles+=("stage-attempt-family-skew")
    break
  }
done < <(representative_run_ids)

for path in \
  "$OCTON_DIR/framework/assurance/scripts/validate-support-target-canonicality.sh" \
  "$OCTON_DIR/framework/assurance/scripts/validate-canonical-authority-purity.sh" \
  "$OCTON_DIR/framework/assurance/scripts/validate-claim-calibrated-disclosure.sh" \
  "$OCTON_DIR/framework/assurance/scripts/validate-known-limits-coherence.sh" \
  "$ROOT_DIR/.github/workflows/closure-validator-sufficiency.yml"; do
  if [[ ! -e "$path" ]]; then
    open_ids+=("E")
    titles+=("closure-validator-underreach")
    break
  fi
done

{
  echo "schema_version: closure-blocker-ledger-v1"
  echo "release_id: $(resolve_release_id)"
  echo "generated_at: \"$(deterministic_generated_at)\""
  echo "open_blocker_count: ${#open_ids[@]}"
  if [[ ${#open_ids[@]} -eq 0 ]]; then
    echo "open_blockers: []"
  else
    echo "open_blockers:"
    for i in "${!open_ids[@]}"; do
      echo "  - blocker_id: ${open_ids[$i]}"
      echo "    title: ${titles[$i]}"
      echo "    status: open"
    done
  fi
} >"$out"
