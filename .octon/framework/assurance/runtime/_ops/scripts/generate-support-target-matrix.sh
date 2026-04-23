#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/closure-packet-common.sh"
source "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/publication-wrapper-common.sh"

enter_publication_runtime_boundary support-target-matrix

require_yq

out="$OCTON_DIR/generated/effective/governance/support-target-matrix.yml"
mkdir -p "$(dirname "$out")"

{
  echo "schema_version: effective-support-target-matrix-v1"
  echo "generated_at: \"$(deterministic_generated_at)\""
  echo "source_ref: .octon/instance/governance/support-targets.yml"
  echo "admission_source_root: .octon/instance/governance/support-target-admissions"
  echo "default_route: $(yq -r '.default_route' "$SUPPORT_TARGETS_DECLARATION")"
  echo "supported_tuples:"
  while IFS= read -r admission; do
    [[ -f "$admission" ]] || continue
    if [[ "$(yq -r '.status // ""' "$admission")" != "supported" ]]; then
      continue
    fi
    tuple_id="$(yq -r '.tuple_id' "$admission")"
    route="$(yq -r '.route // ""' "$admission")"
    requires_mission="$(yq -r '.requires_mission // false' "$admission")"
    claim_effect="$(yq -r '.claim_effect // ""' "$admission")"
    echo "  - tuple_id: $tuple_id"
    echo "    route: $route"
    echo "    requires_mission: $requires_mission"
    echo "    claim_effect: $claim_effect"
    echo "    capability_packs:"
    yq -r '.allowed_capability_packs[]' "$admission" | sed 's/^/      - /'
  done < <(tuple_inventory_files)
  echo "excluded_tuples: []"
} >"$out"
