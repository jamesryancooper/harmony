#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"

ROUTE_LOCK="$OCTON_DIR/generated/effective/runtime/route-bundle.lock.yml"
PACK_LOCK="$OCTON_DIR/generated/effective/capabilities/pack-routes.lock.yml"

errors=0
fail() { echo "[ERROR] $1"; errors=$((errors + 1)); }
pass() { echo "[OK] $1"; }

check_mode() {
  local file="$1" label="$2"
  case "$(yq -r '.freshness.mode // ""' "$file")" in
    digest_bound|ttl_bound|receipt_bound) pass "$label freshness mode valid" ;;
    *) fail "$label freshness mode invalid" ;;
  esac
}

check_common_handle_fields() {
  local file="$1" label="$2"
  yq -e '.allowed_consumers[] | select(. == "runtime_resolver")' "$file" >/dev/null 2>&1 \
    && pass "$label allows runtime_resolver" \
    || fail "$label must allow runtime_resolver"
  yq -e '.forbidden_consumers[] | select(. == "direct_runtime_raw_path_read")' "$file" >/dev/null 2>&1 \
    && pass "$label forbids raw runtime reads" \
    || fail "$label must forbid raw runtime reads"
  [[ "$(yq -r '.non_authority_classification // ""' "$file")" == "derived-runtime-handle" ]] \
    && pass "$label non-authority classification valid" \
    || fail "$label non-authority classification invalid"
}

echo "== Runtime Effective Artifact Handles Validation =="

[[ -f "$ROUTE_LOCK" ]] && pass "runtime route lock present" || fail "missing runtime route lock"
[[ -f "$PACK_LOCK" ]] && pass "pack routes lock present" || fail "missing pack routes lock"

if [[ -f "$ROUTE_LOCK" ]]; then
  [[ "$(yq -r '.schema_version // ""' "$ROUTE_LOCK")" == "octon-runtime-effective-route-bundle-lock-v2" ]] \
    && pass "runtime route lock schema valid" \
    || fail "runtime route lock schema invalid"
  check_mode "$ROUTE_LOCK" "runtime route lock"
  check_common_handle_fields "$ROUTE_LOCK" "runtime route lock"
  yq -e '.source_digests.root_manifest_sha256' "$ROUTE_LOCK" >/dev/null 2>&1 \
    && pass "runtime route lock records root manifest digest" \
    || fail "runtime route lock missing root manifest digest"
  yq -e '.source_digests.extensions_catalog_sha256' "$ROUTE_LOCK" >/dev/null 2>&1 \
    && pass "runtime route lock records extensions catalog digest" \
    || fail "runtime route lock missing extensions catalog digest"
  yq -e '.source_digests.support_target_matrix_sha256' "$ROUTE_LOCK" >/dev/null 2>&1 \
    && pass "runtime route lock records support target matrix digest" \
    || fail "runtime route lock missing support target matrix digest"
fi

if [[ -f "$PACK_LOCK" ]]; then
  check_mode "$PACK_LOCK" "pack routes lock"
  check_common_handle_fields "$PACK_LOCK" "pack routes lock"
  yq -e '.root_manifest_sha256' "$PACK_LOCK" >/dev/null 2>&1 \
    && pass "pack routes lock records root manifest digest" \
    || fail "pack routes lock missing root manifest digest"
fi

echo "Validation summary: errors=$errors"
[[ $errors -eq 0 ]]
