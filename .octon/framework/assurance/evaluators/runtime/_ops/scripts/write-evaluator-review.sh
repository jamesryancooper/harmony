#!/usr/bin/env bash
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required" >&2
  exit 1
fi

if ! command -v yq >/dev/null 2>&1; then
  echo "yq is required" >&2
  exit 1
fi

subject_ref=""
evaluator_id=""
disposition=""
summary=""
recorded_at=""
output=""
known_limits=()
evidence_refs=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --subject-ref) subject_ref="$2"; shift 2 ;;
    --evaluator-id) evaluator_id="$2"; shift 2 ;;
    --disposition) disposition="$2"; shift 2 ;;
    --summary) summary="$2"; shift 2 ;;
    --evidence-ref) evidence_refs+=("$2"); shift 2 ;;
    --known-limit) known_limits+=("$2"); shift 2 ;;
    --recorded-at) recorded_at="$2"; shift 2 ;;
    --output) output="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$subject_ref" && -n "$evaluator_id" && -n "$disposition" && -n "$summary" && -n "$output" ]] || {
  echo "missing required fields" >&2
  exit 1
}
[[ "${#evidence_refs[@]}" -gt 0 ]] || {
  echo "at least one --evidence-ref is required" >&2
  exit 1
}
case "$disposition" in
  approved|concerns|blocked|not_required) ;;
  *) echo "invalid disposition: $disposition" >&2; exit 1 ;;
esac

if [[ -z "$recorded_at" ]]; then
  recorded_at="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
fi

mkdir -p "$(dirname "$output")"

evidence_json="$(printf '%s\n' "${evidence_refs[@]}" | jq -R . | jq -s .)"
limits_json="$(printf '%s\n' "${known_limits[@]:-}" | jq -R . | jq -s 'map(select(length > 0))')"

jq -n \
  --arg subject_ref "$subject_ref" \
  --arg evaluator_id "$evaluator_id" \
  --arg disposition "$disposition" \
  --arg summary "$summary" \
  --argjson evidence_refs "$evidence_json" \
  --argjson known_limits "$limits_json" \
  --arg recorded_at "$recorded_at" '
    {
      schema_version: "evaluator-review-v1",
      subject_ref: $subject_ref,
      evaluator_id: $evaluator_id,
      disposition: $disposition,
      summary: $summary,
      evidence_refs: $evidence_refs,
      known_limits: $known_limits,
      recorded_at: $recorded_at
    }
  ' | yq -P -p=json '.' > "$output"

printf '%s\n' "$output"
