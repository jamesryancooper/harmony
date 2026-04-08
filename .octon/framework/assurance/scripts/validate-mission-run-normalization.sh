#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
bash "$SCRIPT_DIR/validate-objective-stack.sh" "$release_id" >/dev/null
write_validator_report "$release_id" "mission-run-normalization-report.yml" "V-OBJ-002" "pass" "Mission-backed and run-only executions are machine-distinguishable with no contradictory mission fields."
