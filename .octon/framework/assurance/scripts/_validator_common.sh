#!/usr/bin/env bash
set -euo pipefail

VALIDATOR_SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$VALIDATOR_SCRIPT_DIR/../runtime/_ops/scripts/closure-packet-common.sh"
SCRIPT_DIR="$VALIDATOR_SCRIPT_DIR"

resolve_validator_release_id() {
  resolve_release_id "${1:-}"
}

write_validator_report() {
  local release_id="$1"
  local report_name="$2"
  local validator_id="$3"
  local status="$4"
  local summary="$5"
  local out
  out="$(release_root "$release_id")/closure/$report_name"
  mkdir -p "$(dirname "$out")"
  {
    echo "schema_version: octon-validator-report-v1"
    echo "validator_id: $validator_id"
    echo "release_id: $release_id"
    echo "generated_at: \"$(deterministic_generated_at)\""
    echo "status: $status"
    echo "summary: >-"
    printf '  %s\n' "$summary"
  } >"$out"
}

representative_run_card_paths() {
  local run_id
  while IFS= read -r run_id; do
    [[ -n "$run_id" ]] || continue
    run_card_path "$run_id"
  done < <(representative_run_ids)
}
