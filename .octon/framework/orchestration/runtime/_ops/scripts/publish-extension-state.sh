#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/extensions-common.sh"

extensions_common_init "${BASH_SOURCE[0]}"

PUBLISHED_AT=""
GENERATION_ID=""
GENERATOR_VERSION=""
declare -a PUBLISHED_SELECTED_KEYS=()

write_string_array_yaml() {
  local indent="$1"
  shift
  if [[ "$#" -eq 0 ]]; then
    printf '%s[]\n' "$indent"
    return
  fi
  local value
  for value in "$@"; do
    printf '%s- "%s"\n' "$indent" "$value"
  done
}

write_fragment_host_adapters() {
  local fragment_file="$1" item_query="$2"
  local adapters=()
  while IFS= read -r adapter; do
    [[ -n "$adapter" ]] || continue
    adapters+=("$adapter")
  done < <(yq -r "$item_query.host_adapters[]? // \"\"" "$fragment_file" 2>/dev/null || true)

  if [[ "${#adapters[@]}" -eq 0 ]]; then
    adapters=(claude cursor codex)
  fi

  printf '        host_adapters:\n'
  write_string_array_yaml '          ' "${adapters[@]}"
}

write_fragment_selectors() {
  local fragment_file="$1" item_query="$2"
  local include=()
  local exclude=()
  while IFS= read -r value; do
    [[ -n "$value" ]] || continue
    include+=("$value")
  done < <(yq -r "$item_query.routing.selectors.include[]? // \"\"" "$fragment_file" 2>/dev/null || true)
  while IFS= read -r value; do
    [[ -n "$value" ]] || continue
    exclude+=("$value")
  done < <(yq -r "$item_query.routing.selectors.exclude[]? // \"\"" "$fragment_file" 2>/dev/null || true)

  if [[ "${#include[@]}" -eq 0 ]]; then
    include=('**')
  fi

  printf '        selectors:\n'
  printf '          include:\n'
  write_string_array_yaml '            ' "${include[@]}"
  printf '          exclude:\n'
  write_string_array_yaml '            ' "${exclude[@]}"
}

write_fragment_fingerprints() {
  local fragment_file="$1" item_query="$2"
  local tech_tags=()
  local language_tags=()
  while IFS= read -r value; do
    [[ -n "$value" ]] || continue
    tech_tags+=("$value")
  done < <(yq -r "$item_query.routing.fingerprints.tech_tags[]? // \"\"" "$fragment_file" 2>/dev/null || true)
  while IFS= read -r value; do
    [[ -n "$value" ]] || continue
    language_tags+=("$value")
  done < <(yq -r "$item_query.routing.fingerprints.language_tags[]? // \"\"" "$fragment_file" 2>/dev/null || true)

  printf '        fingerprints:\n'
  printf '          tech_tags:\n'
  write_string_array_yaml '            ' "${tech_tags[@]}"
  printf '          language_tags:\n'
  write_string_array_yaml '            ' "${language_tags[@]}"
}

write_pack_command_routing_exports() {
  local pack_id="$1" manifest_abs="$2" commands_root_rel fragment_file item_query path source_path
  commands_root_rel="$(yq -r '.content_entrypoints.commands // ""' "$manifest_abs")"
  if [[ -z "$commands_root_rel" || "$commands_root_rel" == "null" ]]; then
    printf '      commands: []\n'
    return
  fi
  fragment_file="$(ext_pack_root_abs "$pack_id")/${commands_root_rel%/}/manifest.fragment.yml"
  if [[ ! -f "$fragment_file" ]]; then
    printf '      commands: []\n'
    return
  fi
  if [[ "$(yq -r '.commands | length' "$fragment_file" 2>/dev/null || echo 0)" == "0" ]]; then
    printf '      commands: []\n'
    return
  fi

  printf '      commands:\n'
  local index
  index=0
  while true; do
    if ! yq -e ".commands[$index]" "$fragment_file" >/dev/null 2>&1; then
      break
    fi
    item_query=".commands[$index]"
    path="$(yq -r "$item_query.path // \"\"" "$fragment_file")"
    source_path=".octon/inputs/additive/extensions/$pack_id/${commands_root_rel%/}/$path"
    printf '        - capability_id: "%s"\n' "$(yq -r "$item_query.id // \"\"" "$fragment_file")"
    printf '          display_name: "%s"\n' "$(yq -r "$item_query.display_name // \"\"" "$fragment_file")"
    printf '          summary: "%s"\n' "$(yq -r "$item_query.summary // \"\"" "$fragment_file")"
    printf '          status: "active"\n'
    printf '          path: "%s"\n' "$path"
    printf '          access: "%s"\n' "$(yq -r "$item_query.access // \"agent\"" "$fragment_file")"
    printf '          manifest_fragment_path: ".octon/inputs/additive/extensions/%s/%s/manifest.fragment.yml"\n' "$pack_id" "${commands_root_rel%/}"
    printf '          projection_source_path: "%s"\n' "$source_path"
    write_fragment_host_adapters "$fragment_file" "$item_query"
    write_fragment_selectors "$fragment_file" "$item_query"
    write_fragment_fingerprints "$fragment_file" "$item_query"
    index=$((index + 1))
  done
}

write_pack_skill_routing_exports() {
  local pack_id="$1" manifest_abs="$2" skills_root_rel fragment_file item_query path source_path
  skills_root_rel="$(yq -r '.content_entrypoints.skills // ""' "$manifest_abs")"
  if [[ -z "$skills_root_rel" || "$skills_root_rel" == "null" ]]; then
    printf '      skills: []\n'
    return
  fi
  fragment_file="$(ext_pack_root_abs "$pack_id")/${skills_root_rel%/}/manifest.fragment.yml"
  if [[ ! -f "$fragment_file" ]]; then
    printf '      skills: []\n'
    return
  fi
  if [[ "$(yq -r '.skills | length' "$fragment_file" 2>/dev/null || echo 0)" == "0" ]]; then
    printf '      skills: []\n'
    return
  fi

  printf '      skills:\n'
  local index
  index=0
  while true; do
    if ! yq -e ".skills[$index]" "$fragment_file" >/dev/null 2>&1; then
      break
    fi
    item_query=".skills[$index]"
    path="$(yq -r "$item_query.path // \"\"" "$fragment_file")"
    path="${path%/}"
    source_path=".octon/inputs/additive/extensions/$pack_id/${skills_root_rel%/}/$path"
    printf '        - capability_id: "%s"\n' "$(yq -r "$item_query.id // \"\"" "$fragment_file")"
    printf '          display_name: "%s"\n' "$(yq -r "$item_query.display_name // \"\"" "$fragment_file")"
    printf '          summary: "%s"\n' "$(yq -r "$item_query.summary // \"\"" "$fragment_file")"
    printf '          status: "%s"\n' "$(yq -r "$item_query.status // \"active\"" "$fragment_file")"
    printf '          path: "%s"\n' "${path}/"
    printf '          manifest_fragment_path: ".octon/inputs/additive/extensions/%s/%s/manifest.fragment.yml"\n' "$pack_id" "${skills_root_rel%/}"
    printf '          projection_source_path: "%s"\n' "$source_path"
    write_fragment_host_adapters "$fragment_file" "$item_query"
    write_fragment_selectors "$fragment_file" "$item_query"
    write_fragment_fingerprints "$fragment_file" "$item_query"
    index=$((index + 1))
  done
}

write_routing_exports() {
  local pack_id="$1" manifest_abs="$2"
  printf '    routing_exports:\n'
  write_pack_command_routing_exports "$pack_id" "$manifest_abs"
  write_pack_skill_routing_exports "$pack_id" "$manifest_abs"
}

write_content_roots() {
  local manifest="$1" pack_id="$2" bucket rel
  printf '    content_roots:\n'
  for bucket in skills commands templates prompts context validation; do
    rel="$(yq -r ".content_entrypoints.$bucket // \"\"" "$manifest")"
    if [[ -z "$rel" || "$rel" == "null" ]]; then
      printf '      %s: null\n' "$bucket"
    else
      printf '      %s: ".octon/inputs/additive/extensions/%s/%s"\n' "$bucket" "$pack_id" "$rel"
    fi
  done
}

write_effective_files() {
  local desired_sha="$1" root_sha="$2" tmpdir="$3" status="$4"
  local active_tmp quarantine_tmp catalog_tmp artifact_map_tmp lock_tmp
  local key pack_id source_id manifest_abs manifest_rel trust_decision ack_id
  local rel_path bucket abs_path sha payload_lines payload_sha

  active_tmp="$tmpdir/active.yml"
  quarantine_tmp="$tmpdir/quarantine.yml"
  catalog_tmp="$tmpdir/catalog.effective.yml"
  artifact_map_tmp="$tmpdir/artifact-map.yml"
  lock_tmp="$tmpdir/generation.lock.yml"

  {
    printf 'schema_version: "octon-extension-active-state-v2"\n'
    printf 'desired_config_revision:\n'
    printf '  path: ".octon/instance/extensions.yml"\n'
    printf '  sha256: "%s"\n' "$desired_sha"
    ext_emit_pack_ref_list "desired_selected_packs" "${EXT_SELECTED_KEYS[@]}"
    ext_emit_pack_ref_list "published_active_packs" "${PUBLISHED_SELECTED_KEYS[@]}"
    ext_emit_dependency_closure_list "dependency_closure" "${EXT_PUBLISHED_KEYS[@]}"
    printf 'generation_id: "%s"\n' "$GENERATION_ID"
    printf 'published_effective_catalog: ".octon/generated/effective/extensions/catalog.effective.yml"\n'
    printf 'published_artifact_map: ".octon/generated/effective/extensions/artifact-map.yml"\n'
    printf 'published_generation_lock: ".octon/generated/effective/extensions/generation.lock.yml"\n'
    printf 'validation_timestamp: "%s"\n' "$PUBLISHED_AT"
    printf 'status: "%s"\n' "$status"
  } >"$active_tmp"

  {
    printf 'schema_version: "octon-extension-quarantine-state-v2"\n'
    printf 'updated_at: "%s"\n' "$PUBLISHED_AT"
    ext_write_quarantine_records "$PUBLISHED_AT"
  } >"$quarantine_tmp"

  {
    printf 'schema_version: "octon-extension-effective-catalog-v3"\n'
    printf 'generator_version: "%s"\n' "$GENERATOR_VERSION"
    printf 'generation_id: "%s"\n' "$GENERATION_ID"
    printf 'published_at: "%s"\n' "$PUBLISHED_AT"
    printf 'publication_status: "%s"\n' "$status"
    ext_emit_pack_ref_list "desired_selected_packs" "${EXT_SELECTED_KEYS[@]}"
    ext_emit_pack_ref_list "published_active_packs" "${PUBLISHED_SELECTED_KEYS[@]}"
    ext_emit_dependency_closure_list "dependency_closure" "${EXT_PUBLISHED_KEYS[@]}"
    if [[ "${#EXT_PUBLISHED_KEYS[@]}" -eq 0 ]]; then
      printf 'packs: []\n'
    else
      printf 'packs:\n'
      for key in "${EXT_PUBLISHED_KEYS[@]}"; do
        pack_id="$(ext_key_pack_id "$key")"
        source_id="$(ext_key_source_id "$key")"
        manifest_rel="${EXT_PUBLISHED_MANIFEST_REL["$key"]}"
        manifest_abs="$ROOT_DIR/$manifest_rel"
        trust_decision="${EXT_PUBLISHED_TRUST_DECISION["$key"]}"
        printf '  - pack_id: "%s"\n' "$pack_id"
        printf '    source_id: "%s"\n' "$source_id"
        printf '    version: "%s"\n' "${EXT_PUBLISHED_VERSION["$key"]}"
        printf '    origin_class: "%s"\n' "${EXT_PUBLISHED_ORIGIN_CLASS["$key"]}"
        printf '    manifest_path: "%s"\n' "$manifest_rel"
        printf '    trust_decision: "%s"\n' "$trust_decision"
        printf '    publication_status: "%s"\n' "$status"
        write_content_roots "$manifest_abs" "$pack_id"
        write_routing_exports "$pack_id" "$manifest_abs"
      done
    fi
    printf 'source:\n'
    printf '  desired_config_path: ".octon/instance/extensions.yml"\n'
    printf '  desired_config_sha256: "%s"\n' "$desired_sha"
    printf '  root_manifest_path: ".octon/octon.yml"\n'
    printf '  root_manifest_sha256: "%s"\n' "$root_sha"
  } >"$catalog_tmp"

  {
    printf 'schema_version: "octon-extension-artifact-map-v3"\n'
    printf 'generator_version: "%s"\n' "$GENERATOR_VERSION"
    printf 'generation_id: "%s"\n' "$GENERATION_ID"
    printf 'published_at: "%s"\n' "$PUBLISHED_AT"
    if [[ "${#EXT_PUBLISHED_KEYS[@]}" -eq 0 ]]; then
      printf 'artifacts: []\n'
    else
      printf 'artifacts:\n'
      for key in "${EXT_PUBLISHED_KEYS[@]}"; do
        pack_id="$(ext_key_pack_id "$key")"
        source_id="$(ext_key_source_id "$key")"
        while IFS= read -r abs_path; do
          [[ -n "$abs_path" ]] || continue
          rel_path="${abs_path#$(ext_pack_root_abs "$pack_id")/}"
          bucket="$(ext_bucket_for_relative_path "$rel_path")"
          sha="$(ext_hash_file "$abs_path")"
          printf '  - pack_id: "%s"\n' "$pack_id"
          printf '    source_id: "%s"\n' "$source_id"
          printf '    bucket: "%s"\n' "$bucket"
          printf '    relative_path: "%s"\n' "$rel_path"
          printf '    source_path: ".octon/inputs/additive/extensions/%s/%s"\n' "$pack_id" "$rel_path"
          printf '    sha256: "%s"\n' "$sha"
        done < <(find "$(ext_pack_root_abs "$pack_id")" -type f | sort)
      done
    fi
  } >"$artifact_map_tmp"

  {
    printf 'schema_version: "octon-extension-generation-lock-v3"\n'
    printf 'generator_version: "%s"\n' "$GENERATOR_VERSION"
    printf 'generation_id: "%s"\n' "$GENERATION_ID"
    printf 'published_at: "%s"\n' "$PUBLISHED_AT"
    printf 'desired_config_sha256: "%s"\n' "$desired_sha"
    printf 'root_manifest_sha256: "%s"\n' "$root_sha"
    printf 'published_files:\n'
    printf '  - path: ".octon/generated/effective/extensions/catalog.effective.yml"\n'
    printf '  - path: ".octon/generated/effective/extensions/artifact-map.yml"\n'
    printf '  - path: ".octon/generated/effective/extensions/generation.lock.yml"\n'
    if [[ "${#EXT_PUBLISHED_KEYS[@]}" -eq 0 ]]; then
      printf 'pack_payload_digests: []\n'
    else
      printf 'pack_payload_digests:\n'
      for key in "${EXT_PUBLISHED_KEYS[@]}"; do
        pack_id="$(ext_key_pack_id "$key")"
        source_id="$(ext_key_source_id "$key")"
        payload_lines=""
        printf '  - pack_id: "%s"\n' "$pack_id"
        printf '    source_id: "%s"\n' "$source_id"
        printf '    manifest_path: "%s"\n' "${EXT_PUBLISHED_MANIFEST_REL["$key"]}"
        printf '    origin_class: "%s"\n' "${EXT_PUBLISHED_ORIGIN_CLASS["$key"]}"
        printf '    version: "%s"\n' "${EXT_PUBLISHED_VERSION["$key"]}"
        while IFS= read -r abs_path; do
          [[ -n "$abs_path" ]] || continue
          rel_path="${abs_path#$(ext_pack_root_abs "$pack_id")/}"
          sha="$(ext_hash_file "$abs_path")"
          payload_lines+="${sha} .octon/inputs/additive/extensions/${pack_id}/${rel_path}"$'\n'
        done < <(find "$(ext_pack_root_abs "$pack_id")" -type f | sort)
        payload_sha="$(printf '%s' "$payload_lines" | ext_hash_text)"
        printf '    payload_sha256: "%s"\n' "$payload_sha"
        printf '    files:\n'
        while IFS= read -r abs_path; do
          [[ -n "$abs_path" ]] || continue
          rel_path="${abs_path#$(ext_pack_root_abs "$pack_id")/}"
          sha="$(ext_hash_file "$abs_path")"
          printf '      - path: ".octon/inputs/additive/extensions/%s/%s"\n' "$pack_id" "$rel_path"
          printf '        sha256: "%s"\n' "$sha"
        done < <(find "$(ext_pack_root_abs "$pack_id")" -type f | sort)
      done
    fi
  } >"$lock_tmp"

  mkdir -p "$(dirname "$ACTIVE_STATE")" "$EFFECTIVE_DIR"
  mv "$catalog_tmp" "$CATALOG_FILE"
  mv "$artifact_map_tmp" "$ARTIFACT_MAP_FILE"
  mv "$lock_tmp" "$GENERATION_LOCK_FILE"
  mv "$quarantine_tmp" "$QUARANTINE_STATE"
  mv "$active_tmp" "$ACTIVE_STATE"
}

main() {
  local desired_sha root_sha tmpdir status selected_key pack_id source_id

  PUBLISHED_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  desired_sha="$(ext_hash_file "$EXTENSIONS_MANIFEST")"
  root_sha="$(ext_hash_file "$ROOT_MANIFEST")"
  GENERATOR_VERSION="$(yq -r '.versioning.harness.release_version // ""' "$ROOT_MANIFEST")"
  GENERATION_ID="extensions-$(printf '%s' "$desired_sha" | cut -c1-12)"

  ext_load_selected_keys_from_manifest
  tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/octon-extension-state.XXXXXX")"
  trap '[[ -n "${tmpdir:-}" ]] && rm -r -f -- "$tmpdir"' EXIT

  for selected_key in "${EXT_SELECTED_KEYS[@]}"; do
    pack_id="$(ext_key_pack_id "$selected_key")"
    source_id="$(ext_key_source_id "$selected_key")"
    ext_clear_candidate_state
    if ext_resolve_candidate_pack "$pack_id" "$source_id" 1; then
      ext_merge_candidate_into_published
      PUBLISHED_SELECTED_KEYS+=("$selected_key")
    else
      ext_record_quarantine "$pack_id" "$source_id" "$EXT_LAST_ERROR_REASON" "$pack_id" "$EXT_LAST_ERROR_ACKNOWLEDGEMENT_ID"
    fi
  done

  mapfile -t EXT_SELECTED_KEYS < <(ext_pack_key_sort "${EXT_SELECTED_KEYS[@]}")
  mapfile -t EXT_PUBLISHED_KEYS < <(ext_pack_key_sort "${EXT_PUBLISHED_KEYS[@]}")
  mapfile -t PUBLISHED_SELECTED_KEYS < <(ext_pack_key_sort "${PUBLISHED_SELECTED_KEYS[@]}")
  mapfile -t EXT_QUARANTINE_KEYS < <(ext_pack_key_sort "${EXT_QUARANTINE_KEYS[@]}")

  if [[ "${#EXT_SELECTED_KEYS[@]}" -eq 0 ]]; then
    status="published"
  elif [[ "${#PUBLISHED_SELECTED_KEYS[@]}" -eq 0 ]]; then
    status="withdrawn"
  elif [[ "${#EXT_QUARANTINE_KEYS[@]}" -gt 0 ]]; then
    status="published_with_quarantine"
  else
    status="published"
  fi

  write_effective_files "$desired_sha" "$root_sha" "$tmpdir" "$status"
  echo "[OK] published extension state: $GENERATION_ID ($status)"
}

main "$@"
