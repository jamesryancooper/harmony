#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
tmp_before="$(mktemp)"
tmp_after="$(mktemp)"
trap 'rm -f "$tmp_before" "$tmp_after"' EXIT
snapshot_paths=(
  "$OCTON_DIR/state/evidence/disclosure/releases/$release_id"
  "$OCTON_DIR/generated/effective/closure"
  "$OCTON_DIR/instance/governance/disclosure/harness-card.yml"
  "$OCTON_DIR/instance/governance/closure"
)

run_generation_pass() {
  bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/generate-release-bundle.sh" "$release_id"
  bash "$OCTON_DIR/framework/assurance/runtime/_ops/scripts/generate-closure-projections.sh" "$release_id"
}

run_generation_pass
find "${snapshot_paths[@]}" -type f -print0 | sort -z | xargs -0 shasum -a 256 >"$tmp_before"
run_generation_pass
find "${snapshot_paths[@]}" -type f -print0 | sort -z | xargs -0 shasum -a 256 >"$tmp_after"
diff -u "$tmp_before" "$tmp_after" >/dev/null
write_validator_report "$release_id" "second-pass-no-diff-report.yml" "V-CERT-001" "pass" "Regeneration and closure projection outputs are idempotent across consecutive passes for the active release."
