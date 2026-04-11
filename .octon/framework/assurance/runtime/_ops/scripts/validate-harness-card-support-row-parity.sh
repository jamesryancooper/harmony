#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"

command -v yq >/dev/null 2>&1 || {
  echo "yq is required" >&2
  exit 1
}

errors=0

fail() {
  echo "[ERROR] $1" >&2
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

echo "== Harness Card Support Row Parity Validation =="

card="$OCTON_DIR/instance/governance/disclosure/harness-card.yml"
support_targets="$OCTON_DIR/instance/governance/support-targets.yml"

workload_count="$(yq -r '(.support_universe.workload_classes // []) | length' "$card")"
tuple_count="$(yq -r '(.tuple_admissions // []) | length' "$support_targets")"

[[ "$workload_count" -gt 0 ]] && pass "harness card exposes workload classes" || fail "harness card is missing workload classes"
[[ "$tuple_count" -gt 0 ]] && pass "support-target declaration exposes tuple admissions" || fail "support-target declaration is missing tuple admissions"

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
