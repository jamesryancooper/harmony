#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"

errors=0
fail() { echo "[ERROR] $1"; errors=$((errors + 1)); }
pass() { echo "[OK] $1"; }

echo "== Raw Generated Effective Runtime Read Validation =="

hits="$(rg -n "generated/effective/(runtime/route-bundle|capabilities/pack-routes|governance/support-target-matrix|extensions/catalog\\.effective|capabilities/routing\\.effective)" \
  "$OCTON_DIR/framework/engine/runtime/crates/authority_engine" \
  "$OCTON_DIR/framework/engine/runtime/crates/core" \
  "$OCTON_DIR/framework/engine/runtime/crates/kernel/src" \
  -g '!**/tests.rs' \
  -g '!**/pipeline.rs' \
  -g '!**/runtime_resolver/**' || true)"

if [[ -z "$hits" ]]; then
  pass "runtime crates avoid raw generated/effective reads outside runtime_resolver"
else
  fail "raw generated/effective reads detected outside runtime_resolver: $hits"
fi

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
