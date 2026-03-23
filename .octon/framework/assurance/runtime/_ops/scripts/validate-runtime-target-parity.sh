#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"
TARGETS_FILE="${RUNTIME_TARGETS_FILE:-$OCTON_DIR/framework/engine/runtime/release-targets.yml}"
RUNNER_FILE="${RUNTIME_RUNNER_FILE:-$OCTON_DIR/framework/engine/runtime/run}"
RUNNER_CMD_FILE="${RUNTIME_RUNNER_CMD_FILE:-$OCTON_DIR/framework/engine/runtime/run.cmd}"
WORKFLOW_FILE="${RUNTIME_BINARIES_WORKFLOW_FILE:-$ROOT_DIR/.github/workflows/runtime-binaries.yml}"

errors=0

fail() {
  echo "[ERROR] $1"
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

has_pattern() {
  local pattern="$1"
  local file="$2"
  if command -v rg >/dev/null 2>&1; then
    rg -q "$pattern" "$file"
  else
    grep -Eq "$pattern" "$file"
  fi
}

has_text() {
  local text="$1"
  local file="$2"
  if command -v rg >/dev/null 2>&1; then
    rg -Fq "$text" "$file"
  else
    grep -Fq "$text" "$file"
  fi
}

require_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    pass "found file: ${file#$ROOT_DIR/}"
  else
    fail "missing file: ${file#$ROOT_DIR/}"
  fi
}

check_runner_contract() {
  local file="$1"
  local label="$2"

  if has_text 'release-targets.yml' "$file"; then
    pass "$label references the canonical release target matrix"
  else
    fail "$label must reference release-targets.yml"
  fi

  if has_text 'OCTON_RUNTIME_STRICT_PACKAGING' "$file"; then
    pass "$label exposes strict packaging mode"
  else
    fail "$label must expose OCTON_RUNTIME_STRICT_PACKAGING"
  fi

  if has_text 'local_launchable' "$file" && has_text 'shippable_release' "$file"; then
    pass "$label consumes local_launchable and shippable_release metadata"
  else
    fail "$label must consume local_launchable and shippable_release metadata"
  fi

  if has_pattern 'octon-(linux|macos|windows)-(x64|arm64)' "$file"; then
    fail "$label must not hardcode packaged binary names"
  else
    pass "$label no longer hardcodes packaged binary names"
  fi
}

main() {
  echo "== Runtime Target Parity Validation =="

  require_file "$TARGETS_FILE"
  require_file "$RUNNER_FILE"
  require_file "$RUNNER_CMD_FILE"
  require_file "$WORKFLOW_FILE"

  if ! command -v yq >/dev/null 2>&1; then
    fail "yq is required for runtime target parity validation"
    exit 1
  fi

  if [[ "$(yq -r '.schema_version // ""' "$TARGETS_FILE")" == "runtime-release-targets-v1" ]]; then
    pass "runtime release target schema version is correct"
  else
    fail "runtime release target schema version must be runtime-release-targets-v1"
  fi

  local duplicate_ids
  duplicate_ids="$(yq -r '.targets[]?.id // ""' "$TARGETS_FILE" | awk 'NF' | sort | uniq -d || true)"
  if [[ -n "$duplicate_ids" ]]; then
    fail "runtime target ids must be unique"
    printf '%s\n' "$duplicate_ids"
  else
    pass "runtime target ids are unique"
  fi

  local target_id
  for target_id in linux-x64 linux-arm64 windows-x64 macos-x64 macos-arm64; do
    if yq -e ".targets[] | select(.id == \"$target_id\")" "$TARGETS_FILE" >/dev/null 2>&1; then
      pass "declared runtime target exists: $target_id"
    else
      fail "missing declared runtime target: $target_id"
      continue
    fi

    if yq -e ".targets[] | select(.id == \"$target_id\" and .local_launchable == true and .shippable_release == true)" "$TARGETS_FILE" >/dev/null 2>&1; then
      pass "runtime target $target_id is local_launchable and shippable_release"
    else
      fail "runtime target $target_id must be both local_launchable and shippable_release"
    fi

    local field
    for field in os arch binary_name artifact_name runner_label source_binary; do
      if yq -e ".targets[] | select(.id == \"$target_id\") | .$field | type == \"!!str\" and . != \"\"" "$TARGETS_FILE" >/dev/null 2>&1; then
        pass "runtime target $target_id declares $field"
      else
        fail "runtime target $target_id must declare $field"
      fi
    done
  done

  check_runner_contract "$RUNNER_FILE" "runtime/run"
  check_runner_contract "$RUNNER_CMD_FILE" "runtime/run.cmd"

  if has_text '.octon/framework/engine/runtime/release-targets.yml' "$WORKFLOW_FILE" \
    && has_text 'fromJSON(needs.plan_matrix.outputs.build_matrix)' "$WORKFLOW_FILE" \
    && has_text 'publish_files' "$WORKFLOW_FILE"; then
    pass "runtime-binaries workflow derives its matrix and publish list from release-targets.yml"
  else
    fail "runtime-binaries workflow must derive build and publish state from release-targets.yml"
  fi

  if has_pattern 'octon-(linux|macos|windows)-(x64|arm64)' "$WORKFLOW_FILE"; then
    fail "runtime-binaries workflow must not hardcode packaged binary names"
  else
    pass "runtime-binaries workflow no longer hardcodes packaged binary names"
  fi

  echo "Validation summary: errors=$errors"
  if [[ "$errors" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
