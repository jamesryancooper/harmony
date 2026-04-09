#!/usr/bin/env bash
set -euo pipefail

claim_status="$(yq -r '.summary.claim_status' .octon/generated/effective/closure/claim-status.yml)"
blockers="$(yq -r '.open_blocker_count' .octon/generated/effective/closure/blocker-ledger.yml)"

if [[ "$claim_status" == "complete" && "$blockers" != "0" ]]; then
  echo "[ERROR] claim status is complete while blocker ledger is non-zero" >&2
  exit 1
fi
