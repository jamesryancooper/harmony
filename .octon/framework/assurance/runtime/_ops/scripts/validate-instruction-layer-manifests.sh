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

echo "== Instruction Layer Manifest Validation =="

while IFS= read -r run_id; do
  file="$OCTON_DIR/state/evidence/runs/$run_id/instruction-layer-manifest.json"
  key_count="$(yq -r 'keys | length' "$file")"
  if [[ "$key_count" -le 2 ]]; then
    fail "$file is skeletal"
  else
    pass "$file is substantive"
  fi
done < <(representative_run_ids)

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
