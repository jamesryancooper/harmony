#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../../../../../.." && pwd)"
TEST_NAME="$(basename "$0")"
GENERATOR="$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/generate-run-health-read-model.sh"
VALIDATOR="$ROOT_DIR/.octon/framework/assurance/runtime/_ops/scripts/validate-run-health-read-model.sh"
FIXTURE_ROOT="$ROOT_DIR/.octon/framework/assurance/runtime/_ops/fixtures/run-health-read-model"

pass_count=0
fail_count=0
cleanup_dirs=()

cleanup() {
  local dir
  for dir in "${cleanup_dirs[@]}"; do
    case "$dir" in
      "${TMPDIR:-/tmp}"/run-health-read-model.*)
        [[ -d "$dir" ]] && rm -r -- "$dir"
        ;;
      *)
        echo "refusing to remove unexpected cleanup path: $dir" >&2
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

create_fixture_copy() {
  local tmp
  tmp="$(mktemp -d "${TMPDIR:-/tmp}/run-health-read-model.XXXXXX")"
  cleanup_dirs+=("$tmp")
  cp -R "$FIXTURE_ROOT" "$tmp/fixtures"
  printf '%s\n' "$tmp"
}

case_fixture_statuses_validate() {
  local tmp
  tmp="$(create_fixture_copy)"
  OCTON_RUN_HEALTH_GENERATED_AT="2026-04-24T00:00:00Z" \
    bash "$GENERATOR" \
      --fixtures-root "$tmp/fixtures" \
      --output-root "$tmp/generated" \
      --evidence-root "$tmp/evidence" >/dev/null
  bash "$VALIDATOR" \
    --no-live \
    --fixtures-root "$tmp/fixtures" \
    --fixture-output-root "$tmp/generated" >/dev/null
}

case_non_authority_mutation_fails() {
  local tmp
  tmp="$(create_fixture_copy)"
  OCTON_RUN_HEALTH_GENERATED_AT="2026-04-24T00:00:00Z" \
    bash "$GENERATOR" \
      --fixtures-root "$tmp/fixtures" \
      --output-root "$tmp/generated" \
      --evidence-root "$tmp/evidence" >/dev/null
  python3 - "$tmp/generated/healthy/health.yml" <<'PY'
from pathlib import Path
import sys
import yaml

path = Path(sys.argv[1])
data = yaml.safe_load(path.read_text())
data["authority"]["may_authorize"] = True
path.write_text(yaml.safe_dump(data, sort_keys=False), encoding="utf-8")
PY
  ! bash "$VALIDATOR" \
    --no-live \
    --fixtures-root "$tmp/fixtures" \
    --fixture-output-root "$tmp/generated" >/dev/null
}

case_digest_mutation_fails() {
  local tmp
  tmp="$(create_fixture_copy)"
  OCTON_RUN_HEALTH_GENERATED_AT="2026-04-24T00:00:00Z" \
    bash "$GENERATOR" \
      --fixtures-root "$tmp/fixtures" \
      --output-root "$tmp/generated" \
      --evidence-root "$tmp/evidence" >/dev/null
  python3 - "$tmp/generated/healthy/health.yml" <<'PY'
from pathlib import Path
import sys
import yaml

path = Path(sys.argv[1])
data = yaml.safe_load(path.read_text())
first_key = next(iter(data["source_digests"]))
data["source_digests"][first_key]["digest"] = "sha256:" + ("0" * 64)
path.write_text(yaml.safe_dump(data, sort_keys=False), encoding="utf-8")
PY
  ! bash "$VALIDATOR" \
    --no-live \
    --fixtures-root "$tmp/fixtures" \
    --fixture-output-root "$tmp/generated" >/dev/null
}

main() {
  assert_success "fixture statuses validate" case_fixture_statuses_validate
  assert_success "non-authority mutation fails closed" case_non_authority_mutation_fails
  assert_success "source digest mutation fails closed" case_digest_mutation_fails

  echo
  echo "$TEST_NAME: passed=$pass_count failed=$fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
