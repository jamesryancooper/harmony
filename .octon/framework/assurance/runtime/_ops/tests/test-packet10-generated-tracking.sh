#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"
cd "$ROOT_DIR"

tracked="$(
  git ls-files .octon/generated | sort
)"

contains() {
  printf '%s\n' "$tracked" | grep -Fx "$1" >/dev/null 2>&1
}

if contains ".octon/generated/cognition/graph/nodes.yml"; then
  echo "FAIL: graph outputs should not remain tracked"
  exit 1
fi

if contains ".octon/generated/cognition/projections/materialized/cognition-runtime-surface-map.latest.yml"; then
  echo "FAIL: materialized projection outputs should not remain tracked"
  exit 1
fi

for required in \
  ".octon/generated/effective/capabilities/routing.effective.yml" \
  ".octon/generated/effective/capabilities/artifact-map.yml" \
  ".octon/generated/effective/capabilities/generation.lock.yml" \
  ".octon/generated/effective/extensions/catalog.effective.yml" \
  ".octon/generated/effective/extensions/artifact-map.yml" \
  ".octon/generated/effective/extensions/generation.lock.yml" \
  ".octon/generated/effective/locality/scopes.effective.yml" \
  ".octon/generated/effective/locality/artifact-map.yml" \
  ".octon/generated/effective/locality/generation.lock.yml" \
  ".octon/generated/proposals/registry.yml" \
  ".octon/generated/cognition/summaries/decisions.md" \
  ".octon/generated/cognition/projections/definitions/cognition-runtime-surface-map.yml"
do
  if ! contains "$required"; then
    echo "FAIL: required tracked generated artifact missing: $required"
    exit 1
  fi
done

echo "PASS: Packet 10 generated tracking policy matches the ratified matrix."
