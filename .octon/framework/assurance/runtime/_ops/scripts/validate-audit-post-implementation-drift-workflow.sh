#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ASSURANCE_DIR="$(cd -- "$SCRIPT_DIR/../../.." && pwd)"
OCTON_DIR="$(cd -- "$ASSURANCE_DIR/.." && pwd)"
WORKFLOW_DIR="$OCTON_DIR/orchestration/runtime/workflows/meta/audit-post-implementation-drift"
WORKFLOW_MANIFEST="$OCTON_DIR/orchestration/runtime/workflows/manifest.yml"
WORKFLOW_REGISTRY="$OCTON_DIR/orchestration/runtime/workflows/registry.yml"
errors=0
fail(){ echo "[ERROR] $1"; errors=$((errors+1)); }
pass(){ echo "[OK] $1"; }
grep -Fq 'name: audit-post-implementation-drift' "$WORKFLOW_DIR/workflow.yml" && pass "workflow id matches" || fail "workflow id matches"
grep -Fq 'validate-proposal-implementation-conformance.sh' "$WORKFLOW_DIR/stages/01-audit-post-implementation-drift.md" && pass "implementation-conformance predecessor validator referenced" || fail "implementation-conformance predecessor validator referenced"
grep -Fq 'validate-proposal-post-implementation-drift.sh' "$WORKFLOW_DIR/stages/01-audit-post-implementation-drift.md" && pass "post-implementation drift validator referenced" || fail "post-implementation drift validator referenced"
grep -Fq 'post-implementation-drift-churn-review.md' "$WORKFLOW_DIR/stages/01-audit-post-implementation-drift.md" && pass "drift/churn receipt referenced" || fail "drift/churn receipt referenced"
grep -Fq 'verdict: pass' "$WORKFLOW_DIR/workflow.yml" && pass "passing verdict done gate documented" || fail "passing verdict done gate documented"
yq -e '.workflows[] | select(.id == "audit-post-implementation-drift" and .path == "meta/audit-post-implementation-drift/")' "$WORKFLOW_MANIFEST" >/dev/null 2>&1 && pass "manifest registration exists" || fail "manifest registration exists"
yq -e '.workflow_group_definitions.meta.members[] | select(. == "audit-post-implementation-drift")' "$WORKFLOW_MANIFEST" >/dev/null 2>&1 && pass "workflow is reachable from meta group" || fail "workflow is reachable from meta group"
grep -Fq 'audit-post-implementation-drift:' "$WORKFLOW_REGISTRY" && pass "registry entry exists" || fail "registry entry exists"
echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
