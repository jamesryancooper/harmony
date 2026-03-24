#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../.." && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"

MISSION_ID=""
RECEIPT_TYPE=""
ISSUED_BY=""
REASON=""
LINKED_RUN_ID=""
OUTPUT_ROOT="$OCTON_DIR/state/evidence/control/execution"
declare -a AFFECTED_PATHS=()
declare -a DIRECTIVE_REFS=()
declare -a AUTHORIZE_UPDATE_REFS=()

usage() {
  cat <<'USAGE'
Usage:
  write-mission-control-receipt.sh \
    --mission-id <id> \
    --receipt-type <type> \
    --issued-by <ref> \
    --affected-path <path> [--affected-path <path> ...] \
    [--reason <text>] \
    [--linked-run-id <run-id>] \
    [--directive-ref <id>] \
    [--authorize-update-ref <id>] \
    [--output-root <path>]
USAGE
}

yaml_quote() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  printf '"%s"' "$value"
}

timestamp_slug() {
  date -u +"%Y%m%dT%H%M%SZ"
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --mission-id) MISSION_ID="$2"; shift 2 ;;
      --receipt-type) RECEIPT_TYPE="$2"; shift 2 ;;
      --issued-by) ISSUED_BY="$2"; shift 2 ;;
      --reason) REASON="$2"; shift 2 ;;
      --linked-run-id) LINKED_RUN_ID="$2"; shift 2 ;;
      --affected-path) AFFECTED_PATHS+=("$2"); shift 2 ;;
      --directive-ref) DIRECTIVE_REFS+=("$2"); shift 2 ;;
      --authorize-update-ref) AUTHORIZE_UPDATE_REFS+=("$2"); shift 2 ;;
      --output-root) OUTPUT_ROOT="$2"; shift 2 ;;
      -h|--help) usage; exit 0 ;;
      *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    esac
  done

  [[ -n "$MISSION_ID" ]] || { echo "--mission-id is required" >&2; exit 1; }
  [[ -n "$RECEIPT_TYPE" ]] || { echo "--receipt-type is required" >&2; exit 1; }
  [[ -n "$ISSUED_BY" ]] || { echo "--issued-by is required" >&2; exit 1; }
  [[ "${#AFFECTED_PATHS[@]}" -gt 0 ]] || { echo "at least one --affected-path is required" >&2; exit 1; }

  mkdir -p "$OUTPUT_ROOT"

  local ts ts_slug slug file event_id
  ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  ts_slug="$(timestamp_slug)"
  slug="$(printf '%s' "$RECEIPT_TYPE" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-')"
  event_id="${ts_slug}-${slug}"
  file="$OUTPUT_ROOT/${event_id}.yml"

  {
    printf 'schema_version: "control-receipt-v1"\n'
    printf 'event_id: %s\n' "$(yaml_quote "$event_id")"
    printf 'timestamp: %s\n' "$(yaml_quote "$ts")"
    printf 'mission_id: %s\n' "$(yaml_quote "$MISSION_ID")"
    printf 'receipt_type: %s\n' "$(yaml_quote "$RECEIPT_TYPE")"
    printf 'issued_by: %s\n' "$(yaml_quote "$ISSUED_BY")"
    if [[ -n "$REASON" ]]; then
      printf 'reason: %s\n' "$(yaml_quote "$REASON")"
    else
      printf 'reason: null\n'
    fi
    printf 'affected_paths:\n'
    for path in "${AFFECTED_PATHS[@]}"; do
      printf '  - %s\n' "$(yaml_quote "$path")"
    done
    if [[ -n "$LINKED_RUN_ID" ]]; then
      printf 'linked_run_id: %s\n' "$(yaml_quote "$LINKED_RUN_ID")"
    else
      printf 'linked_run_id: null\n'
    fi
    printf 'linked_directive_refs:\n'
    if [[ "${#DIRECTIVE_REFS[@]}" -eq 0 ]]; then
      printf '  []\n'
    else
      for ref in "${DIRECTIVE_REFS[@]}"; do
        printf '  - %s\n' "$(yaml_quote "$ref")"
      done
    fi
    printf 'linked_authorize_update_refs:\n'
    if [[ "${#AUTHORIZE_UPDATE_REFS[@]}" -eq 0 ]]; then
      printf '  []\n'
    else
      for ref in "${AUTHORIZE_UPDATE_REFS[@]}"; do
        printf '  - %s\n' "$(yaml_quote "$ref")"
      done
    fi
  } > "$file"

  printf '%s\n' "$file"
}

main "$@"
