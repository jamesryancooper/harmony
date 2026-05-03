#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"
COMMON="$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/closure-packet-common.sh"
VERIFY="$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/verify-continuity-linkage.sh"
RELEASE_ID="2026-04-11-uec-bounded-recertified-complete"
REPORT="$ROOT_DIR/.octon/state/evidence/disclosure/releases/$RELEASE_ID/closure/continuity-linkage-report.yml"

bash "$VERIFY" "$RELEASE_ID" >/dev/null

expected="$(
  bash -c '
    source "$1"
    representative_run_ids | wc -l | tr -d " "
  ' _ "$COMMON"
)"
all_contracts="$(find "$ROOT_DIR/.octon/state/control/execution/runs" -name run-contract.yml -type f | wc -l | tr -d " ")"
actual="$(yq -r '.summary.representative_runs_checked' "$REPORT")"

if [[ "$actual" != "$expected" ]]; then
  echo "FAIL: continuity linkage checked $actual runs; expected $expected representative runs" >&2
  exit 1
fi

if [[ "$all_contracts" != "$expected" && "$actual" == "$all_contracts" ]]; then
  echo "FAIL: continuity linkage widened to all run contracts" >&2
  exit 1
fi

echo "PASS: continuity linkage is scoped to representative live runs"
