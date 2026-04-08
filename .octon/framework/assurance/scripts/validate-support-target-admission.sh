#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
support_targets="$OCTON_DIR/instance/governance/support-targets.yml"
coverage="$(release_root "$release_id")/closure/support-universe-coverage.yml"
yq -e '.live_support_universe.model_classes[] | select(. == "frontier-governed")' "$support_targets" >/dev/null
yq -e '.live_support_universe.host_adapters[] | select(. == "github-control-plane")' "$support_targets" >/dev/null
yq -e '.live_support_universe.host_adapters[] | select(. == "ci-control-plane")' "$support_targets" >/dev/null
yq -e '.live_support_universe.host_adapters[] | select(. == "studio-control-plane")' "$support_targets" >/dev/null
yq -e '.live_support_universe.capability_packs[] | select(. == "browser")' "$support_targets" >/dev/null
yq -e '.live_support_universe.capability_packs[] | select(. == "api")' "$support_targets" >/dev/null
yq -e '(.excluded_surfaces | length) == 0' "$coverage" >/dev/null
for file in "$OCTON_DIR"/instance/governance/support-target-admissions/*.yml; do
  yq -e '.status == "supported"' "$file" >/dev/null
done
write_validator_report "$release_id" "support-target-consistency-report.yml" "V-SUP-001" "pass" "Support-target declarations, tuple admissions, and coverage ledgers resolve the full target universe with no in-scope exclusions."
