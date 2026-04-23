#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"

cargo test \
  --manifest-path "$ROOT_DIR/.octon/framework/engine/runtime/crates/Cargo.toml" \
  -p octon_authority_engine --lib missing_token_record_fails_closed

cargo test \
  --manifest-path "$ROOT_DIR/.octon/framework/engine/runtime/crates/Cargo.toml" \
  -p octon_authority_engine --lib wrong_scope_effect_fails_closed

cargo test \
  --manifest-path "$ROOT_DIR/.octon/framework/engine/runtime/crates/Cargo.toml" \
  -p octon_authority_engine --lib single_use_effect_cannot_be_consumed_twice

cargo test \
  --manifest-path "$ROOT_DIR/.octon/framework/engine/runtime/crates/Cargo.toml" \
  -p octon_authority_engine --lib expired_effect_is_rejected
