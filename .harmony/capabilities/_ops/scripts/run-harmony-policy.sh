#!/usr/bin/env bash
# run-harmony-policy.sh - Resolve and execute the shared harmony-policy CLI.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAPABILITIES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$CAPABILITIES_DIR/../.." && pwd)"
RUNTIME_CRATES_DIR="$REPO_ROOT/.harmony/runtime/crates"
DEFAULT_BIN="$RUNTIME_CRATES_DIR/../_ops/state/build/runtime-crates-target/debug/harmony-policy"
ROLLOUT_STATE_FILE="$CAPABILITIES_DIR/_ops/state/rollout-mode.state"

binary_is_stale() {
  local bin="$1"
  if [[ ! -x "$bin" ]]; then
    return 0
  fi

  local src_root="$RUNTIME_CRATES_DIR/policy_engine"
  if find \
    "$src_root/src" \
    "$src_root/tests" \
    "$src_root/Cargo.toml" \
    "$RUNTIME_CRATES_DIR/Cargo.toml" \
    -type f -newer "$bin" -print -quit 2>/dev/null | grep -q .; then
    return 0
  fi

  return 1
}

ensure_harmony_policy_bin() {
  local candidate="${HARMONY_POLICY_BIN:-$DEFAULT_BIN}"

  if [[ -x "$candidate" ]] && ! binary_is_stale "$candidate"; then
    echo "$candidate"
    return 0
  fi

  if [[ ! -d "$RUNTIME_CRATES_DIR" ]]; then
    echo "Missing runtime crates directory: $RUNTIME_CRATES_DIR" >&2
    return 1
  fi

  (
    cd "$RUNTIME_CRATES_DIR"
    cargo build -q -p policy_engine --bin harmony-policy
  )

  if [[ -x "$candidate" ]]; then
    echo "$candidate"
    return 0
  fi

  if [[ -x "$DEFAULT_BIN" ]]; then
    echo "$DEFAULT_BIN"
    return 0
  fi

  echo "Unable to locate built harmony-policy binary" >&2
  return 1
}

main() {
  if [[ "${1:-}" == "--print-bin" ]]; then
    ensure_harmony_policy_bin
    return 0
  fi

  local bin
  bin="$(ensure_harmony_policy_bin)"
  if [[ -f "$ROLLOUT_STATE_FILE" ]]; then
    local mode
    mode="$(head -n 1 "$ROLLOUT_STATE_FILE" | tr -d '[:space:]')"
    if [[ "$mode" == "shadow" || "$mode" == "soft-enforce" || "$mode" == "hard-enforce" ]]; then
      export HARMONY_POLICY_MODE_OVERRIDE="$mode"
    fi
  fi
  "$bin" "$@"
}

main "$@"
