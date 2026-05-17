#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${OCTON_ROOT_DIR:-$(pwd)}"
POLICY_PATH="${1:-.octon/framework/constitution/contracts/authority/authority-zone-policy.yml}"
POLICY="$ROOT_DIR/$POLICY_PATH"

pass_count=0
fail_count=0

pass() {
  pass_count=$((pass_count + 1))
  printf 'PASS: %s\n' "$1"
}

fail() {
  fail_count=$((fail_count + 1))
  printf 'FAIL: %s\n' "$1" >&2
}

valid_zone() {
  case "$1" in
    octon-run-bound|octon-generated-derived|octon-authored-governance|workspace-declared|current-run-agent-artifact|protected-or-external)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

valid_artifact_class() {
  case "$1" in
    run-control|run-evidence|generated-derived|authored-governance|workspace-source|current-run-generated|protected-human-or-external|unknown)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

valid_operation_class() {
  case "$1" in
    inspect|append-run-evidence|update-run-control|refresh-generated-projection|cleanup-current-run-artifact|retry-child-route|execute-child-route|program-recovery-action|closeout-readiness|durable-authority-mutation|protected-artifact-mutation)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

valid_approval_posture() {
  case "$1" in
    pre-granted|approval-required|deny)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

valid_fail_closed_blocker() {
  case "$1" in
    authority-zone-denied|authority-zone-ambiguous|self-authorization-attempt|durable-authority-approval-required|protected-artifact-approval-required|artifact-ownership-unclear)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

main() {
  if [[ ! -f "$POLICY" ]]; then
    fail "authority-zone policy exists: $POLICY_PATH"
    printf '\nPassed: %s\nFailed: %s\n' "$pass_count" "$fail_count"
    return 1
  fi
  pass "authority-zone policy exists: $POLICY_PATH"

  local schema_version zone_count unique_zone_count zone_index zone_id matcher_count artifact_count operation_count posture blocker generated_non_authority consumer_count value

  schema_version="$(yq -r '.schema_version // ""' "$POLICY" 2>/dev/null || true)"
  [[ "$schema_version" == "octon-authority-zone-policy-v1" ]] \
    && pass "authority-zone policy schema version valid" \
    || fail "authority-zone policy schema version invalid"

  yq -e '.zones | tag == "!!seq" and length > 0' "$POLICY" >/dev/null 2>&1 \
    && pass "authority-zone policy zones sequence declared" \
    || fail "authority-zone policy zones sequence missing"

  zone_count="$(yq -r '(.zones // []) | length' "$POLICY" 2>/dev/null || echo 0)"
  unique_zone_count="$(yq -r '(.zones // [] | map(.zone_id) | unique) | length' "$POLICY" 2>/dev/null || echo 0)"
  [[ "$zone_count" == "$unique_zone_count" ]] \
    && pass "authority-zone ids unique" \
    || fail "authority-zone ids must be unique"

  for required_zone in octon-run-bound octon-generated-derived octon-authored-governance workspace-declared current-run-agent-artifact protected-or-external; do
    yq -e ".zones[]? | select(.zone_id == \"$required_zone\")" "$POLICY" >/dev/null 2>&1 \
      && pass "required authority zone declared: $required_zone" \
      || fail "required authority zone missing: $required_zone"
  done

  for ((zone_index=0; zone_index<zone_count; zone_index++)); do
    zone_id="$(yq -r ".zones[$zone_index].zone_id // \"\"" "$POLICY" 2>/dev/null || true)"
    valid_zone "$zone_id" \
      && pass "authority zone id valid: $zone_id" \
      || fail "authority zone id invalid: $zone_id"

    yq -e ".zones[$zone_index].path_matchers | tag == \"!!seq\" and length > 0" "$POLICY" >/dev/null 2>&1 \
      && pass "authority zone path matchers declared: $zone_id" \
      || fail "authority zone path matchers missing: $zone_id"
    matcher_count="$(yq -r "(.zones[$zone_index].path_matchers // []) | length" "$POLICY" 2>/dev/null || echo 0)"
    for ((index=0; index<matcher_count; index++)); do
      value="$(yq -r ".zones[$zone_index].path_matchers[$index] // \"\"" "$POLICY" 2>/dev/null || true)"
      [[ -n "$value" && "$value" != "null" ]] \
        && pass "authority zone path matcher non-empty: $zone_id -> $value" \
        || fail "authority zone path matcher empty: $zone_id"
    done

    yq -e ".zones[$zone_index].artifact_classes | tag == \"!!seq\" and length > 0" "$POLICY" >/dev/null 2>&1 \
      && pass "authority zone artifact classes declared: $zone_id" \
      || fail "authority zone artifact classes missing: $zone_id"
    artifact_count="$(yq -r "(.zones[$zone_index].artifact_classes // []) | length" "$POLICY" 2>/dev/null || echo 0)"
    for ((index=0; index<artifact_count; index++)); do
      value="$(yq -r ".zones[$zone_index].artifact_classes[$index] // \"\"" "$POLICY" 2>/dev/null || true)"
      valid_artifact_class "$value" \
        && pass "authority zone artifact class valid: $zone_id -> $value" \
        || fail "authority zone artifact class invalid: $zone_id -> $value"
    done

    yq -e ".zones[$zone_index].allowed_operation_classes | tag == \"!!seq\" and length > 0" "$POLICY" >/dev/null 2>&1 \
      && pass "authority zone operation classes declared: $zone_id" \
      || fail "authority zone operation classes missing: $zone_id"
    operation_count="$(yq -r "(.zones[$zone_index].allowed_operation_classes // []) | length" "$POLICY" 2>/dev/null || echo 0)"
    for ((index=0; index<operation_count; index++)); do
      value="$(yq -r ".zones[$zone_index].allowed_operation_classes[$index] // \"\"" "$POLICY" 2>/dev/null || true)"
      valid_operation_class "$value" \
        && pass "authority zone operation class valid: $zone_id -> $value" \
        || fail "authority zone operation class invalid: $zone_id -> $value"
      if [[ "$zone_id" == "protected-or-external" && "$value" != "inspect" ]]; then
        fail "protected-or-external zone must not predeclare mutation operation: $value"
      fi
      if [[ "$zone_id" == "octon-authored-governance" && "$value" != "inspect" ]]; then
        fail "authored governance zone must not predeclare mutation operation: $value"
      fi
    done

    posture="$(yq -r ".zones[$zone_index].approval_posture // \"\"" "$POLICY" 2>/dev/null || true)"
    valid_approval_posture "$posture" \
      && pass "authority zone approval posture valid: $zone_id -> $posture" \
      || fail "authority zone approval posture invalid: $zone_id -> $posture"
    if [[ ( "$zone_id" == "octon-authored-governance" || "$zone_id" == "protected-or-external" ) && "$posture" == "pre-granted" ]]; then
      fail "durable/protected authority zone must not be pre-granted: $zone_id"
    fi

    blocker="$(yq -r ".zones[$zone_index].fail_closed_blocker // \"\"" "$POLICY" 2>/dev/null || true)"
    valid_fail_closed_blocker "$blocker" \
      && pass "authority zone fail-closed blocker valid: $zone_id -> $blocker" \
      || fail "authority zone fail-closed blocker invalid: $zone_id -> $blocker"

    value="$(yq -r ".zones[$zone_index].evidence_requirement // \"\"" "$POLICY" 2>/dev/null || true)"
    [[ -n "$value" && "$value" != "null" ]] \
      && pass "authority zone evidence requirement declared: $zone_id" \
      || fail "authority zone evidence requirement missing: $zone_id"

    generated_non_authority="$(yq -r ".zones[$zone_index].generated_non_authority // false" "$POLICY" 2>/dev/null || true)"
    if [[ "$zone_id" == "octon-generated-derived" ]]; then
      [[ "$generated_non_authority" == "true" ]] \
        && pass "generated-derived zone declares non-authority" \
        || fail "generated-derived zone must declare generated_non_authority"
      consumer_count="$(yq -r "(.zones[$zone_index].forbidden_authority_consumers // []) | length" "$POLICY" 2>/dev/null || echo 0)"
      [[ "$consumer_count" =~ ^[0-9]+$ && "$consumer_count" -gt 0 ]] \
        && pass "generated-derived zone declares forbidden authority consumers" \
        || fail "generated-derived zone must declare forbidden authority consumers"
    fi
  done

  yq -e '.self_authorization_policy.fail_closed_blocker == "self-authorization-attempt"' "$POLICY" >/dev/null 2>&1 \
    && pass "self-authorization fail-closed blocker declared" \
    || fail "self-authorization fail-closed blocker missing"
  yq -e '.self_authorization_policy.same_segment_authority_widening_denied == true' "$POLICY" >/dev/null 2>&1 \
    && pass "same-segment authority widening denied" \
    || fail "same-segment authority widening must be denied"

  printf '\nPassed: %s\nFailed: %s\n' "$pass_count" "$fail_count"
  [[ "$fail_count" -eq 0 ]]
}

main "$@"
