#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"

bash "$OCTON_DIR/framework/assurance/governance/_ops/scripts/validate-proof-plane-coverage.sh" "$@"
