#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"

cargo test \
  --manifest-path "$ROOT_DIR/.octon/framework/engine/runtime/crates/Cargo.toml" \
  -p octon_authority_engine --lib issued_effect_verifies_and_records_consumption_receipt

cargo test \
  --manifest-path "$ROOT_DIR/.octon/framework/engine/runtime/crates/Cargo.toml" \
  -p octon_authority_engine --lib failed_run_measurement_artifacts_remain_workflow_agnostic
