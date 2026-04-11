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

echo "== Workflow Authority Derivation Validation =="

for rel in \
  .github/workflows/pr-autonomy-policy.yml \
  .github/workflows/ai-review-gate.yml \
  .github/workflows/closure-certification.yml \
  .github/workflows/uec-cutover-validate.yml \
  .github/workflows/uec-cutover-certify.yml \
  .github/workflows/unified-execution-constitution-closure.yml; do
  file="$ROOT_DIR/$rel"
  [[ -f "$file" ]] || continue
  if rg -n '\.octon/state/control/execution|\.octon/state/evidence/control/execution|run-contract|approval' "$file" >/dev/null 2>&1; then
    pass "$rel references canonical authority artifacts"
  else
    fail "$rel does not visibly derive authority from canonical artifacts"
  fi
done

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
