#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ASSURANCE_DIR="$(cd -- "$SCRIPT_DIR/../../.." && pwd)"
FRAMEWORK_DIR="$(cd -- "$ASSURANCE_DIR/.." && pwd)"
OCTON_DIR="$(cd -- "$FRAMEWORK_DIR/.." && pwd)"
ROOT_DIR="$(cd -- "$OCTON_DIR/.." && pwd)"

PROPOSAL_PATH=""
SCAN_ALL=0
errors=0
warnings=0
registry_schema_validated=0

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
  validate-proposal-standard.sh --package <path>
  validate-proposal-standard.sh --all-standard-proposals
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --package)
      shift
      [[ $# -gt 0 ]] || { usage >&2; exit 2; }
      PROPOSAL_PATH="$1"
      ;;
    --all-standard-proposals)
      SCAN_ALL=1
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ -n "$PROPOSAL_PATH" && "$SCAN_ALL" -eq 1 ]]; then
  usage >&2
  exit 2
fi

if [[ -z "$PROPOSAL_PATH" && "$SCAN_ALL" -ne 1 ]]; then
  usage >&2
  exit 2
fi

resolve_dir() {
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
    fail "proposal path not found: ${candidate#$ROOT_DIR/}"
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

json_string() {
  local file="$1"
  local query="$2"
  yq -r "$query // \"\"" "$file"
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

validate_regex() {
  local value="$1"
  local label="$2"
  local pattern="$3"
  if perl -e 'exit(($ARGV[0] =~ /$ARGV[1]/) ? 0 : 1)' -- "$value" "$pattern"; then
    pass "$label"
  else
    fail "$label"
  fi
}

validate_schema_enum() {
  local value="$1"
  local label="$2"
  local schema_file="$3"
  local query="$4"
  mapfile -t allowed < <(yq -r "$query[]" "$schema_file")
  validate_enum "$value" "$label" "${allowed[@]}"
}

validate_non_empty() {
  local value="$1"
  local label="$2"
  if [[ -n "$value" ]]; then
    pass "$label"
  else
    fail "$label"
  fi
}

validate_subtype_manifest_count() {
  local proposal_dir="$1"
  local label="$2"
  local count=0
  local subtype
  for subtype in design-proposal.yml migration-proposal.yml policy-proposal.yml architecture-proposal.yml; do
    if [[ -f "$proposal_dir/$subtype" ]]; then
      count=$((count + 1))
    fi
  done

  if [[ "$count" -eq 1 ]]; then
    pass "$label has exactly one subtype manifest"
  else
    fail "$label has exactly one subtype manifest"
  fi
}

validate_registry_section_against_schema() {
  local registry="$1"
  local schema="$2"
  local section="$3"
  local count idx value
  local required_query=".properties.${section}.items.required"
  local props_query=".properties.${section}.items.properties"
  local id_pattern kind_query scope_query path_pattern status_query

  count="$(yq -r ".${section} | length" "$registry")"
  id_pattern="$(json_string "$schema" "${props_query}.id.pattern")"
  kind_query="${props_query}.kind.enum"
  scope_query="${props_query}.scope.enum"
  path_pattern="$(json_string "$schema" "${props_query}.path.pattern")"

  if [[ "$section" == "active" ]]; then
    status_query="${props_query}.status.enum"
  else
    status_query="${props_query}.status.const"
  fi

  for ((idx = 0; idx < count; idx++)); do
    local prefix="proposal registry ${section}[$idx]"
    local field

    while IFS= read -r field; do
      [[ -n "$field" ]] || continue
      if [[ "$field" == "promotion_targets" ]]; then
        value="$(yq -r ".${section}[$idx].promotion_targets | length" "$registry")"
        if [[ "$value" =~ ^[1-9][0-9]*$ ]]; then
          pass "$prefix promotion_targets present"
        else
          fail "$prefix promotion_targets present"
        fi
      else
        value="$(yq -r ".${section}[$idx].${field} // \"\"" "$registry")"
        validate_non_empty "$value" "$prefix required field '${field}' present"
      fi
    done < <(yq -r "$required_query[]" "$schema")

    value="$(yq -r ".${section}[$idx].id // \"\"" "$registry")"
    validate_regex "$value" "$prefix id matches schema" "$id_pattern"

    value="$(yq -r ".${section}[$idx].kind // \"\"" "$registry")"
    validate_schema_enum "$value" "$prefix kind matches schema" "$schema" "$kind_query"

    value="$(yq -r ".${section}[$idx].scope // \"\"" "$registry")"
    validate_schema_enum "$value" "$prefix scope matches schema" "$schema" "$scope_query"

    value="$(yq -r ".${section}[$idx].path // \"\"" "$registry")"
    validate_regex "$value" "$prefix path matches schema" "$path_pattern"

    value="$(yq -r ".${section}[$idx].title // \"\"" "$registry")"
    validate_non_empty "$value" "$prefix title present"

    if [[ "$section" == "active" ]]; then
      value="$(yq -r ".${section}[$idx].status // \"\"" "$registry")"
      validate_schema_enum "$value" "$prefix status matches schema" "$schema" "$status_query"
    else
      value="$(yq -r ".${section}[$idx].status // \"\"" "$registry")"
      validate_enum "$value" "$prefix status matches schema" "$(json_string "$schema" "$status_query")"

      value="$(yq -r ".${section}[$idx].disposition // \"\"" "$registry")"
      validate_schema_enum "$value" "$prefix disposition matches schema" "$schema" "${props_query}.disposition.enum"

      value="$(yq -r ".${section}[$idx].archived_at // \"\"" "$registry")"
      validate_regex "$value" "$prefix archived_at matches schema" "$(json_string "$schema" "${props_query}.archived_at.pattern")"

      value="$(yq -r ".${section}[$idx].archived_from_status // \"\"" "$registry")"
      validate_schema_enum "$value" "$prefix archived_from_status matches schema" "$schema" "${props_query}.archived_from_status.enum"

      value="$(yq -r ".${section}[$idx].original_path // \"\"" "$registry")"
      validate_non_empty "$value" "$prefix original_path present"
    fi

    local target_count target_idx target
    target_count="$(yq -r ".${section}[$idx].promotion_targets | length" "$registry")"
    for ((target_idx = 0; target_idx < target_count; target_idx++)); do
      target="$(yq -r ".${section}[$idx].promotion_targets[$target_idx] // \"\"" "$registry")"
      validate_non_empty "$target" "$prefix promotion_targets[$target_idx] present"
    done
  done
}

validate_registry_schema() {
  local registry="$ROOT_DIR/.octon/generated/proposals/registry.yml"
  local schema="$ROOT_DIR/.octon/framework/cognition/_meta/architecture/generated/proposals/schemas/proposal-registry.schema.json"

  if [[ "$registry_schema_validated" -eq 1 ]]; then
    return 0
  fi
  registry_schema_validated=1

  check_file "$registry" "proposal registry exists"
  [[ -f "$registry" ]] || return 0
  if ! yq -e '.' "$registry" >/dev/null 2>&1; then
    fail "proposal registry parses as YAML"
    return 0
  fi
  pass "proposal registry parses as YAML"

  check_file "$schema" "proposal registry schema exists"
  [[ -f "$schema" ]] || return 0
  if ! yq -e '.' "$schema" >/dev/null 2>&1; then
    fail "proposal registry schema parses as JSON"
    return 0
  fi
  pass "proposal registry schema parses as JSON"

  validate_enum "$(yaml_string "$registry" '.schema_version')" "proposal registry schema_version valid" "$(json_string "$schema" '.properties.schema_version.const')"
  validate_registry_section_against_schema "$registry" "$schema" "active"
  validate_registry_section_against_schema "$registry" "$schema" "archived"
}

allow_legacy_mixed_scope() {
  local manifest="$1"
  [[ "$(yaml_string "$manifest" '.archive.archived_from_status')" == "legacy-unknown" ]]
}

validate_promotion_targets() {
  local manifest="$1"
  local label="$2"
  local proposal_id="$3"
  local proposal_rel="$4"
  local scope target_rel saw_octon=0 saw_non_octon=0 allow_legacy=0

  scope="$(yaml_string "$manifest" '.promotion_scope')"
  if allow_legacy_mixed_scope "$manifest"; then
    allow_legacy=1
  fi
  while IFS= read -r target_rel; do
    [[ -n "$target_rel" ]] || continue
    if [[ "$target_rel" == .octon/inputs/exploratory/proposals/* ]]; then
      fail "$label promotion target must point outside .octon/inputs/exploratory/proposals/: $target_rel"
      continue
    fi

    if [[ "$target_rel" == .octon/* ]]; then
      saw_octon=1
    else
      saw_non_octon=1
    fi
  done < <(yq -r '.promotion_targets[]?' "$manifest")

  if [[ "$scope" == "octon-internal" && "$saw_non_octon" -eq 1 && "$allow_legacy" -ne 1 ]]; then
    fail "$label octon-internal scope includes non-.octon promotion targets"
  elif [[ "$scope" == "octon-internal" ]]; then
    pass "$label octon-internal targets stay under .octon/"
  fi

  if [[ "$scope" == "repo-local" && "$saw_octon" -eq 1 && "$allow_legacy" -ne 1 ]]; then
    fail "$label repo-local scope includes .octon promotion targets"
  elif [[ "$scope" == "repo-local" ]]; then
    pass "$label repo-local targets stay outside .octon/"
  fi

  if [[ "$saw_octon" -eq 1 && "$saw_non_octon" -eq 1 ]]; then
    if [[ "$allow_legacy" -eq 1 ]]; then
      warn "$label preserves historical mixed targets under legacy-unknown archive lineage"
    else
      fail "$label mixes .octon and non-.octon promotion targets"
    fi
  else
    pass "$label avoids mixed target families"
  fi

  while IFS= read -r target_rel; do
    [[ -n "$target_rel" ]] || continue
    local target_abs="$ROOT_DIR/$target_rel"
    if [[ ! -e "$target_abs" ]]; then
      if [[ "$(yaml_string "$manifest" '.status')" == "archived" && "$(yaml_string "$manifest" '.archive.disposition')" == "implemented" ]]; then
        fail "$label implemented archive target must exist: $target_rel"
      else
        warn "$label promotion target not present yet: $target_rel"
      fi
      continue
    fi
    local found=""
    found="$(grep -R -n -E "\\.octon/inputs/exploratory/proposals/(\\.archive/)?[a-z0-9-]+/${proposal_id}" "$target_abs" 2>/dev/null || true)"
    if [[ -n "$found" ]]; then
      fail "$label promotion target retains proposal-path dependency: $target_rel"
      printf '%s\n' "$found"
    else
      pass "$label promotion target avoids proposal-path backreferences: $target_rel"
    fi
  done < <(yq -r '.promotion_targets[]?' "$manifest")
}

validate_registry_projection() {
  local manifest="$1"
  local label="$2"
  local proposal_id="$3"
  local proposal_kind="$4"
  local proposal_rel="$5"
  local registry="$ROOT_DIR/.octon/generated/proposals/registry.yml"
  local path_query

  validate_registry_schema
  [[ -f "$registry" ]] || return 0

  if [[ "$(yaml_string "$manifest" '.status')" == "archived" ]]; then
    path_query=".archived[] | select(.id == \"$proposal_id\" and .kind == \"$proposal_kind\") | .path"
  else
    path_query=".active[] | select(.id == \"$proposal_id\" and .kind == \"$proposal_kind\") | .path"
  fi

  local entry_path
  entry_path="$(yq -r "$path_query // \"\"" "$registry")"
  if [[ -z "$entry_path" ]]; then
    fail "$label registry entry exists"
  elif [[ "$entry_path" == "$proposal_rel" ]]; then
    pass "$label registry entry path matches manifest path"
  else
    fail "$label registry entry path matches manifest path"
  fi
}

validate_proposal() {
  local proposal_dir="$1"
  local manifest="$proposal_dir/proposal.yml"
  local proposal_rel proposal_id kind scope status path_mode target_count disposition

  path_mode="invalid"

  proposal_rel="$(rel_path "$proposal_dir")"
  check_file "$manifest" "proposal '$proposal_rel' manifest exists"
  [[ -f "$manifest" ]] || return 0
  if ! yq -e '.' "$manifest" >/dev/null 2>&1; then
    fail "proposal '$proposal_rel' manifest parses as YAML"
    return 0
  fi
  pass "proposal '$proposal_rel' manifest parses as YAML"

  validate_enum "$(yaml_string "$manifest" '.schema_version')" "proposal '$proposal_rel' schema_version is proposal-v1" "proposal-v1"
  proposal_id="$(yaml_string "$manifest" '.proposal_id')"
  kind="$(yaml_string "$manifest" '.proposal_kind')"
  scope="$(yaml_string "$manifest" '.promotion_scope')"
  status="$(yaml_string "$manifest" '.status')"

  validate_enum "$kind" "proposal '$proposal_rel' kind valid" "design" "migration" "policy" "architecture"
  validate_enum "$scope" "proposal '$proposal_rel' scope valid" "octon-internal" "repo-local"
  validate_enum "$status" "proposal '$proposal_rel' status valid" "draft" "in-review" "accepted" "implemented" "rejected" "archived"
  check_file "$proposal_dir/README.md" "proposal '$proposal_rel' README exists"
  check_file "$proposal_dir/navigation/artifact-catalog.md" "proposal '$proposal_rel' artifact catalog exists"
  check_file "$proposal_dir/navigation/source-of-truth-map.md" "proposal '$proposal_rel' source-of-truth map exists"
  validate_subtype_manifest_count "$proposal_dir" "proposal '$proposal_rel'"

  if [[ "$(basename "$proposal_dir")" == "$proposal_id" ]]; then
    pass "proposal '$proposal_rel' id matches directory name"
  else
    fail "proposal '$proposal_rel' id matches directory name"
  fi

  case "$proposal_rel" in
    .octon/inputs/exploratory/proposals/.archive/$kind/$proposal_id)
      pass "proposal '$proposal_rel' archived path matches kind/id"
      path_mode="archived"
      ;;
    .octon/inputs/exploratory/proposals/$kind/$proposal_id)
      pass "proposal '$proposal_rel' active path matches kind/id"
      path_mode="active"
      ;;
    *) fail "proposal '$proposal_rel' lives in a valid proposal path" ;;
  esac

  target_count="$(yq -r '.promotion_targets | length' "$manifest")"
  if [[ "$target_count" =~ ^[1-9][0-9]*$ ]]; then
    pass "proposal '$proposal_rel' promotion_targets present"
  else
    fail "proposal '$proposal_rel' promotion_targets present"
  fi

  if [[ "$status" == "archived" ]]; then
    if [[ "$path_mode" == "archived" ]]; then
      pass "proposal '$proposal_rel' archived proposals stay in archive paths"
    else
      fail "proposal '$proposal_rel' archived proposals stay in archive paths"
    fi
    [[ -n "$(yaml_string "$manifest" '.archive.archived_at')" ]] && pass "proposal '$proposal_rel' archive metadata present" || fail "proposal '$proposal_rel' archive metadata present"
    validate_enum "$(yaml_string "$manifest" '.archive.archived_from_status')" "proposal '$proposal_rel' archived_from_status valid" "draft" "in-review" "accepted" "implemented" "rejected" "legacy-unknown"
    validate_enum "$(yaml_string "$manifest" '.archive.disposition')" "proposal '$proposal_rel' archive disposition valid" "implemented" "rejected" "historical" "superseded"
    validate_non_empty "$(yaml_string "$manifest" '.archive.original_path')" "proposal '$proposal_rel' archive original_path present"
    disposition="$(yaml_string "$manifest" '.archive.disposition')"
    if [[ "$disposition" == "implemented" ]]; then
      target_count="$(yq -r '.archive.promotion_evidence | length' "$manifest")"
      if [[ "$target_count" =~ ^[1-9][0-9]*$ ]]; then
        pass "proposal '$proposal_rel' implemented archive keeps promotion evidence"
      else
        fail "proposal '$proposal_rel' implemented archive keeps promotion evidence"
      fi
    fi
  else
    if [[ "$path_mode" == "active" ]]; then
      pass "proposal '$proposal_rel' active proposals stay in active paths"
    else
      fail "proposal '$proposal_rel' active proposals stay in active paths"
    fi
    if yq -e 'has("archive")' "$manifest" >/dev/null 2>&1; then
      fail "proposal '$proposal_rel' non-archived proposal must not contain archive block"
    else
      pass "proposal '$proposal_rel' non-archived proposal omits archive block"
    fi
  fi

  validate_promotion_targets "$manifest" "proposal '$proposal_rel'" "$proposal_id" "$proposal_rel"
  validate_registry_projection "$manifest" "proposal '$proposal_rel'" "$proposal_id" "$kind" "$proposal_rel"
}

main() {
  if [[ "$SCAN_ALL" -eq 1 ]]; then
    while IFS= read -r manifest; do
      validate_proposal "$(dirname "$manifest")"
    done < <(find "$ROOT_DIR/.octon/inputs/exploratory/proposals" -name proposal.yml -type f | sort)
  else
    proposal_dir="$(resolve_dir "$PROPOSAL_PATH")"
    validate_proposal "$proposal_dir"
  fi

  echo "Validation summary: errors=$errors warnings=$warnings"
  if [[ $errors -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
