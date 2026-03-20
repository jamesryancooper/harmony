#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/extensions-common.sh"

extensions_common_init "${BASH_SOURCE[0]}"

PUBLISHED_AT=""
GENERATION_ID=""
declare -a PUBLISHED_SELECTED_KEYS=()

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
    printf 'schema_version: "octon-extension-effective-catalog-v2"\n'
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
      done
    fi
    printf 'source:\n'
    printf '  desired_config_path: ".octon/instance/extensions.yml"\n'
    printf '  desired_config_sha256: "%s"\n' "$desired_sha"
    printf '  root_manifest_path: ".octon/octon.yml"\n'
    printf '  root_manifest_sha256: "%s"\n' "$root_sha"
  } >"$catalog_tmp"

  {
    printf 'schema_version: "octon-extension-artifact-map-v2"\n'
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
    printf 'schema_version: "octon-extension-generation-lock-v2"\n'
    printf 'generation_id: "%s"\n' "$GENERATION_ID"
    printf 'published_at: "%s"\n' "$PUBLISHED_AT"
    printf 'desired_config_sha256: "%s"\n' "$desired_sha"
    printf 'root_manifest_sha256: "%s"\n' "$root_sha"
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
