#!/usr/bin/env bash
# validate-ra-acp-migration.sh - Regression guard for RA + ACP clean-break migration.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAPABILITIES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$CAPABILITIES_DIR/../.." && pwd)"

POLICY_FILE="$CAPABILITIES_DIR/_ops/policy/deny-by-default.v2.yml"
TAXONOMY_FILE="$CAPABILITIES_DIR/_ops/policy/acp-operation-classes.md"
ENFORCER_FILE="$CAPABILITIES_DIR/services/_ops/scripts/enforce-deny-by-default.sh"
AGENT_FILE="$CAPABILITIES_DIR/services/execution/agent/impl/agent.sh"
RECEIPT_WRITER="$CAPABILITIES_DIR/_ops/scripts/policy-receipt-write.sh"

FAIL_COUNT=0

fail() {
  local msg="$1"
  echo "RA+ACP migration check failed: $msg" >&2
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

check_required_files() {
  local file
  for file in "$POLICY_FILE" "$TAXONOMY_FILE" "$ENFORCER_FILE" "$AGENT_FILE" "$RECEIPT_WRITER"; do
    [[ -f "$file" ]] || fail "missing required file: $file"
  done
}

check_hitl_doc_removed() {
  local old_doc="$REPO_ROOT/.harmony/cognition/principles/hitl-checkpoints.md"
  if [[ -f "$old_doc" ]]; then
    fail "legacy hitl-checkpoints.md still exists"
  fi
}

check_policy_sections() {
  local section
  for section in acp reversibility budgets quorum attestations circuit_breakers receipts; do
    if ! rg -n "^${section}:" "$POLICY_FILE" >/dev/null; then
      fail "policy missing top-level section '${section}'"
    fi
  done
}

collect_policy_classes() {
  awk '
    /^[[:space:]]+class:[[:space:]]*[a-zA-Z0-9._-]+/ {
      value=$2
      gsub(/["'\'' ,]/, "", value)
      print value
    }
  ' "$POLICY_FILE" | sort -u
}

collect_taxonomy_classes() {
  sed -n 's/^- `\([a-zA-Z0-9._-]*\)` — .*/\1/p' "$TAXONOMY_FILE" | sort -u
}

check_taxonomy_alignment() {
  local policy_classes taxonomy_classes policy_only taxonomy_only
  policy_classes="$(collect_policy_classes)"
  taxonomy_classes="$(collect_taxonomy_classes)"

  policy_only="$(comm -23 <(printf '%s\n' "$policy_classes") <(printf '%s\n' "$taxonomy_classes"))"
  taxonomy_only="$(comm -13 <(printf '%s\n' "$policy_classes") <(printf '%s\n' "$taxonomy_classes"))"

  if [[ -n "$policy_only" ]]; then
    fail "policy classes missing from taxonomy: $(tr '\n' ',' <<<"$policy_only" | sed 's/,$//')"
  fi
  if [[ -n "$taxonomy_only" ]]; then
    fail "taxonomy classes missing from policy: $(tr '\n' ',' <<<"$taxonomy_only" | sed 's/,$//')"
  fi
}

extract_wrapper_defaults() {
  {
    sed -n 's/.*HARMONY_OPERATION_CLASS:-\([^}]*\)}.*/\1/p' "$ENFORCER_FILE"
    sed -n 's/.*HARMONY_OPERATION_CLASS:-\([^}]*\)}.*/\1/p' "$AGENT_FILE"
  } | sed '/^[[:space:]]*$/d' | sort -u
}

check_wrapper_defaults_mapped() {
  local classes defaults default_class
  classes="$(collect_policy_classes)"
  defaults="$(extract_wrapper_defaults)"
  while IFS= read -r default_class; do
    [[ -n "$default_class" ]] || continue
    if ! grep -qx "$default_class" <<<"$classes"; then
      fail "wrapper default operation class '$default_class' is not mapped in policy"
    fi
  done <<<"$defaults"
}

check_receipt_writer_append_only() {
  if rg -n '>[[:space:]]*"\$receipt_path"|>[[:space:]]*"\$digest_path"' "$RECEIPT_WRITER" >/dev/null; then
    fail "receipt writer overwrites compatibility paths instead of preserving immutable history"
  fi
}

check_human_gate_language() {
  local -a critical_docs=(
    "$CAPABILITIES_DIR/services/_meta/docs/platform-overview.md"
    "$REPO_ROOT/.harmony/cognition/_meta/architecture/governance-model.md"
    "$REPO_ROOT/.harmony/cognition/context/glossary-repo.md"
    "$CAPABILITIES_DIR/services/execution/service-roles.md"
    "$REPO_ROOT/.harmony/cognition/methodology/README.md"
    "$REPO_ROOT/.harmony/capabilities/_meta/architecture/declaration.md"
    "$REPO_ROOT/.harmony/capabilities/_meta/architecture/design-conventions.md"
    "$REPO_ROOT/.harmony/capabilities/_meta/architecture/skill-sets.md"
    "$REPO_ROOT/.harmony/capabilities/skills/_scaffold/template/SKILL.md"
    "$REPO_ROOT/.harmony/continuity/_meta/architecture/three-planes-integration.md"
  )
  local doc
  for doc in "${critical_docs[@]}"; do
    [[ -f "$doc" ]] || continue
    if rg -n -i 'human checkpoint|human approval|HITL' "$doc" >/dev/null; then
      fail "stale human-gate language remains in $doc"
    fi
  done
}

main() {
  check_required_files
  check_hitl_doc_removed
  check_policy_sections
  check_taxonomy_alignment
  check_wrapper_defaults_mapped
  check_receipt_writer_append_only
  check_human_gate_language

  if (( FAIL_COUNT > 0 )); then
    echo "RA+ACP migration regression checks failed ($FAIL_COUNT)." >&2
    exit 1
  fi

  echo "RA+ACP migration regression checks passed."
}

main "$@"
