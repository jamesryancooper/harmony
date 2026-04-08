#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
for path in $(representative_run_card_paths); do
  run_id="$(basename "$(dirname "$path")")"
  test -f "$(measurement_summary_path "$run_id")"
  test -f "$OCTON_DIR/state/evidence/runs/$run_id/trace-pointers.yml"
done
write_validator_report "$release_id" "measurement-trace-coverage.yml" "V-OBS-002" "pass" "Representative runs retain measurement summaries and trace pointers for the admitted target universe."
