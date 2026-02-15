#!/usr/bin/env bash
# validate-filesystem-graph.sh - verify filesystem-graph contract and wiring.

set -o pipefail

HARMONY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
SERVICE_DIR="$HARMONY_DIR/capabilities/services/interfaces/filesystem-graph"
COMMANDS_MANIFEST="$HARMONY_DIR/capabilities/commands/manifest.yml"
SERVICES_MANIFEST="$HARMONY_DIR/capabilities/services/manifest.yml"
SERVICES_REGISTRY="$HARMONY_DIR/capabilities/services/registry.yml"
CONTEXT_INDEX="$HARMONY_DIR/cognition/context/index.yml"

errors=0

check_file() {
  local f="$1"
  if [[ ! -f "$f" ]]; then
    echo "ERROR: missing file: $f"
    errors=$((errors + 1))
  fi
}

required_files=(
  "$SERVICE_DIR/SERVICE.md"
  "$SERVICE_DIR/contract.md"
  "$SERVICE_DIR/schema/input.schema.json"
  "$SERVICE_DIR/schema/output.schema.json"
  "$SERVICE_DIR/schema/node.schema.json"
  "$SERVICE_DIR/schema/edge.schema.json"
  "$SERVICE_DIR/schema/snapshot-manifest.schema.json"
  "$SERVICE_DIR/rules/rules.yml"
  "$SERVICE_DIR/contracts/invariants.md"
  "$SERVICE_DIR/contracts/errors.yml"
  "$SERVICE_DIR/impl/filesystem-graph.sh"
  "$SERVICE_DIR/impl/snapshot-build.sh"
  "$SERVICE_DIR/impl/snapshot-diff.sh"
)

for f in "${required_files[@]}"; do
  check_file "$f"
done

if ! rg -n "id: filesystem-graph" "$SERVICES_MANIFEST" >/dev/null 2>&1; then
  echo "ERROR: services manifest missing filesystem-graph entry"
  errors=$((errors + 1))
fi

if ! rg -n "^  filesystem-graph:" "$SERVICES_REGISTRY" >/dev/null 2>&1; then
  echo "ERROR: services registry missing filesystem-graph entry"
  errors=$((errors + 1))
fi

if ! rg -n "id: filesystem-graph" "$COMMANDS_MANIFEST" >/dev/null 2>&1; then
  echo "ERROR: commands manifest missing filesystem-graph command"
  errors=$((errors + 1))
fi

if ! rg -n "id: filesystem-graph-interop" "$CONTEXT_INDEX" >/dev/null 2>&1; then
  echo "ERROR: context index missing filesystem-graph-interop entry"
  errors=$((errors + 1))
fi

# Smoke test snapshot build + current pointer.
SMOKE_OUT="$(bash "$SERVICE_DIR/impl/snapshot-build.sh" --root "$HARMONY_DIR" --set-current true)"
if ! jq -e '.ok == true and (.snapshot_id | startswith("snap-"))' >/dev/null 2>&1 <<<"$SMOKE_OUT"; then
  echo "ERROR: snapshot-build smoke test failed"
  errors=$((errors + 1))
fi

if [[ "$errors" -gt 0 ]]; then
  echo "filesystem-graph validation failed with $errors error(s)."
  exit 1
fi

echo "filesystem-graph validation passed"
