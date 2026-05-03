#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"
RELEASE_ID="2026-04-11-uec-bounded-recertified-complete"

bash "$ROOT_DIR/.octon/framework/assurance/scripts/validate-dual-pass-idempotence.sh" "$RELEASE_ID" >/dev/null

echo "PASS: closure generation is idempotent across consecutive passes"
