#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
REGISTRY_FILE="${DOC_CLASSIFICATION_REGISTRY_FILE:-$OCTON_DIR/framework/cognition/_meta/architecture/contract-registry.yml}"
GITHUB_OUTPUT_FILE=""
READ_STDIN=0

declare -a INPUT_PATHS=()

usage() {
  cat <<'USAGE'
Usage: classify-authoritative-doc-change.sh [--registry <path>] [--github-output <path>] [--stdin] [paths...]

Classify changed files against the machine-readable documentation classes in
contract-registry.yml and emit whether the main-push safety workflow should run.
USAGE
}

trim_path() {
  local path="$1"
  path="${path#./}"
  printf '%s' "$path"
}

class_matches_trigger() {
  local class_id="$1"
  yq -e ".documentation.safety_trigger_classes[] | select(. == \"$class_id\")" "$REGISTRY_FILE" >/dev/null 2>&1
}

classify_markdown_path() {
  local path="$1"
  local class_id pattern

  while IFS= read -r class_id; do
    [[ -n "$class_id" ]] || continue
    while IFS= read -r pattern; do
      [[ -n "$pattern" ]] || continue
      if [[ "$path" == $pattern ]]; then
        printf '%s' "$class_id"
        return 0
      fi
    done < <(yq -r ".documentation.classes[] | select(.id == \"$class_id\") | .match_globs[]?" "$REGISTRY_FILE")
  done < <(yq -r '.documentation.class_precedence[]?' "$REGISTRY_FILE")

  printf 'narrative-doc'
}

write_output() {
  local key="$1"
  local value="$2"
  {
    printf '%s=%s\n' "$key" "$value"
  } >>"$GITHUB_OUTPUT_FILE"
}

write_multiline_output() {
  local key="$1"
  local value="$2"
  {
    printf '%s<<EOF\n' "$key"
    printf '%s\n' "$value"
    printf 'EOF\n'
  } >>"$GITHUB_OUTPUT_FILE"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --registry)
      shift
      REGISTRY_FILE="${1:-}"
      ;;
    --github-output)
      shift
      GITHUB_OUTPUT_FILE="${1:-}"
      ;;
    --stdin)
      READ_STDIN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      INPUT_PATHS+=("$(trim_path "$1")")
      ;;
  esac
  shift
done

if [[ $READ_STDIN -eq 1 ]]; then
  while IFS= read -r path; do
    [[ -n "$path" ]] || continue
    INPUT_PATHS+=("$(trim_path "$path")")
  done
fi

if ! command -v yq >/dev/null 2>&1; then
  echo "[ERROR] yq is required for doc classification" >&2
  exit 1
fi

if [[ ! -f "$REGISTRY_FILE" ]]; then
  echo "[ERROR] missing contract registry: $REGISTRY_FILE" >&2
  exit 1
fi

authoritative_doc_changed=false
operational_guide_changed=false
narrative_doc_changed=false
non_doc_changed=false
should_run=false

classification_lines=""

if [[ "${#INPUT_PATHS[@]}" -eq 0 ]]; then
  classification_lines="no-inputs"
fi

for raw_path in "${INPUT_PATHS[@]}"; do
  path="$(trim_path "$raw_path")"
  [[ -n "$path" ]] || continue

  class_id="non-doc"
  if [[ "$path" == *.md ]]; then
    class_id="$(classify_markdown_path "$path")"
  fi

  case "$class_id" in
    authoritative-doc)
      authoritative_doc_changed=true
      if class_matches_trigger "$class_id"; then
        should_run=true
      fi
      ;;
    operational-guide)
      operational_guide_changed=true
      ;;
    narrative-doc)
      narrative_doc_changed=true
      ;;
    non-doc)
      non_doc_changed=true
      should_run=true
      ;;
    *)
      narrative_doc_changed=true
      ;;
  esac

  if [[ -n "$classification_lines" ]]; then
    classification_lines+=$'\n'
  fi
  classification_lines+="${class_id}"$'\t'"${path}"
done

printf '%s\n' "$classification_lines"

if [[ -n "$GITHUB_OUTPUT_FILE" ]]; then
  write_output "authoritative_doc_changed" "$authoritative_doc_changed"
  write_output "operational_guide_changed" "$operational_guide_changed"
  write_output "narrative_doc_changed" "$narrative_doc_changed"
  write_output "non_doc_changed" "$non_doc_changed"
  write_output "should_run" "$should_run"
  write_multiline_output "classified_paths" "$classification_lines"
fi
