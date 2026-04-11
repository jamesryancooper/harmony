#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/validate-global-retirement-closure.sh"
bash "$SCRIPT_DIR/validate-retirement-register-depth.sh"
