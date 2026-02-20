#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../../.." && pwd)"
cd "$ROOT_DIR"

PRINCIPLES_DIR="${PRINCIPLES_DIR_OVERRIDE:-.harmony/cognition/principles}"
REFERENCE_LINT="${REFERENCE_LINT_OVERRIDE:-.harmony/cognition/principles/_ops/scripts/reference-lint.sh}"

declare -i failures=0

if [[ ! -d "$PRINCIPLES_DIR" ]]; then
  echo "[missing-dir] principles directory not found: $PRINCIPLES_DIR"
  exit 1
fi

check_forbidden_terms() {
  local file=""
  local line=""
  local pattern=""

  local -a forbidden=(
    '\bHITL\b'
    'hard checkpoint'
    'must approve'
    'authorization checkpoint'
    'hitl-checkpoints\.md'
  )

  while IFS= read -r file; do
    for pattern in "${forbidden[@]}"; do
      while IFS= read -r line; do
        if [[ "$line" =~ [Dd]eprecated || "$line" =~ [Nn]o[[:space:]]+longer || "$line" =~ [Rr]emoved ]]; then
          continue
        fi
        echo "[forbidden-term] $file: $line"
        failures+=1
      done < <(rg -n -i "$pattern" "$file" || true)
    done
  done < <(find "$PRINCIPLES_DIR" -type f -name '*.md' | sort)
}

check_pr_only_runtime_gating() {
  local raw_hits filtered_hits

  raw_hits="$(rg -n -i '\b(must|required|requires)\b[^\n]{0,120}\bPR\b' "$PRINCIPLES_DIR" --glob '*.md' || true)"

  filtered_hits="$(printf '%s\n' "$raw_hits" | rg -i -v 'if a PR exists|projection|receipt|acp|promot|guidance' || true)"
  if [[ -n "$filtered_hits" ]]; then
    echo "[pr-only-gating] Found PR-only normative language without ACP/receipt equivalence:"
    printf '%s\n' "$filtered_hits"
    failures+=1
  fi
}

check_human_approval_runtime_dependency() {
  local pattern negation_pattern raw_hits hits

  pattern='require[sd]?(ing)?[^[:cntrl:]\n]{0,80}human approval|must[^[:cntrl:]\n]{0,80}be[^[:cntrl:]\n]{0,40}approved[^[:cntrl:]\n]{0,40}by[^[:cntrl:]\n]{0,20}human|block[^[:cntrl:]\n]{0,80}until[^[:cntrl:]\n]{0,40}approved'
  negation_pattern='does not require[^[:cntrl:]\n]{0,80}human approval|do not require[^[:cntrl:]\n]{0,80}human approval|not[^[:cntrl:]\n]{0,40}human approval|no[^[:cntrl:]\n]{0,40}human[^[:cntrl:]\n]{0,20}approval|not[^[:cntrl:]\n]{0,40}default runtime gate|optional review'

  raw_hits="$(rg -n -i "$pattern" "$PRINCIPLES_DIR" --glob '*.md' || true)"
  hits="$(printf '%s\n' "$raw_hits" | rg -i -v "$negation_pattern" || true)"
  if [[ -n "$hits" ]]; then
    echo "[runtime-human-gate] Found runtime dependency on human approval language:"
    printf '%s\n' "$hits"
    failures+=1
  fi
}

check_canonical_matrix_links() {
  local file count
  local -a required=(
    "$PRINCIPLES_DIR/autonomous-control-points.md"
    "$PRINCIPLES_DIR/documentation-is-code.md"
    "$PRINCIPLES_DIR/observability-as-a-contract.md"
    "$PRINCIPLES_DIR/contract-first.md"
  )

  for file in "${required[@]}"; do
    if [[ ! -f "$file" ]]; then
      echo "[canonical-matrix] missing required principle file: $file"
      failures+=1
      continue
    fi
    count="$(rg -c 'ra-acp-promotion-inputs-matrix\.md' "$file" || true)"
    if [[ "$count" -ne 1 ]]; then
      echo "[canonical-matrix] $file must include exactly one matrix link; found $count"
      failures+=1
    fi
  done
}

check_canonical_glossary_links() {
  local file count
  local -a required=(
    "$PRINCIPLES_DIR/autonomous-control-points.md"
    "$PRINCIPLES_DIR/deny-by-default.md"
    "$PRINCIPLES_DIR/documentation-is-code.md"
    "$PRINCIPLES_DIR/observability-as-a-contract.md"
    "$PRINCIPLES_DIR/contract-first.md"
    "$PRINCIPLES_DIR/no-silent-apply.md"
    "$PRINCIPLES_DIR/ownership-and-boundaries.md"
    "$PRINCIPLES_DIR/determinism.md"
    "$PRINCIPLES_DIR/determinism-and-provenance.md"
  )

  for file in "${required[@]}"; do
    if [[ ! -f "$file" ]]; then
      echo "[canonical-glossary] missing required principle file: $file"
      failures+=1
      continue
    fi
    count="$(rg -c 'ra-acp-glossary\.md' "$file" || true)"
    if [[ "$count" -lt 1 ]]; then
      echo "[canonical-glossary] $file must reference RA/ACP glossary."
      failures+=1
    fi
  done
}

check_risk_mapping_reference() {
  local file
  local -a required=(
    "$PRINCIPLES_DIR/autonomous-control-points.md"
    "$PRINCIPLES_DIR/observability-as-a-contract.md"
  )

  for file in "${required[@]}"; do
    if [[ ! -f "$file" ]]; then
      echo "[risk-mapping] missing required principle file: $file"
      failures+=1
      continue
    fi
    if ! rg -q 'acp\.risk_tier_mapping|risk tier to ACP mapping is policy-canonical' "$file"; then
      echo "[risk-mapping] $file must reference policy-canonical risk tier mapping."
      failures+=1
    fi
  done

  local redeclared
  redeclared="$(rg -n '\|[[:space:]]*Risk tier[[:space:]]*\|[[:space:]]*ACP level[[:space:]]*\|' "$PRINCIPLES_DIR" --glob '*.md' --glob '!**/_meta/ra-acp-promotion-inputs-matrix.md' || true)"
  if [[ -n "$redeclared" ]]; then
    echo "[risk-mapping] Risk tier to ACP table is re-declared outside canonical matrix:"
    printf '%s\n' "$redeclared"
    failures+=1
  fi
}

if [[ ! -x "$REFERENCE_LINT" ]]; then
  echo "[missing-script] reference lint script is missing or not executable: $REFERENCE_LINT"
  failures+=1
else
  if ! PRINCIPLES_DIR_OVERRIDE="$PRINCIPLES_DIR" "$REFERENCE_LINT"; then
    failures+=1
  fi
fi

check_canonical_matrix_links
check_canonical_glossary_links
check_risk_mapping_reference
check_forbidden_terms
check_pr_only_runtime_gating
check_human_approval_runtime_dependency

if [[ "$failures" -gt 0 ]]; then
  echo "Principles governance lint failed with $failures issue(s)."
  exit 1
fi

echo "Principles governance lint passed."
