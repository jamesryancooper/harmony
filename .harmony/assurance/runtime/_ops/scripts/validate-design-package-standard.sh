#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ASSURANCE_DIR="$(cd -- "$SCRIPT_DIR/../../.." && pwd)"
HARMONY_DIR="$(cd -- "$ASSURANCE_DIR/.." && pwd)"
ROOT_DIR="$(cd -- "$HARMONY_DIR/.." && pwd)"

PACKAGE_PATH=""
SCAN_ALL=0
errors=0
warnings=0
declare -a VALIDATED_PACKAGE_DIRS=()

fail() {
  echo "[ERROR] $1"
  errors=$((errors + 1))
}

warn() {
  echo "[WARN] $1"
  warnings=$((warnings + 1))
}

pass() {
  echo "[OK] $1"
}

usage() {
  cat <<'EOF'
usage:
  validate-design-package-standard.sh --package <path>
  validate-design-package-standard.sh --all-standard-packages
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --package)
      shift
      [[ $# -gt 0 ]] || { usage >&2; exit 2; }
      PACKAGE_PATH="$1"
      ;;
    --all-standard-packages)
      SCAN_ALL=1
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ -n "$PACKAGE_PATH" && "$SCAN_ALL" -eq 1 ]]; then
  usage >&2
  exit 2
fi

if [[ -z "$PACKAGE_PATH" && "$SCAN_ALL" -ne 1 ]]; then
  usage >&2
  exit 2
fi

resolve_package_dir() {
  local raw="$1"
  local candidate
  if [[ "$raw" = /* ]]; then
    candidate="$raw"
  else
    candidate="$ROOT_DIR/$raw"
  fi
  if [[ -f "$candidate" ]]; then
    candidate="$(dirname "$candidate")"
  fi
  if [[ ! -d "$candidate" ]]; then
    fail "package path not found: ${candidate#$ROOT_DIR/}"
    return 1
  fi
  (
    cd "$candidate"
    pwd
  )
}

rel_path() {
  local path="$1"
  if [[ "$path" == "$ROOT_DIR" ]]; then
    printf '.\n'
  else
    printf '%s\n' "${path#$ROOT_DIR/}"
  fi
}

yaml_string() {
  local file="$1"
  local query="$2"
  yq -r "$query // \"\"" "$file"
}

has_key() {
  local file="$1"
  local key="$2"
  yq -e "has(\"$key\")" "$file" >/dev/null 2>&1
}

check_file() {
  local file="$1"
  local label="$2"
  if [[ -f "$file" ]]; then
    pass "$label"
  else
    fail "$label"
  fi
}

check_dir() {
  local dir="$1"
  local label="$2"
  if [[ -d "$dir" ]]; then
    pass "$label"
  else
    fail "$label"
  fi
}

validate_enum() {
  local value="$1"
  local label="$2"
  shift 2
  local allowed
  for allowed in "$@"; do
    if [[ "$value" == "$allowed" ]]; then
      pass "$label"
      return 0
    fi
  done
  fail "$label"
  return 1
}

check_contains() {
  local file="$1"
  local needle="$2"
  local label="$3"
  if grep -Fq -- "$needle" "$file"; then
    pass "$label"
  else
    fail "$label"
  fi
}

check_absent() {
  local file="$1"
  local needle="$2"
  local label="$3"
  if grep -Fq -- "$needle" "$file"; then
    fail "$label"
  else
    pass "$label"
  fi
}

run_nested_validator() {
  local label="$1"
  local validator_rel="$2"
  local package_rel="$3"
  local validator_abs output rc=0

  validator_abs="$ROOT_DIR/$validator_rel"
  if [[ ! -f "$validator_abs" ]]; then
    fail "$label target missing: $validator_rel"
    return 1
  fi

  if [[ "$validator_abs" == "$SCRIPT_DIR/validate-design-package-standard.sh" ]]; then
    fail "$label must not reference the general validator itself"
    return 1
  fi

  if [[ "$validator_abs" == *.py ]]; then
    output="$(python3 "$validator_abs" "$package_rel" 2>&1)" || rc=$?
  else
    output="$(bash "$validator_abs" "$package_rel" 2>&1)" || rc=$?
  fi

  if [[ "$rc" -eq 0 ]]; then
    pass "$label passed: $validator_rel"
  else
    fail "$label failed: $validator_rel"
    printf '%s\n' "$output"
  fi
}

validate_selected_modules() {
  local manifest="$1"
  local package_label="$2"
  local -a modules=()
  local module
  declare -A seen=()

  mapfile -t modules < <(yq -r '.selected_modules[]?' "$manifest")
  for module in "${modules[@]}"; do
    case "$module" in
      contracts|conformance|reference|history|canonicalization)
        ;;
      *)
        fail "$package_label has unsupported selected_modules entry '$module'"
        continue
        ;;
    esac
    if [[ -n "${seen[$module]:-}" ]]; then
      fail "$package_label repeats selected_modules entry '$module'"
    else
      seen["$module"]=1
    fi
  done
}

module_selected() {
  local manifest="$1"
  local module="$2"
  yq -e ".selected_modules[] | select(. == \"$module\")" "$manifest" >/dev/null 2>&1
}

validate_date_string() {
  local value="$1"
  local label="$2"
  if [[ "$value" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    pass "$label"
  else
    fail "$label"
  fi
}

validate_promotion_evidence() {
  local manifest="$1"
  local package_label="$2"
  local require_nonempty="$3"
  local -a evidence_paths=()
  local evidence_rel evidence_abs

  mapfile -t evidence_paths < <(yq -r '.archive.promotion_evidence[]?' "$manifest")

  if [[ "$require_nonempty" -eq 1 ]] && [[ "${#evidence_paths[@]}" -eq 0 ]]; then
    fail "$package_label implemented archive requires promotion evidence"
    return 0
  fi

  if [[ "${#evidence_paths[@]}" -gt 0 ]]; then
    pass "$package_label promotion evidence declared"
  fi

  for evidence_rel in "${evidence_paths[@]}"; do
    evidence_abs="$ROOT_DIR/$evidence_rel"
    if [[ -e "$evidence_abs" ]]; then
      pass "$package_label promotion evidence exists: $evidence_rel"
    else
      fail "$package_label promotion evidence exists: $evidence_rel"
    fi
  done
}

validate_implementation_targets() {
  local manifest="$1"
  local package_label="$2"
  local package_id="$3"
  local require_existing="$4"
  local target_rel target_abs matches found needle

  while IFS= read -r target_rel; do
    [[ -n "$target_rel" ]] || continue

    if [[ "$target_rel" == .design-packages/* ]]; then
      fail "$package_label implementation target must point outside .design-packages/: $target_rel"
      continue
    fi

    target_abs="$ROOT_DIR/$target_rel"
    if [[ ! -e "$target_abs" ]]; then
      if [[ "$require_existing" -eq 1 ]]; then
        fail "$package_label implementation target must exist for implemented archive: $target_rel"
      else
        warn "$package_label implementation target not present yet: $target_rel"
      fi
      continue
    fi

    matches=""
    for needle in ".design-packages/$package_id" ".design-packages/.archive/$package_id"; do
      found="$(grep -R -n -F -- "$needle" "$target_abs" 2>/dev/null || true)"
      if [[ -n "$found" ]]; then
        matches+="$found"$'\n'
      fi
    done
    if [[ -n "$matches" ]]; then
      fail "$package_label implementation target retains temporary package dependency: $target_rel"
      printf '%s\n' "$matches"
    else
      pass "$package_label implementation target avoids temporary package dependencies: $target_rel"
    fi
  done < <(yq -r '.implementation_targets[]?' "$manifest")
}

validate_readme_contract() {
  local readme="$1"
  local package_label="$2"
  local status="$3"
  local disposition="$4"

  check_contains "$readme" "temporary, implementation-scoped design package" "$package_label README marks package temporary"
  check_contains "$readme" "not a canonical runtime" "$package_label README forbids canonical treatment"
  check_contains "$readme" "## Implementation Targets" "$package_label README includes implementation targets section"
  check_contains "$readme" "## Exit Path" "$package_label README includes exit path section"
  check_absent "$readme" "authoritative architecture specification" "$package_label README avoids forbidden authority phrase"
  check_absent "$readme" "source of truth" "$package_label README avoids forbidden source-of-truth phrase"

  if [[ "$status" == "archived" ]]; then
    check_contains "$readme" "Status: \`archived\`" "$package_label README records archived status"
    check_contains "$readme" "Archive Disposition: \`$disposition\`" "$package_label README records archive disposition"
  fi
}

validate_full_contract_artifacts() {
  local package_dir="$1"
  local manifest="$2"
  local package_label="$3"
  local package_class="$4"
  local conformance_validator_path="$5"
  local package_validator_path="$6"
  local package_rel="$7"

  check_file "$package_dir/navigation/artifact-catalog.md" "$package_label artifact catalog exists"
  check_file "$package_dir/navigation/source-of-truth-map.md" "$package_label source-of-truth map exists"
  check_file "$package_dir/implementation/README.md" "$package_label implementation README exists"
  check_file "$package_dir/implementation/minimal-implementation-blueprint.md" "$package_label blueprint exists"
  check_file "$package_dir/implementation/first-implementation-plan.md" "$package_label first implementation plan exists"

  case "$package_class" in
    domain-runtime)
      check_file "$package_dir/normative/architecture/domain-model.md" "$package_label domain model exists"
      check_file "$package_dir/normative/architecture/runtime-architecture.md" "$package_label runtime architecture exists"
      check_file "$package_dir/normative/execution/behavior-model.md" "$package_label behavior model exists"
      check_file "$package_dir/normative/assurance/implementation-readiness.md" "$package_label implementation readiness exists"
      ;;
    experience-product)
      check_file "$package_dir/normative/experience/user-journeys.md" "$package_label user journeys exist"
      check_file "$package_dir/normative/experience/information-architecture.md" "$package_label information architecture exists"
      check_file "$package_dir/normative/experience/screen-states-and-flows.md" "$package_label screen states and flows exist"
      check_file "$package_dir/normative/assurance/implementation-readiness.md" "$package_label implementation readiness exists"
      ;;
  esac

  if module_selected "$manifest" "reference"; then
    check_file "$package_dir/reference/README.md" "$package_label reference module exists"
  fi

  if module_selected "$manifest" "history"; then
    check_file "$package_dir/history/README.md" "$package_label history module exists"
  fi

  if module_selected "$manifest" "contracts"; then
    check_file "$package_dir/contracts/README.md" "$package_label contracts README exists"
    check_dir "$package_dir/contracts/schemas" "$package_label contracts schemas dir exists"
    check_dir "$package_dir/contracts/fixtures/valid" "$package_label contracts valid fixtures dir exists"
    check_dir "$package_dir/contracts/fixtures/invalid" "$package_label contracts invalid fixtures dir exists"
  fi

  if module_selected "$manifest" "canonicalization"; then
    check_file "$package_dir/navigation/canonicalization-target-map.md" "$package_label canonicalization map exists"
  fi

  if module_selected "$manifest" "conformance"; then
    check_file "$package_dir/conformance/README.md" "$package_label conformance README exists"
    check_dir "$package_dir/conformance/scenarios" "$package_label conformance scenarios dir exists"
    if [[ "$conformance_validator_path" == "null" || -z "$conformance_validator_path" ]]; then
      fail "$package_label conformance module requires validation.conformance_validator_path"
    else
      pass "$package_label conformance validator path declared"
      run_nested_validator "$package_label conformance validator" "$conformance_validator_path" "$package_rel"
    fi
  fi

  if [[ "$package_validator_path" != "null" && -n "$package_validator_path" ]]; then
    run_nested_validator "$package_label package validator" "$package_validator_path" "$package_rel"
  fi
}

validate_archive_rules() {
  local manifest="$1"
  local package_label="$2"
  local package_rel="$3"
  local package_id="$4"
  local archived_at archived_from_status disposition original_path
  local require_existing_targets=0

  archived_at="$(yaml_string "$manifest" '.archive.archived_at')"
  archived_from_status="$(yaml_string "$manifest" '.archive.archived_from_status')"
  disposition="$(yaml_string "$manifest" '.archive.disposition')"
  original_path="$(yaml_string "$manifest" '.archive.original_path')"

  if [[ "$package_rel" == ".design-packages/.archive/$package_id" ]]; then
    pass "$package_label archived package lives under .design-packages/.archive/"
  else
    fail "$package_label archived package must live under .design-packages/.archive/"
  fi

  validate_date_string "$archived_at" "$package_label archived_at is YYYY-MM-DD"
  validate_enum "$archived_from_status" \
    "$package_label archived_from_status valid" \
    "draft" "in-review" "implementation-ready" "legacy-unknown"
  validate_enum "$disposition" \
    "$package_label archive disposition valid" \
    "implemented" "historical"
  [[ -n "$original_path" ]] && pass "$package_label original_path present" || fail "$package_label original_path present"

  if [[ "$disposition" == "implemented" ]]; then
    require_existing_targets=1
  fi
  validate_promotion_evidence "$manifest" "$package_label" "$require_existing_targets"
  validate_implementation_targets "$manifest" "$package_label" "$package_id" "$require_existing_targets"
}

validate_active_rules() {
  local package_label="$1"
  local package_rel="$2"
  local package_id="$3"
  if [[ "$package_rel" == ".design-packages/$package_id" ]]; then
    pass "$package_label active package lives under .design-packages/"
  else
    fail "$package_label active package must live directly under .design-packages/"
  fi
}

validate_package() {
  local package_dir="$1"
  local manifest="$package_dir/design-package.yml"
  local package_rel package_label package_id title summary package_class status
  local lifecycle_temporary exit_expectation default_audit_mode
  local package_validator_path conformance_validator_path implementation_targets_len
  local readme disposition archived_from_status
  local has_archive=0 full_contract_required=1

  package_rel="$(rel_path "$package_dir")"
  package_label="package '$package_rel'"

  check_file "$manifest" "$package_label manifest exists"
  [[ -f "$manifest" ]] || return 0

  if ! yq -e '.' "$manifest" >/dev/null 2>&1; then
    fail "$package_label manifest parses as YAML"
    return 0
  fi
  pass "$package_label manifest parses as YAML"

  validate_enum "$(yaml_string "$manifest" '.schema_version')" \
    "$package_label schema_version is design-package-v1" "design-package-v1"

  package_id="$(yaml_string "$manifest" '.package_id')"
  title="$(yaml_string "$manifest" '.title')"
  summary="$(yaml_string "$manifest" '.summary')"
  package_class="$(yaml_string "$manifest" '.package_class')"
  status="$(yaml_string "$manifest" '.status')"
  lifecycle_temporary="$(yq -r '.lifecycle.temporary // ""' "$manifest")"
  exit_expectation="$(yaml_string "$manifest" '.lifecycle.exit_expectation')"
  default_audit_mode="$(yaml_string "$manifest" '.validation.default_audit_mode')"
  package_validator_path="$(yq -r '.validation.package_validator_path // "null"' "$manifest")"
  conformance_validator_path="$(yq -r '.validation.conformance_validator_path // "null"' "$manifest")"
  implementation_targets_len="$(yq -r '.implementation_targets | length' "$manifest")"

  if has_key "$manifest" "archive"; then
    has_archive=1
  fi

  if [[ "$package_id" == "$(basename "$package_dir")" ]]; then
    pass "$package_label package_id matches directory name"
  else
    fail "$package_label package_id must match directory name"
  fi

  [[ -n "$title" ]] && pass "$package_label title present" || fail "$package_label title present"
  [[ -n "$summary" ]] && pass "$package_label summary present" || fail "$package_label summary present"

  validate_enum "$package_class" \
    "$package_label package_class valid" \
    "domain-runtime" "experience-product"
  validate_enum "$status" \
    "$package_label status valid" \
    "draft" "in-review" "implementation-ready" "archived"
  validate_enum "$default_audit_mode" \
    "$package_label default audit mode valid" \
    "rigorous" "short"

  if [[ "$lifecycle_temporary" == "true" ]]; then
    pass "$package_label lifecycle.temporary remains true"
  else
    fail "$package_label lifecycle.temporary remains true"
  fi

  [[ -n "$exit_expectation" ]] && pass "$package_label exit expectation present" || fail "$package_label exit expectation present"

  if [[ "$implementation_targets_len" =~ ^[0-9]+$ ]] && [[ "$implementation_targets_len" -gt 0 ]]; then
    pass "$package_label implementation_targets must contain at least one path"
  else
    fail "$package_label implementation_targets must contain at least one path"
  fi

  validate_selected_modules "$manifest" "$package_label"

  if [[ "$status" == "archived" ]]; then
    if [[ "$has_archive" -eq 1 ]]; then
      pass "$package_label archived package declares archive metadata"
    else
      fail "$package_label archived package declares archive metadata"
    fi
    validate_archive_rules "$manifest" "$package_label" "$package_rel" "$package_id"
    archived_from_status="$(yaml_string "$manifest" '.archive.archived_from_status')"
    if [[ "$archived_from_status" == "legacy-unknown" ]]; then
      full_contract_required=0
    fi
    disposition="$(yaml_string "$manifest" '.archive.disposition')"
  else
    validate_active_rules "$package_label" "$package_rel" "$package_id"
    if [[ "$has_archive" -eq 1 ]]; then
      fail "$package_label active package must not declare archive metadata"
    else
      pass "$package_label active package omits archive metadata"
    fi
    validate_implementation_targets "$manifest" "$package_label" "$package_id" 0
    disposition=""
  fi

  readme="$package_dir/README.md"
  check_file "$readme" "$package_label core README exists"
  validate_readme_contract "$readme" "$package_label" "$status" "$disposition"

  if [[ "$full_contract_required" -eq 1 ]]; then
    validate_full_contract_artifacts \
      "$package_dir" \
      "$manifest" \
      "$package_label" \
      "$package_class" \
      "$conformance_validator_path" \
      "$package_validator_path" \
      "$package_rel"
  else
    pass "$package_label legacy archive uses reduced archive contract"
  fi

  VALIDATED_PACKAGE_DIRS+=("$package_dir")
}

validate_registry() {
  local registry="$ROOT_DIR/.design-packages/registry.yml"
  local package_dir manifest package_id title package_class status package_rel
  local implementation_targets_json section total_count section_count
  local archived_at archived_from_status disposition original_path
  local entry_path

  if [[ "${#VALIDATED_PACKAGE_DIRS[@]}" -eq 0 ]]; then
    return 0
  fi

  check_file "$registry" "design-package registry exists"
  [[ -f "$registry" ]] || return 0

  if ! yq -e '.' "$registry" >/dev/null 2>&1; then
    fail "design-package registry parses as YAML"
    return 0
  fi
  pass "design-package registry parses as YAML"

  validate_enum "$(yaml_string "$registry" '.schema_version')" \
    "design-package registry schema_version valid" \
    "design-package-registry-v1"

  while IFS= read -r entry_path; do
    [[ -n "$entry_path" ]] || continue
    if [[ -f "$ROOT_DIR/$entry_path/design-package.yml" ]]; then
      pass "registry entry points to manifest-bearing package: $entry_path"
    else
      fail "registry entry points to manifest-bearing package: $entry_path"
    fi
  done < <(yq -r '.active[]?.path, .archived[]?.path' "$registry")

  for package_dir in "${VALIDATED_PACKAGE_DIRS[@]}"; do
    manifest="$package_dir/design-package.yml"
    package_id="$(yaml_string "$manifest" '.package_id')"
    title="$(yaml_string "$manifest" '.title')"
    package_class="$(yaml_string "$manifest" '.package_class')"
    status="$(yaml_string "$manifest" '.status')"
    package_rel="$(rel_path "$package_dir")"
    implementation_targets_json="$(yq -o=json '.implementation_targets' "$manifest" | tr -d '[:space:]')"

    if [[ "$status" == "archived" ]]; then
      section="archived"
    else
      section="active"
    fi

    total_count="$(yq -r "([.active[]? | select(.id == \"$package_id\")] + [.archived[]? | select(.id == \"$package_id\")]) | length" "$registry")"
    section_count="$(yq -r "([.${section}[]? | select(.id == \"$package_id\")]) | length" "$registry")"

    if [[ "$section_count" == "1" ]]; then
      pass "registry has expected $section entry for $package_id"
    else
      fail "registry has expected $section entry for $package_id"
      continue
    fi

    if [[ "$total_count" == "1" ]]; then
      pass "registry has exactly one entry for $package_id"
    else
      fail "registry has exactly one entry for $package_id"
    fi

    if [[ "$(yq -r "(.${section}[] | select(.id == \"$package_id\") | .path)" "$registry")" == "$package_rel" ]]; then
      pass "registry path matches manifest for $package_id"
    else
      fail "registry path matches manifest for $package_id"
    fi

    if [[ "$(yq -r "(.${section}[] | select(.id == \"$package_id\") | .title)" "$registry")" == "$title" ]]; then
      pass "registry title matches manifest for $package_id"
    else
      fail "registry title matches manifest for $package_id"
    fi

    if [[ "$(yq -r "(.${section}[] | select(.id == \"$package_id\") | .package_class)" "$registry")" == "$package_class" ]]; then
      pass "registry package_class matches manifest for $package_id"
    else
      fail "registry package_class matches manifest for $package_id"
    fi

    if [[ "$(yq -r "(.${section}[] | select(.id == \"$package_id\") | .status)" "$registry")" == "$status" ]]; then
      pass "registry status matches manifest for $package_id"
    else
      fail "registry status matches manifest for $package_id"
    fi

    if [[ "$(yq -o=json "(.${section}[] | select(.id == \"$package_id\") | .implementation_targets)" "$registry" | tr -d '[:space:]')" == "$implementation_targets_json" ]]; then
      pass "registry implementation targets match manifest for $package_id"
    else
      fail "registry implementation targets match manifest for $package_id"
    fi

    if [[ "$status" == "archived" ]]; then
      disposition="$(yaml_string "$manifest" '.archive.disposition')"
      archived_at="$(yaml_string "$manifest" '.archive.archived_at')"
      archived_from_status="$(yaml_string "$manifest" '.archive.archived_from_status')"
      original_path="$(yaml_string "$manifest" '.archive.original_path')"

      if [[ "$(yq -r "(.archived[] | select(.id == \"$package_id\") | .disposition)" "$registry")" == "$disposition" ]]; then
        pass "registry disposition matches manifest for $package_id"
      else
        fail "registry disposition matches manifest for $package_id"
      fi

      if [[ "$(yq -r "(.archived[] | select(.id == \"$package_id\") | .archived_at)" "$registry")" == "$archived_at" ]]; then
        pass "registry archived_at matches manifest for $package_id"
      else
        fail "registry archived_at matches manifest for $package_id"
      fi

      if [[ "$(yq -r "(.archived[] | select(.id == \"$package_id\") | .archived_from_status)" "$registry")" == "$archived_from_status" ]]; then
        pass "registry archived_from_status matches manifest for $package_id"
      else
        fail "registry archived_from_status matches manifest for $package_id"
      fi

      if [[ "$(yq -r "(.archived[] | select(.id == \"$package_id\") | .original_path)" "$registry")" == "$original_path" ]]; then
        pass "registry original_path matches manifest for $package_id"
      else
        fail "registry original_path matches manifest for $package_id"
      fi
    fi
  done
}

validate_all_standard_packages() {
  local found=0 manifest
  while IFS= read -r manifest; do
    [[ -z "$manifest" ]] && continue
    found=1
    validate_package "$(dirname "$manifest")"
  done < <(find "$ROOT_DIR/.design-packages" -name design-package.yml -type f | sort)

  if [[ "$found" -eq 0 ]]; then
    warn "no manifest-governed design packages found under .design-packages/"
  fi
}

main() {
  echo "== Design Package Standard Validation =="

  if [[ -n "$PACKAGE_PATH" ]]; then
    local package_dir
    package_dir="$(resolve_package_dir "$PACKAGE_PATH")" || true
    if [[ -n "$package_dir" ]]; then
      validate_package "$package_dir"
    fi
  else
    validate_all_standard_packages
  fi

  validate_registry

  echo "Validation summary: errors=$errors warnings=$warnings"
  if [[ "$errors" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
