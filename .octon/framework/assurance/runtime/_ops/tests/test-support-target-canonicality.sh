#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"
VALIDATOR="$ROOT_DIR/.octon/framework/assurance/scripts/validate-support-target-canonicality.sh"
MATRIX="$ROOT_DIR/.octon/generated/effective/governance/support-target-matrix.yml"

bash "$VALIDATOR" 2026-04-09-uec-bounded-hardening-closure >/dev/null
bash "$VALIDATOR" 2026-04-11-uec-bounded-recertified-complete >/dev/null

while IFS= read -r admission; do
  [[ -f "$admission" ]] || continue
  status="$(yq -r '.status // ""' "$admission")"
  [[ "$status" != "supported" ]] || continue

  tuple_id="$(yq -r '.tuple_id' "$admission")"
  count="$(yq -r "[.supported_tuples[] | select(.tuple_id == \"$tuple_id\")] | length" "$MATRIX" 2>/dev/null || printf '0')"
  if [[ "$count" != "0" ]]; then
    echo "FAIL: non-live tuple published in support matrix: $tuple_id" >&2
    exit 1
  fi
done < <(
  bash -c '
    source "$1"
    tuple_inventory_files
  ' _ "$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/closure-packet-common.sh"
)

echo "PASS: support target canonicality preserves non-live matrix boundary"
