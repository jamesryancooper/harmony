#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"
TEST_NAME="$(basename "$0")"
CLASSIFIER="$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/classify-proposal-worktree-hygiene.sh"

pass_count=0
fail_count=0
cleanup_dirs=()
cleanup_files=()

cleanup() {
  local dir
  for dir in "${cleanup_dirs[@]}"; do
    case "$dir" in
      "${TMPDIR:-/tmp}"/proposal-worktree-hygiene.*)
        [[ -d "$dir" ]] && rm -r -- "$dir"
        ;;
      *)
        echo "refusing to remove unexpected cleanup path: $dir" >&2
        ;;
    esac
  done
  local file
  for file in "${cleanup_files[@]}"; do
    case "$file" in
      "${TMPDIR:-/tmp}"/proposal-worktree-hygiene-output.*)
        [[ -f "$file" ]] && rm -f -- "$file"
        ;;
      *)
        echo "refusing to remove unexpected cleanup file: $file" >&2
        ;;
    esac
  done
}
trap cleanup EXIT

pass() {
  echo "PASS: $1"
  pass_count=$((pass_count + 1))
}

fail() {
  echo "FAIL: $1" >&2
  fail_count=$((fail_count + 1))
}

assert_success() {
  local label="$1"
  shift
  if "$@"; then
    pass "$label"
  else
    fail "$label"
  fi
}

assert_contains() {
  local file="$1"
  local pattern="$2"
  grep -Fq -- "$pattern" "$file"
}

new_fixture_repo() {
  local root target
  root="$(mktemp -d "${TMPDIR:-/tmp}/proposal-worktree-hygiene.XXXXXX")"
  cleanup_dirs+=("$root")
  target=".octon/inputs/exploratory/proposals/architecture/fixture-packet"
  mkdir -p "$root/.octon/framework/assurance/runtime/_ops/scripts"
  mkdir -p "$root/$target/support" "$root/$target/resources"
  cp "$CLASSIFIER" "$root/.octon/framework/assurance/runtime/_ops/scripts/classify-proposal-worktree-hygiene.sh"
  cat >"$root/$target/proposal.yml" <<'YAML'
schema_version: "proposal-v1"
proposal_id: "fixture-packet"
title: "Fixture packet"
summary: "Fixture packet."
proposal_kind: "architecture"
promotion_scope: "octon-internal"
promotion_targets:
  - ".octon/framework/example.md"
status: "implemented"
related_proposals: []
YAML
  cat >"$root/$target/resources/child-packet-index.yml" <<'YAML'
schema_version: "octon-proposal-program-child-registry-v2"
execution_mode: "gated-parallel"
default_child_lifecycle_id: "proposal-packet"
children:
  - child_id: "fixture-child"
    path: ".octon/inputs/exploratory/proposals/architecture/fixture-child"
    required: true
    deferred: false
    dependencies: []
    write_scopes:
      - ".octon/framework/child-scope.md"
YAML
  mkdir -p "$root/.octon/inputs/exploratory/proposals/architecture/fixture-child"
  cat >"$root/.octon/inputs/exploratory/proposals/architecture/fixture-child/proposal.yml" <<'YAML'
schema_version: "proposal-v1"
proposal_id: "fixture-child"
title: "Fixture child"
summary: "Fixture child."
proposal_kind: "architecture"
promotion_scope: "octon-internal"
promotion_targets:
  - ".octon/framework/child-target.md"
status: "implemented"
related_proposals: []
YAML
  mkdir -p "$root/.octon/framework"
  printf 'baseline\n' >"$root/.octon/framework/example.md"
  printf 'baseline\n' >"$root/.octon/framework/child-scope.md"
  printf 'baseline\n' >"$root/.octon/framework/child-target.md"
  printf 'baseline\n' >"$root/unrelated.md"
  git -C "$root" init -q
  git -C "$root" config user.email "octon-test@example.invalid"
  git -C "$root" config user.name "Octon Test"
  git -C "$root" add .
  git -C "$root" commit -qm baseline
  printf '%s\n' "$root"
}

new_output_file() {
  local file
  file="$(mktemp "${TMPDIR:-/tmp}/proposal-worktree-hygiene-output.XXXXXX")"
  cleanup_files+=("$file")
  printf '%s\n' "$file"
}

run_classifier() {
  local root="$1"
  local lifecycle="$2"
  local output="$3"
  OCTON_ROOT_DIR="$root" bash "$root/.octon/framework/assurance/runtime/_ops/scripts/classify-proposal-worktree-hygiene.sh" \
    --target ".octon/inputs/exploratory/proposals/architecture/fixture-packet" \
    --lifecycle "$lifecycle" \
    --run-id "run-1" \
    --format yaml >"$output"
}

case_owned_run_paths_do_not_block() {
  local root output
  root="$(new_fixture_repo)"
  output="$(new_output_file)"
  mkdir -p "$root/.octon/state/control/execution/runs/run-1" "$root/.octon/state/evidence/runs/workflows/run-1"
  printf 'checkpoint\n' >"$root/.octon/state/control/execution/runs/run-1/checkpoint.yml"
  printf 'summary\n' >"$root/.octon/state/evidence/runs/workflows/run-1/summary.md"
  run_classifier "$root" proposal-packet "$output"
  assert_contains "$output" 'worktree_hygiene_verdict: "pass"' &&
    assert_contains "$output" "worktree_hygiene_owned_path_count: 2" &&
    assert_contains "$output" "worktree_hygiene_foreign_path_count: 0"
}

case_declared_in_scope_paths_do_not_block() {
  local root output target
  root="$(new_fixture_repo)"
  output="$(new_output_file)"
  target="$root/.octon/inputs/exploratory/proposals/architecture/fixture-packet"
  printf 'closeout\n' >"$target/support/proposal-closeout.md"
  printf 'changed\n' >"$root/.octon/framework/example.md"
  run_classifier "$root" proposal-packet "$output"
  assert_contains "$output" 'worktree_hygiene_verdict: "pass"' &&
    assert_contains "$output" "worktree_hygiene_in_scope_path_count: 2" &&
    assert_contains "$output" "worktree_hygiene_foreign_path_count: 0"
}

case_unrelated_tracked_path_blocks() {
  local root output
  root="$(new_fixture_repo)"
  output="$(new_output_file)"
  printf 'changed\n' >"$root/unrelated.md"
  run_classifier "$root" proposal-packet "$output"
  assert_contains "$output" 'worktree_hygiene_verdict: "blocked"' &&
    assert_contains "$output" 'worktree_hygiene_blocker_class: "worktree-hygiene-blocked"' &&
    assert_contains "$output" "worktree_hygiene_foreign_path_count: 1"
}

case_unrelated_untracked_path_blocks() {
  local root output
  root="$(new_fixture_repo)"
  output="$(new_output_file)"
  printf 'scratch\n' >"$root/scratch.tmp"
  run_classifier "$root" proposal-packet "$output"
  assert_contains "$output" 'worktree_hygiene_verdict: "blocked"' &&
    assert_contains "$output" "worktree_hygiene_foreign_path_count: 1"
}

case_mixed_paths_count_all_buckets() {
  local root output target
  root="$(new_fixture_repo)"
  output="$(new_output_file)"
  target="$root/.octon/inputs/exploratory/proposals/architecture/fixture-packet"
  mkdir -p "$root/.octon/state/control/execution/runs/run-1"
  printf 'checkpoint\n' >"$root/.octon/state/control/execution/runs/run-1/checkpoint.yml"
  printf 'closeout\n' >"$target/support/proposal-closeout.md"
  printf 'scratch\n' >"$root/scratch.tmp"
  run_classifier "$root" proposal-packet "$output"
  assert_contains "$output" 'worktree_hygiene_verdict: "blocked"' &&
    assert_contains "$output" "worktree_hygiene_owned_path_count: 1" &&
    assert_contains "$output" "worktree_hygiene_in_scope_path_count: 1" &&
    assert_contains "$output" "worktree_hygiene_foreign_path_count: 1"
}

case_program_child_scope_is_in_scope() {
  local root output
  root="$(new_fixture_repo)"
  output="$(new_output_file)"
  printf 'changed\n' >"$root/.octon/framework/child-scope.md"
  printf 'changed\n' >"$root/.octon/framework/child-target.md"
  run_classifier "$root" proposal-program "$output"
  assert_contains "$output" 'worktree_hygiene_verdict: "pass"' &&
    assert_contains "$output" "worktree_hygiene_in_scope_path_count: 2" &&
    assert_contains "$output" "worktree_hygiene_foreign_path_count: 0"
}

main() {
  assert_success "owned current-run control and evidence paths do not block" case_owned_run_paths_do_not_block
  assert_success "target support and promotion targets are in scope" case_declared_in_scope_paths_do_not_block
  assert_success "unrelated tracked dirty file blocks" case_unrelated_tracked_path_blocks
  assert_success "unrelated untracked file blocks" case_unrelated_untracked_path_blocks
  assert_success "mixed paths produce accurate bucket counts" case_mixed_paths_count_all_buckets
  assert_success "program child write scopes and promotion targets are in scope" case_program_child_scope_is_in_scope

  echo
  echo "$TEST_NAME: passed=$pass_count failed=$fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
