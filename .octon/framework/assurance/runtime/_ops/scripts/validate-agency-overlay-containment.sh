#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
ROOT_DIR="$(cd -- "$DEFAULT_OCTON_DIR/.." && pwd)"

errors=0

fail() {
  echo "[ERROR] $1" >&2
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

echo "== Agency Overlay Containment Validation =="

[[ -f "$ROOT_DIR/AGENTS.md" ]] && pass "repo-root AGENTS adapter exists" || fail "repo-root AGENTS adapter missing"
[[ -f "$ROOT_DIR/CLAUDE.md" ]] && pass "repo-root CLAUDE adapter exists" || fail "repo-root CLAUDE adapter missing"
[[ -f "$DEFAULT_OCTON_DIR/instance/governance/non-authority-register.yml" ]] && pass "non-authority register exists" || fail "non-authority register missing"

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
