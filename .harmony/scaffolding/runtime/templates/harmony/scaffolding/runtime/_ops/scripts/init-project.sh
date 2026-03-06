#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HARMONY_DIR="$(cd -- "$SCRIPT_DIR/../../../.." && pwd)"

exec "$HARMONY_DIR/scaffolding/runtime/bootstrap/init-project.sh" "$@"
