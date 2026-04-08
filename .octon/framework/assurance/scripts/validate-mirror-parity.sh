#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/_validator_common.sh"
release_id="$(resolve_validator_release_id "${1:-}")"
cmp -s "$ROOT_DIR/AGENTS.md" "$ROOT_DIR/CLAUDE.md"
cmp -s "$ROOT_DIR/AGENTS.md" "$OCTON_DIR/AGENTS.md"
write_validator_report "$release_id" "mirror-parity-report.yml" "V-SOT-002" "pass" "Tool-facing ingress mirrors remain byte-parity adapters with no added policy or runtime authority."
