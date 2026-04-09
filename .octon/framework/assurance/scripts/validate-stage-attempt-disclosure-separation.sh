#!/usr/bin/env bash
set -euo pipefail

if rg -n -i "stage-only and excluded from the live claim envelope|excluded from the bounded live claim|bounded live claim envelope" \
  .octon/state/control/execution/runs/uec-global-*/stage-attempts \
  .octon/state/control/execution/runs/uec-safe-stage-*/stage-attempts >/dev/null 2>&1; then
  echo "[ERROR] stage-attempt artifacts still contain claim-envelope wording" >&2
  exit 1
fi
