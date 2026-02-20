#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../../.." && pwd)"
cd "$ROOT_DIR"

evaluate_docs_gate() {
  local has_spec="$1"
  local has_adr="$2"
  local has_runbook="$3"

  local decision="ALLOW"
  local reason_code="NONE"
  local receipt_required="true"
  local missing="[]"

  if [[ "$has_spec" != "true" || "$has_adr" != "true" || "$has_runbook" != "true" ]]; then
    decision="STAGE_ONLY"
    reason_code="DOCS_ARTIFACTS_MISSING"
    missing='["spec","adr","runbook"]'

    if [[ "${STRICT_DOCS_PROMOTION:-0}" == "1" ]]; then
      decision="DENY"
    fi
  fi

  printf '{"decision":"%s","reason_code":"%s","receipt_required":%s,"missing_artifacts":%s}\n' \
    "$decision" "$reason_code" "$receipt_required" "$missing"
}

assert_pattern() {
  local value="$1"
  local pattern="$2"
  local label="$3"

  if ! printf '%s' "$value" | rg -q "$pattern"; then
    echo "[fail] $label"
    echo "value: $value"
    exit 1
  fi
}

stage_only_result="$(evaluate_docs_gate true false true)"
assert_pattern "$stage_only_result" '"decision":"STAGE_ONLY"' 'missing docs should stage-only by default'
assert_pattern "$stage_only_result" '"reason_code":"DOCS_ARTIFACTS_MISSING"' 'missing docs should emit reason code'
assert_pattern "$stage_only_result" '"receipt_required":true' 'missing docs should still require receipt'

strict_result="$(STRICT_DOCS_PROMOTION=1 evaluate_docs_gate true false true)"
assert_pattern "$strict_result" '"decision":"DENY"' 'strict mode should deny on missing docs'
assert_pattern "$strict_result" '"reason_code":"DOCS_ARTIFACTS_MISSING"' 'strict mode should emit reason code'

allow_result="$(evaluate_docs_gate true true true)"
assert_pattern "$allow_result" '"decision":"ALLOW"' 'complete docs should allow promotion'

echo "Documentation promotion fail-closed contract test passed."
