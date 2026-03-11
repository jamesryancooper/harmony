#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RUNTIME_DIR="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
ORCHESTRATION_DIR="$(cd -- "$RUNTIME_DIR/.." && pwd)"

errors=0

fail() {
  echo "[ERROR] $1"
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

if ! command -v rg >/dev/null 2>&1; then
  fail "rg is required for orchestration live-independence validation"
  echo "orchestration live-independence validation summary: errors=$errors"
  exit 1
fi

pushd "$ORCHESTRATION_DIR" >/dev/null
matches="$(
  rg -n --hidden --glob '!.git' \
    --glob '!_meta/architecture/specification.md' \
    --glob '!practices/workflow-authoring-standards.md' \
    --glob '!runtime/_ops/scripts/validate-orchestration-live-independence.sh' \
    --glob '!runtime/_ops/tests/test-orchestration-live-independence.sh' \
    --glob '!runtime/queue/_ops/scripts/validate-queue.sh' \
    --glob '!runtime/workflows/manifest.yml' \
    --glob '!runtime/workflows/registry.yml' \
    --glob '!runtime/workflows/_ops/scripts/validate-workflows.sh' \
    --glob '!runtime/workflows/meta/create-design-package/**' \
    --glob '!runtime/workflows/audit/audit-design-package/**' \
    '\.design-packages/' . || true
)"
popd >/dev/null

if [[ -n "$matches" ]]; then
  fail "live orchestration artifacts must not depend on temporary .design-packages paths"
  printf '%s\n' "$matches"
else
  pass "live orchestration artifacts avoid temporary .design-packages paths"
fi

echo "orchestration live-independence validation summary: errors=$errors"
if (( errors > 0 )); then
  exit 1
fi
