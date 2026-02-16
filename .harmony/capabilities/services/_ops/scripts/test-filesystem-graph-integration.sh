#!/usr/bin/env bash
# test-filesystem-graph-integration.sh - runtime integration checks for snapshot/graph/discovery flows.

set -o pipefail

HARMONY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
REPO_ROOT="$(cd "$HARMONY_DIR/.." && pwd)"
RUNTIME_RUN="$HARMONY_DIR/runtime/run"
STATE_DIR=".harmony/runtime/_ops/state/snapshots"

if [[ ! -x "$RUNTIME_RUN" ]]; then
  echo "ERROR: runtime launcher not found: $RUNTIME_RUN"
  exit 1
fi

extract_json_string_field() {
  local json="$1"
  local field="$2"
  printf '%s' "$json" | tr -d '\n' | sed -nE "s/.*\"$field\"[[:space:]]*:[[:space:]]*\"([^\"]+)\".*/\\1/p"
}

assert_contains() {
  local payload="$1"
  local pattern="$2"
  local message="$3"
  if ! rg -q "$pattern" <<<"$payload"; then
    echo "ERROR: $message"
    echo "$payload"
    exit 1
  fi
}

run_op() {
  local op="$1"
  local payload="$2"
  "$RUNTIME_RUN" tool interfaces/filesystem-graph "$op" --json "$payload"
}

BUILD_OUT="$(run_op snapshot.build '{"root":".","state_dir":".harmony/runtime/_ops/state/snapshots","set_current":true}')"
assert_contains "$BUILD_OUT" '"snapshot_id"[[:space:]]*:[[:space:]]*"snap-[a-f0-9]{8,64}"' "snapshot.build missing valid snapshot_id"
SNAPSHOT_ID="$(extract_json_string_field "$BUILD_OUT" "snapshot_id")"
if [[ -z "$SNAPSHOT_ID" ]]; then
  echo "ERROR: could not extract snapshot_id from snapshot.build output"
  echo "$BUILD_OUT"
  exit 1
fi

DIFF_IN="$(printf '{"base":"%s","head":"%s","state_dir":"%s"}' "$SNAPSHOT_ID" "$SNAPSHOT_ID" "$STATE_DIR")"
DIFF_OUT="$(run_op snapshot.diff "$DIFF_IN")"
assert_contains "$DIFF_OUT" '"added"[[:space:]]*:[[:space:]]*0' "snapshot.diff expected added=0 for same snapshot"
assert_contains "$DIFF_OUT" '"removed"[[:space:]]*:[[:space:]]*0' "snapshot.diff expected removed=0 for same snapshot"
assert_contains "$DIFF_OUT" '"changed"[[:space:]]*:[[:space:]]*0' "snapshot.diff expected changed=0 for same snapshot"

GET_NODE_IN="$(printf '{"snapshot_id":"%s","node_id":"file:.harmony/START.md","state_dir":"%s"}' "$SNAPSHOT_ID" "$STATE_DIR")"
GET_NODE_OUT="$(run_op kg.get-node "$GET_NODE_IN")"
assert_contains "$GET_NODE_OUT" '"node_id"[[:space:]]*:[[:space:]]*"file:.harmony/START.md"' "kg.get-node missing expected node"

DISCOVER_START_IN="$(printf '{"snapshot_id":"%s","query":"harmony","limit":6,"content_scan_limit":80,"max_op_ms":5000,"state_dir":"%s"}' "$SNAPSHOT_ID" "$STATE_DIR")"
DISCOVER_START_OUT="$(run_op discover.start "$DISCOVER_START_IN")"
assert_contains "$DISCOVER_START_OUT" '"frontier_node_ids"[[:space:]]*:' "discover.start missing frontier results"

DISCOVER_EXPAND_IN="$(printf '{"snapshot_id":"%s","node_ids":["dir:.harmony"],"limit":64,"state_dir":"%s"}' "$SNAPSHOT_ID" "$STATE_DIR")"
DISCOVER_EXPAND_OUT="$(run_op discover.expand "$DISCOVER_EXPAND_IN")"
assert_contains "$DISCOVER_EXPAND_OUT" '"next_node_ids"[[:space:]]*:' "discover.expand missing next_node_ids"

DISCOVER_EXPLAIN_IN="$(printf '{"snapshot_id":"%s","candidate_node_ids":["file:.harmony/START.md"],"query":"harmony","state_dir":"%s"}' "$SNAPSHOT_ID" "$STATE_DIR")"
DISCOVER_EXPLAIN_OUT="$(run_op discover.explain "$DISCOVER_EXPLAIN_IN")"
assert_contains "$DISCOVER_EXPLAIN_OUT" '"input_fingerprint"[[:space:]]*:' "discover.explain missing provenance.input_fingerprint"

DISCOVER_RESOLVE_IN="$(printf '{"snapshot_id":"%s","node_id":"file:.harmony/START.md","state_dir":"%s"}' "$SNAPSHOT_ID" "$STATE_DIR")"
DISCOVER_RESOLVE_OUT="$(run_op discover.resolve "$DISCOVER_RESOLVE_IN")"
assert_contains "$DISCOVER_RESOLVE_OUT" '"exists"[[:space:]]*:[[:space:]]*(true|false)' "discover.resolve missing exists flag"

BROKEN_ID="snap-deadbeef$(printf '%08x' "$RANDOM")"
BROKEN_DIR="$REPO_ROOT/$STATE_DIR/$BROKEN_ID"
trap 'rm -rf "$BROKEN_DIR"' EXIT
mkdir -p "$BROKEN_DIR"
printf '{"snapshot_id":"%s"}\n' "$BROKEN_ID" > "$BROKEN_DIR/manifest.json"

BROKEN_IN="$(printf '{"snapshot_id":"%s","query":"harmony","limit":3,"state_dir":"%s"}' "$BROKEN_ID" "$STATE_DIR")"
BROKEN_OUT="$(run_op discover.start "$BROKEN_IN")"
assert_contains "$BROKEN_OUT" '"code"[[:space:]]*:[[:space:]]*"ERR_FILESYSTEM_GRAPH_SNAPSHOT_INVALID"' "corrupt snapshot should return ERR_FILESYSTEM_GRAPH_SNAPSHOT_INVALID"
assert_contains "$BROKEN_OUT" 'Rebuild snapshot artifacts' "corrupt snapshot response missing remediation guidance"

LIMIT_OUT="$(run_op snapshot.build '{"root":".","state_dir":".harmony/runtime/_ops/state/snapshots","set_current":false,"max_files":1}')"
assert_contains "$LIMIT_OUT" '"code"[[:space:]]*:[[:space:]]*"ERR_FILESYSTEM_GRAPH_LIMIT_EXCEEDED"' "snapshot.build max_files cap should trigger ERR_FILESYSTEM_GRAPH_LIMIT_EXCEEDED"

echo "filesystem-graph integration checks passed: $SNAPSHOT_ID"
