#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/validate-support-target-live-claims.sh"
bash "$SCRIPT_DIR/verify-support-dossier-parity.sh" "${1:-}"
