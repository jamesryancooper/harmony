#!/usr/bin/env bash
set -euo pipefail

test "$(yq -r '.open_blocker_count' .octon/generated/effective/closure/blocker-ledger.yml)" = "0"
