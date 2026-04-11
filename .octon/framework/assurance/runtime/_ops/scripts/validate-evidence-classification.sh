#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/closure-packet-common.sh"

command -v yq >/dev/null 2>&1 || {
  echo "yq is required" >&2
  exit 1
}

errors=0

fail() {
  echo "[ERROR] $1" >&2
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

echo "== Evidence Classification Validation =="

while IFS= read -r run_id; do
  file="$(classification_path "$run_id")"
  artifact_count="$(yq -r '(.artifacts // []) | length' "$file")"
  if [[ "$artifact_count" -eq 0 ]]; then
    fail "$file has an empty artifacts array"
  else
    pass "$file has non-empty artifacts"
  fi
done < <(representative_run_ids)

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
