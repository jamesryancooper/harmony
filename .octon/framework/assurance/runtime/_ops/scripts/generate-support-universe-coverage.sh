#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/closure-packet-common.sh"
release_id="$(resolve_release_id "${1:-}")"
out="$(release_root "$release_id")/closure/support-universe-coverage.yml"
mkdir -p "$(dirname "$out")"
supported="$(find "$SUPPORT_DOSSIER_ROOT" -name dossier.yml -print | while read -r f; do yq -r 'select(.status == "supported") | .tuple_id' "$f"; done | awk 'NF' | sort)"
excluded="$(find "$SUPPORT_DOSSIER_ROOT" -name dossier.yml -print | while read -r f; do yq -r 'select(.status != "supported") | .tuple_id' "$f"; done | awk 'NF' | sort)"

emit_surface_group() {
  local expr="$1"
  yq -r "$expr // [] | .[]" "$SUPPORT_TARGETS_DECLARATION" | awk 'NF'
}
{
  echo "schema_version: support-universe-coverage-v2"
  echo "release_id: $release_id"
  echo "generated_at: \"$(deterministic_generated_at)\""
  echo "surfaces:"
  emit_surface_group '.live_support_universe.model_classes' | sed 's/^/  - model:\/\//'
  emit_surface_group '.live_support_universe.workload_classes' | sed 's/^/  - workload:\/\//'
  emit_surface_group '.live_support_universe.context_classes' | sed 's/^/  - context:\/\//'
  emit_surface_group '.live_support_universe.locale_classes' | sed 's/^/  - locale:\/\//'
  emit_surface_group '.live_support_universe.host_adapters' | sed 's/^/  - host:\/\//'
  emit_surface_group '.live_support_universe.model_adapters' | sed 's/^/  - model-adapter:\/\//'
  emit_surface_group '.live_support_universe.capability_packs' | sed 's/^/  - capability-pack:\/\//'
  printf '%s\n' "$supported" | sed 's/^/  - /'
  echo "excluded_surfaces:"
  emit_surface_group '.resolved_non_live_surfaces.model_classes' | sed 's/^/  - model:\/\//'
  emit_surface_group '.resolved_non_live_surfaces.workload_classes' | sed 's/^/  - workload:\/\//'
  emit_surface_group '.resolved_non_live_surfaces.context_classes' | sed 's/^/  - context:\/\//'
  emit_surface_group '.resolved_non_live_surfaces.locale_classes' | sed 's/^/  - locale:\/\//'
  emit_surface_group '.resolved_non_live_surfaces.host_adapters' | sed 's/^/  - host:\/\//'
  emit_surface_group '.resolved_non_live_surfaces.model_adapters' | sed 's/^/  - model-adapter:\/\//'
  emit_surface_group '.resolved_non_live_surfaces.capability_packs' | sed 's/^/  - capability-pack:\/\//'
  printf '%s\n' "$excluded" | sed 's/^/  - /'
} >"$out"
