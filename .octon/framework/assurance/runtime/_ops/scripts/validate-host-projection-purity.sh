#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/validate-host-projection-non-authority.sh"
bash "$SCRIPT_DIR/verify-host-authority-purity.sh"
