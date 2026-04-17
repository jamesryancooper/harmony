#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FIXTURES_ROOT="$PACK_ROOT/validation/fixtures/routing"
ROUTING_FILE="$PACK_ROOT/context/check-routing.yml"
REGISTRY_FILE="$PACK_ROOT/skills/registry.fragment.yml"
pass_count=0
fail_count=0

pass() { echo "PASS: $1"; pass_count=$((pass_count + 1)); }
fail() { echo "FAIL: $1" >&2; fail_count=$((fail_count + 1)); }

normalize_list() {
  awk 'NF' "$1" | LC_ALL=C sort
}

matches_pattern() {
  local path="$1" pattern="$2"
  [[ "$path" == $pattern ]]
}

scenario_direct_checks() {
  local scenario_dir="$1"
  local path family_id pattern matched
  declare -A selected=()

  while IFS= read -r path; do
    [[ -n "$path" ]] || continue
    while IFS= read -r family_id; do
      [[ -n "$family_id" ]] || continue
      matched=0
      while IFS= read -r pattern; do
        [[ -n "$pattern" ]] || continue
        if matches_pattern "$path" "$pattern"; then
          matched=1
          break
        fi
      done < <(yq -r ".routing_families[] | select(.family_id == \"$family_id\") | .path_patterns[]?" "$ROUTING_FILE")
      if [[ "$matched" -eq 1 ]]; then
        while IFS= read -r check_id; do
          [[ -n "$check_id" ]] || continue
          selected["$check_id"]=1
        done < <(yq -r ".routing_families[] | select(.family_id == \"$family_id\") | .direct_check_ids[]?" "$ROUTING_FILE")
      fi
    done < <(yq -r '.routing_families[].family_id' "$ROUTING_FILE")
  done <"$scenario_dir/changed-paths.txt"

  printf '%s\n' "${!selected[@]}" | awk 'NF' | LC_ALL=C sort
}

scenario_bundles() {
  local scenario_dir="$1"
  local path family_id pattern matched
  declare -A selected=()

  while IFS= read -r path; do
    [[ -n "$path" ]] || continue
    while IFS= read -r family_id; do
      [[ -n "$family_id" ]] || continue
      matched=0
      while IFS= read -r pattern; do
        [[ -n "$pattern" ]] || continue
        if matches_pattern "$path" "$pattern"; then
          matched=1
          break
        fi
      done < <(yq -r ".routing_families[] | select(.family_id == \"$family_id\") | .path_patterns[]?" "$ROUTING_FILE")
      if [[ "$matched" -eq 1 ]]; then
        while IFS= read -r bundle_id; do
          [[ -n "$bundle_id" ]] || continue
          selected["$bundle_id"]=1
        done < <(yq -r ".routing_families[] | select(.family_id == \"$family_id\") | .recommended_bundle_ids[]?" "$ROUTING_FILE")
      fi
    done < <(yq -r '.routing_families[].family_id' "$ROUTING_FILE")
  done <"$scenario_dir/changed-paths.txt"

  if [[ "${#selected[@]}" -eq 0 ]]; then
    fallback_id="$(yq -r '.defaults.fallback_bundle_id' "$ROUTING_FILE")"
    printf '%s\n' "$fallback_id"
  else
    printf '%s\n' "${!selected[@]}" | awk 'NF' | LC_ALL=C sort
  fi
}

scenario_repo_hygiene() {
  local scenario_dir="$1"
  local path family_id pattern matched

  while IFS= read -r path; do
    [[ -n "$path" ]] || continue
    while IFS= read -r family_id; do
      [[ -n "$family_id" ]] || continue
      matched=0
      while IFS= read -r pattern; do
        [[ -n "$pattern" ]] || continue
        if matches_pattern "$path" "$pattern"; then
          matched=1
          break
        fi
      done < <(yq -r ".routing_families[] | select(.family_id == \"$family_id\") | .path_patterns[]?" "$ROUTING_FILE")
      if [[ "$matched" -eq 1 ]]; then
        state="$(yq -r ".routing_families[] | select(.family_id == \"$family_id\") | .repo_hygiene" "$ROUTING_FILE")"
        if [[ "$state" == "conditional-scan" ]]; then
          echo "true"
          return 0
        fi
      fi
    done < <(yq -r '.routing_families[].family_id' "$ROUTING_FILE")
  done <"$scenario_dir/changed-paths.txt"

  echo "false"
}

assert_equal_file() {
  local name="$1" expected_file="$2" actual_text="$3"
  local actual_file
  actual_file="$(mktemp "${TMPDIR:-/tmp}/drift-triage-routing.XXXXXX")"
  trap 'rm -f "$actual_file"' RETURN
  printf '%s\n' "$actual_text" | awk 'NF' | LC_ALL=C sort >"$actual_file"
  if diff -u <(normalize_list "$expected_file") "$actual_file" >/dev/null; then
    pass "$name"
  else
    fail "$name"
    diff -u <(normalize_list "$expected_file") "$actual_file" || true
  fi
  rm -f "$actual_file"
  trap - RETURN
}

assert_repo_hygiene() {
  local scenario_dir="$1" expected actual
  expected="$(tr -d '[:space:]' <"$scenario_dir/expected-repo-hygiene.txt")"
  actual="$(scenario_repo_hygiene "$scenario_dir")"
  if [[ "$expected" == "$actual" ]]; then
    pass "$(basename "$scenario_dir") repo-hygiene selection"
  else
    fail "$(basename "$scenario_dir") repo-hygiene selection"
  fi
}

assert_defaults() {
  [[ "$(yq -r '.skills."octon-drift-triage".parameters[] | select(.name == "mode") | .default' "$REGISTRY_FILE")" == "select" ]] || return 1
  [[ "$(yq -r '.skills."octon-drift-triage".parameters[] | select(.name == "alignment_mode") | .default' "$REGISTRY_FILE")" == "auto" ]] || return 1
  [[ "$(yq -r '.defaults.mode' "$ROUTING_FILE")" == "select" ]] || return 1
  [[ "$(yq -r '.defaults.alignment_mode' "$ROUTING_FILE")" == "auto" ]] || return 1
}

main() {
  local scenario_dir direct_checks bundles

  if assert_defaults; then
    pass "default mode and alignment defaults are select/auto"
  else
    fail "default mode and alignment defaults are select/auto"
  fi

  while IFS= read -r scenario_dir; do
    [[ -n "$scenario_dir" ]] || continue
    direct_checks="$(scenario_direct_checks "$scenario_dir")"
    bundles="$(scenario_bundles "$scenario_dir")"
    assert_equal_file "$(basename "$scenario_dir") direct checks" "$scenario_dir/expected-direct-checks.txt" "$direct_checks"
    assert_equal_file "$(basename "$scenario_dir") recommended bundles" "$scenario_dir/expected-bundles.txt" "$bundles"
    assert_repo_hygiene "$scenario_dir"
  done < <(find "$FIXTURES_ROOT" -mindepth 1 -maxdepth 1 -type d | LC_ALL=C sort)

  echo
  echo "Passed: $pass_count"
  echo "Failed: $fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
