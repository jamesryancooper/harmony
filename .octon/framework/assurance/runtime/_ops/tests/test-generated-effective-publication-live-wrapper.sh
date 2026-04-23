#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"

bash "$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/publish-support-target-matrix.sh" >/dev/null
bash "$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/publish-pack-routes.sh" >/dev/null
bash "$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/publish-runtime-route-bundle.sh" >/dev/null
