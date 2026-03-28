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

card_id=""
claim_kind=""
claim_summary=""
support_target_ref=""
host_adapter="repo-shell"
model_adapter="repo-local-governed"
host_support_status=""
model_support_status=""
model_tier=""
workload_tier=""
language_resource_tier=""
locale_tier=""
support_status=""
generated_at=""
yaml_output=""
markdown_output=""
evaluator_review_ref=""
proof_bundle_refs=()
known_limits=()
conformance_criteria=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --card-id) card_id="$2"; shift 2 ;;
    --claim-kind) claim_kind="$2"; shift 2 ;;
    --claim-summary) claim_summary="$2"; shift 2 ;;
    --support-target-ref) support_target_ref="$2"; shift 2 ;;
    --host-adapter) host_adapter="$2"; shift 2 ;;
    --model-adapter) model_adapter="$2"; shift 2 ;;
    --host-support-status) host_support_status="$2"; shift 2 ;;
    --model-support-status) model_support_status="$2"; shift 2 ;;
    --model-tier) model_tier="$2"; shift 2 ;;
    --workload-tier) workload_tier="$2"; shift 2 ;;
    --language-resource-tier) language_resource_tier="$2"; shift 2 ;;
    --locale-tier) locale_tier="$2"; shift 2 ;;
    --support-status) support_status="$2"; shift 2 ;;
    --proof-bundle-ref) proof_bundle_refs+=("$2"); shift 2 ;;
    --conformance-criterion) conformance_criteria+=("$2"); shift 2 ;;
    --known-limit) known_limits+=("$2"); shift 2 ;;
    --evaluator-review-ref) evaluator_review_ref="$2"; shift 2 ;;
    --generated-at) generated_at="$2"; shift 2 ;;
    --yaml-output) yaml_output="$2"; shift 2 ;;
    --markdown-output) markdown_output="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$card_id" && -n "$claim_kind" && -n "$claim_summary" && -n "$support_target_ref" && -n "$model_tier" && -n "$workload_tier" && -n "$language_resource_tier" && -n "$locale_tier" && -n "$support_status" && -n "$yaml_output" ]] || {
  echo "missing required fields" >&2
  exit 1
}
[[ "${#proof_bundle_refs[@]}" -gt 0 ]] || {
  echo "at least one --proof-bundle-ref is required" >&2
  exit 1
}
case "$claim_kind" in
  support|benchmark|release) ;;
  *) echo "invalid claim kind: $claim_kind" >&2; exit 1 ;;
esac
case "$support_status" in
  supported|reduced|experimental|unsupported) ;;
  *) echo "invalid support status: $support_status" >&2; exit 1 ;;
esac
if [[ -z "$host_support_status" ]]; then
  host_support_status="supported"
fi
if [[ -z "$model_support_status" ]]; then
  model_support_status="supported"
fi
case "$host_support_status" in
  supported|reduced|experimental|unsupported) ;;
  *) echo "invalid host support status: $host_support_status" >&2; exit 1 ;;
esac
case "$model_support_status" in
  supported|reduced|experimental|unsupported) ;;
  *) echo "invalid model support status: $model_support_status" >&2; exit 1 ;;
esac
if [[ "${#conformance_criteria[@]}" -eq 0 ]]; then
  conformance_criteria=("HOST-001" "HOST-002" "MODEL-001" "MODEL-002" "MODEL-003")
fi

if [[ -z "$generated_at" ]]; then
  generated_at="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
fi

mkdir -p "$(dirname "$yaml_output")"
if [[ -n "$markdown_output" ]]; then
  mkdir -p "$(dirname "$markdown_output")"
fi

proof_bundle_json="$(printf '%s\n' "${proof_bundle_refs[@]}" | jq -R . | jq -s .)"
known_limits_json="$(printf '%s\n' "${known_limits[@]:-}" | jq -R . | jq -s 'map(select(length > 0))')"
conformance_json="$(printf '%s\n' "${conformance_criteria[@]}" | jq -R . | jq -s 'map(select(length > 0))')"

jq -n \
  --arg card_id "$card_id" \
  --arg claim_kind "$claim_kind" \
  --arg claim_summary "$claim_summary" \
  --arg support_target_ref "$support_target_ref" \
  --arg host_adapter "$host_adapter" \
  --arg model_adapter "$model_adapter" \
  --arg host_support_status "$host_support_status" \
  --arg model_support_status "$model_support_status" \
  --arg model_tier "$model_tier" \
  --arg workload_tier "$workload_tier" \
  --arg language_resource_tier "$language_resource_tier" \
  --arg locale_tier "$locale_tier" \
  --arg support_status "$support_status" \
  --arg evaluator_review_ref "$evaluator_review_ref" \
  --argjson proof_bundle_refs "$proof_bundle_json" \
  --argjson conformance_criteria "$conformance_json" \
  --argjson known_limits "$known_limits_json" \
  --arg generated_at "$generated_at" '
    {
      schema_version: "harness-card-v1",
      card_id: $card_id,
      claim_kind: $claim_kind,
      claim_summary: $claim_summary,
      support_target_ref: $support_target_ref,
      compatibility_tuple: {
        model_tier: $model_tier,
        workload_tier: $workload_tier,
        language_resource_tier: $language_resource_tier,
        locale_tier: $locale_tier,
        support_status: $support_status
      },
      adapter_support: {
        host_adapter: $host_adapter,
        model_adapter: $model_adapter,
        host_support_status: $host_support_status,
        model_support_status: $model_support_status,
        conformance_criteria: $conformance_criteria
      },
      proof_bundle_refs: $proof_bundle_refs,
      known_limits: $known_limits,
      generated_at: $generated_at
    }
    + (if $evaluator_review_ref != "" then {evaluator_review_ref: $evaluator_review_ref} else {} end)
  ' | yq -P -p=json '.' > "$yaml_output"

if [[ -n "$markdown_output" ]]; then
  {
    printf '# HarnessCard: %s\n\n' "$card_id"
    printf -- '- Claim kind: %s\n' "$claim_kind"
    printf -- '- Claim: %s\n' "$claim_summary"
    printf -- '- Support target ref: %s\n' "$support_target_ref"
    printf -- '- Compatibility tuple: %s / %s / %s / %s / %s\n' "$model_tier" "$workload_tier" "$language_resource_tier" "$locale_tier" "$support_status"
    printf -- '- Adapter support: %s (%s) / %s (%s)\n' "$host_adapter" "$host_support_status" "$model_adapter" "$model_support_status"
    printf -- '- Conformance criteria: %s\n' "$(printf '%s\n' "${conformance_criteria[@]}" | paste -sd ', ' -)"
    printf -- '- Proof bundle refs:\n'
    printf '%s\n' "${proof_bundle_refs[@]}" | sed 's/^/  - /'
    if [[ -n "$evaluator_review_ref" ]]; then
      printf -- '- Evaluator review ref: %s\n' "$evaluator_review_ref"
    fi
    if [[ "${#known_limits[@]}" -gt 0 ]]; then
      printf -- '- Known limits:\n'
      printf '%s\n' "${known_limits[@]}" | sed 's/^/  - /'
    fi
    printf -- '- Generated at: %s\n' "$generated_at"
  } > "$markdown_output"
fi

printf '%s\n' "$yaml_output"
