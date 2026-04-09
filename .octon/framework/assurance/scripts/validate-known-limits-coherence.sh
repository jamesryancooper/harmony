#!/usr/bin/env bash
set -euo pipefail

blockers="$(yq -r '.open_blocker_count' .octon/generated/effective/closure/blocker-ledger.yml)"
limits="$(yq -r '.known_limits | length' .octon/state/evidence/disclosure/releases/2026-04-08-uec-full-attainment-cutover/harness-card.yml)"

if [[ "$blockers" != "0" && "$limits" == "0" ]]; then
  echo "[ERROR] known_limits is empty while blocker ledger is non-zero" >&2
  exit 1
fi
