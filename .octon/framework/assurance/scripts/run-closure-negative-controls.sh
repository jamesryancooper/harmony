#!/usr/bin/env bash
set -euo pipefail

for path in \
  .octon/framework/assurance/fixtures/closure/blocker-a-support-target-mismatch \
  .octon/framework/assurance/fixtures/closure/blocker-b-authority-compat-leak \
  .octon/framework/assurance/fixtures/closure/blocker-c-stale-claim-wording \
  .octon/framework/assurance/fixtures/closure/blocker-d-stage-attempt-skew \
  .octon/framework/assurance/fixtures/closure/blocker-e-false-green-regime; do
  [[ -d "$path" ]] || {
    echo "[ERROR] missing negative-control fixture $path" >&2
    exit 1
  }
done
