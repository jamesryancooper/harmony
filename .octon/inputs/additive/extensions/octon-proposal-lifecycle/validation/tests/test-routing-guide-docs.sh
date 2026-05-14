#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../../../../../../.." && pwd)"
GUIDE="$REPO_ROOT/.octon/inputs/additive/extensions/octon-proposal-lifecycle/context/routing-guide.md"

pass_count=0
fail_count=0

pass() { printf 'PASS: %s\n' "$1"; pass_count=$((pass_count + 1)); }
fail() { printf 'FAIL: %s\n' "$1" >&2; fail_count=$((fail_count + 1)); }

assert_contains() {
  local pattern="$1" label="$2"
  if rg -n --fixed-strings -- "$pattern" "$GUIDE" >/dev/null; then
    pass "$label"
  else
    fail "$label"
  fi
}

assert_not_contains() {
  local pattern="$1" label="$2"
  if rg -n -i --fixed-strings -- "$pattern" "$GUIDE" >/dev/null; then
    fail "$label"
  else
    pass "$label"
  fi
}

main() {
  local stale_program_escalation
  stale_program_escalation="Program-packet-only composite input "
  stale_program_escalation+="escalates"

  assert_contains '`packet_path` alone resolves to `explain-packet`.' \
    "packet path read-only default is documented"
  assert_contains '`program_packet_path` alone resolves to `explain-program`.' \
    "program path read-only default is documented"
  assert_contains '`source_kind` defaults to `create-packet`.' \
    "source kind packet creation default is documented"
  assert_contains '`child_packet_paths` without `program_packet_path` defaults to' \
    "child paths program creation default is documented"
  assert_contains '`create-program`.' \
    "program creation route id is documented"
  assert_contains 'program-route-handoff' \
    "program lifecycle handoff boundary is documented"
  assert_contains '--execute-routes' \
    "execute-routes boundary is documented"
  assert_contains '--max-child-concurrency' \
    "program child concurrency bound is documented"
  assert_contains '`route-progression` selects the packet lifecycle driver' \
    "route-progression execution strategy is documented"
  assert_contains '`orchestrated-replan-loop` selects the program lifecycle controller' \
    "orchestrated replan loop execution strategy is documented"
  assert_not_contains "$stale_program_escalation" \
    "stale program read-only default regression is absent"

  printf '\nPassed: %s\nFailed: %s\n' "$pass_count" "$fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
