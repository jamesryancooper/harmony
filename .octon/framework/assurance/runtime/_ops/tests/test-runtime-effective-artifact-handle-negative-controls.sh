#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"
FIXTURE="$(mktemp -d)"
cleanup_fixture() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0
  find "$dir" -depth -mindepth 1 \( -type f -o -type l \) -exec rm -f {} +
  find "$dir" -depth -type d -empty -exec rmdir {} +
}
trap 'cleanup_fixture "$FIXTURE"' EXIT

mkdir -p \
  "$FIXTURE/.octon/generated/effective/runtime" \
  "$FIXTURE/.octon/generated/effective/capabilities"

cp "$ROOT_DIR/.octon/generated/effective/runtime/route-bundle.lock.yml" "$FIXTURE/.octon/generated/effective/runtime/route-bundle.lock.yml"
cp "$ROOT_DIR/.octon/generated/effective/capabilities/pack-routes.lock.yml" "$FIXTURE/.octon/generated/effective/capabilities/pack-routes.lock.yml"

yq -i 'del(.allowed_consumers)' "$FIXTURE/.octon/generated/effective/runtime/route-bundle.lock.yml"

if OCTON_DIR_OVERRIDE="$FIXTURE/.octon" bash "$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/validate-runtime-effective-artifact-handles.sh" >/dev/null 2>&1; then
  echo "expected runtime effective artifact handles validator to fail without allowed_consumers" >&2
  exit 1
fi
