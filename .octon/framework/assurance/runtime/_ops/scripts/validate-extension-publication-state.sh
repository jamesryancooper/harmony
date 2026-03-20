#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../../../orchestration/runtime/_ops/scripts/extensions-common.sh"

extensions_common_init "${BASH_SOURCE[0]}"

errors=0

fail() {
  echo "[ERROR] $1"
  errors=$((errors + 1))
}

pass() {
  echo "[OK] $1"
}

sorted_pack_refs_from_query() {
  local file="$1" query="$2"
  yq -r "$query[]? | [.pack_id, .source_id] | @tsv" "$file" 2>/dev/null \
    | awk 'NF' \
    | LC_ALL=C sort
}

sorted_closure_from_query() {
  local file="$1" query="$2"
  yq -r "$query[]? | [.pack_id, .source_id, .version, .origin_class, .manifest_path] | @tsv" "$file" 2>/dev/null \
    | awk 'NF' \
    | LC_ALL=C sort
}

main() {
  echo "== Extension Publication State Validation =="

  local file
  for file in "$EXTENSIONS_MANIFEST" "$ACTIVE_STATE" "$QUARANTINE_STATE" "$CATALOG_FILE" "$ARTIFACT_MAP_FILE" "$GENERATION_LOCK_FILE"; do
    if [[ -f "$file" ]]; then
      pass "found file: ${file#$ROOT_DIR/}"
      yq -e '.' "$file" >/dev/null 2>&1 && pass "${file#$ROOT_DIR/} parses as YAML" || fail "${file#$ROOT_DIR/} must parse as YAML"
    else
      fail "missing file: ${file#$ROOT_DIR/}"
    fi
  done

  local desired_sha root_sha generation_id status
  desired_sha="$(ext_hash_file "$EXTENSIONS_MANIFEST")"
  root_sha="$(ext_hash_file "$ROOT_MANIFEST")"

  [[ "$(yq -r '.schema_version // ""' "$ACTIVE_STATE")" == "octon-extension-active-state-v2" ]] && pass "active state schema version valid" || fail "active state schema_version invalid"
  [[ "$(yq -r '.schema_version // ""' "$QUARANTINE_STATE")" == "octon-extension-quarantine-state-v2" ]] && pass "quarantine state schema version valid" || fail "quarantine state schema_version invalid"
  [[ "$(yq -r '.schema_version // ""' "$CATALOG_FILE")" == "octon-extension-effective-catalog-v2" ]] && pass "effective catalog schema version valid" || fail "effective catalog schema_version invalid"
  [[ "$(yq -r '.schema_version // ""' "$ARTIFACT_MAP_FILE")" == "octon-extension-artifact-map-v2" ]] && pass "artifact map schema version valid" || fail "artifact map schema_version invalid"
  [[ "$(yq -r '.schema_version // ""' "$GENERATION_LOCK_FILE")" == "octon-extension-generation-lock-v2" ]] && pass "generation lock schema version valid" || fail "generation lock schema_version invalid"
  local expected_generator_version
  expected_generator_version="$(yq -r '.versioning.harness.release_version // ""' "$ROOT_MANIFEST" 2>/dev/null || true)"
  [[ -n "$expected_generator_version" ]] && pass "root manifest generator version available" || fail "root manifest missing versioning.harness.release_version"
  [[ "$(yq -r '.generator_version // ""' "$CATALOG_FILE")" == "$expected_generator_version" ]] && pass "effective catalog generator_version current" || fail "effective catalog generator_version missing or stale"
  [[ "$(yq -r '.generator_version // ""' "$ARTIFACT_MAP_FILE")" == "$expected_generator_version" ]] && pass "artifact map generator_version current" || fail "artifact map generator_version missing or stale"
  [[ "$(yq -r '.generator_version // ""' "$GENERATION_LOCK_FILE")" == "$expected_generator_version" ]] && pass "generation lock generator_version current" || fail "generation lock generator_version missing or stale"

  generation_id="$(yq -r '.generation_id // ""' "$ACTIVE_STATE")"
  status="$(yq -r '.status // ""' "$ACTIVE_STATE")"
  [[ -n "$generation_id" ]] && pass "active state generation_id declared" || fail "active state missing generation_id"
  case "$status" in
    published|published_with_quarantine|withdrawn)
      pass "active state status valid"
      ;;
    *)
      fail "active state status invalid"
      ;;
  esac

  [[ "$(yq -r '.desired_config_revision.path // ""' "$ACTIVE_STATE")" == ".octon/instance/extensions.yml" ]] && pass "active state desired config path valid" || fail "active state desired config path invalid"
  [[ "$(yq -r '.desired_config_revision.sha256 // ""' "$ACTIVE_STATE")" == "$desired_sha" ]] && pass "active state desired config hash current" || fail "active state desired config hash stale"
  [[ "$(yq -r '.published_effective_catalog // ""' "$ACTIVE_STATE")" == ".octon/generated/effective/extensions/catalog.effective.yml" ]] && pass "active state catalog reference valid" || fail "active state catalog reference invalid"
  [[ "$(yq -r '.published_artifact_map // ""' "$ACTIVE_STATE")" == ".octon/generated/effective/extensions/artifact-map.yml" ]] && pass "active state artifact map reference valid" || fail "active state artifact map reference invalid"
  [[ "$(yq -r '.published_generation_lock // ""' "$ACTIVE_STATE")" == ".octon/generated/effective/extensions/generation.lock.yml" ]] && pass "active state generation lock reference valid" || fail "active state generation lock reference invalid"

  [[ "$(yq -r '.generation_id // ""' "$CATALOG_FILE")" == "$generation_id" ]] && pass "effective catalog generation_id matches active state" || fail "effective catalog generation_id mismatch"
  [[ "$(yq -r '.generation_id // ""' "$ARTIFACT_MAP_FILE")" == "$generation_id" ]] && pass "artifact map generation_id matches active state" || fail "artifact map generation_id mismatch"
  [[ "$(yq -r '.generation_id // ""' "$GENERATION_LOCK_FILE")" == "$generation_id" ]] && pass "generation lock generation_id matches active state" || fail "generation lock generation_id mismatch"
  [[ "$(yq -r '.publication_status // ""' "$CATALOG_FILE")" == "$status" ]] && pass "effective catalog status matches active state" || fail "effective catalog status mismatch"

  [[ "$(yq -r '.source.desired_config_sha256 // ""' "$CATALOG_FILE")" == "$desired_sha" ]] && pass "effective catalog desired config hash current" || fail "effective catalog desired config hash stale"
  [[ "$(yq -r '.desired_config_sha256 // ""' "$GENERATION_LOCK_FILE")" == "$desired_sha" ]] && pass "generation lock desired config hash current" || fail "generation lock desired config hash stale"
  [[ "$(yq -r '.source.root_manifest_sha256 // ""' "$CATALOG_FILE")" == "$root_sha" ]] && pass "effective catalog root manifest hash current" || fail "effective catalog root manifest hash stale"
  [[ "$(yq -r '.root_manifest_sha256 // ""' "$GENERATION_LOCK_FILE")" == "$root_sha" ]] && pass "generation lock root manifest hash current" || fail "generation lock root manifest hash stale"

  local desired_enabled active_desired catalog_desired active_published catalog_published active_closure catalog_closure
  desired_enabled="$(yq -r '.selection.enabled[]? | [.pack_id, .source_id] | @tsv' "$EXTENSIONS_MANIFEST" 2>/dev/null | awk 'NF' | LC_ALL=C sort)"
  active_desired="$(sorted_pack_refs_from_query "$ACTIVE_STATE" '.desired_selected_packs')"
  catalog_desired="$(sorted_pack_refs_from_query "$CATALOG_FILE" '.desired_selected_packs')"
  active_published="$(sorted_pack_refs_from_query "$ACTIVE_STATE" '.published_active_packs')"
  catalog_published="$(sorted_pack_refs_from_query "$CATALOG_FILE" '.published_active_packs')"
  active_closure="$(sorted_closure_from_query "$ACTIVE_STATE" '.dependency_closure')"
  catalog_closure="$(sorted_closure_from_query "$CATALOG_FILE" '.dependency_closure')"

  [[ "$desired_enabled" == "$active_desired" ]] && pass "active state desired_selected_packs match desired selection" || fail "active state desired_selected_packs do not match desired selection"
  [[ "$desired_enabled" == "$catalog_desired" ]] && pass "effective catalog desired_selected_packs match desired selection" || fail "effective catalog desired_selected_packs do not match desired selection"
  [[ "$active_published" == "$catalog_published" ]] && pass "effective catalog published_active_packs match active state" || fail "effective catalog published_active_packs mismatch"
  [[ "$active_closure" == "$catalog_closure" ]] && pass "effective catalog dependency_closure matches active state" || fail "effective catalog dependency_closure mismatch"

  local quarantine_count
  quarantine_count="$(yq -r '.records | length' "$QUARANTINE_STATE" 2>/dev/null || printf '0')"
  case "$status" in
    published)
      [[ "$quarantine_count" == "0" ]] && pass "quarantine empty for published generation" || fail "quarantine must be empty when status=published"
      ;;
    published_with_quarantine)
      [[ "$quarantine_count" != "0" ]] && pass "quarantine present for published_with_quarantine" || fail "quarantine must be non-empty when status=published_with_quarantine"
      [[ -n "$active_published" ]] && pass "published_with_quarantine retains published_active_packs" || fail "published_with_quarantine must retain published_active_packs"
      ;;
    withdrawn)
      [[ "$quarantine_count" != "0" ]] && pass "quarantine present for withdrawn generation" || fail "withdrawn generation must record quarantine"
      [[ -z "$active_published" ]] && pass "withdrawn generation has no published_active_packs" || fail "withdrawn generation must have no published_active_packs"
      ;;
  esac

  local lock_closure
  lock_closure="$(yq -r '.pack_payload_digests[]? | [.pack_id, .source_id, .version, .origin_class, .manifest_path] | @tsv' "$GENERATION_LOCK_FILE" 2>/dev/null | awk 'NF' | LC_ALL=C sort)"
  if [[ "$lock_closure" == "$active_closure" ]]; then
    pass "generation lock pack payload records match dependency closure"
  else
    fail "generation lock pack payload records do not match dependency closure"
  fi

  local artifact_paths_from_map artifact_paths_from_lock
  artifact_paths_from_map="$(yq -r '.artifacts[]?.source_path' "$ARTIFACT_MAP_FILE" 2>/dev/null | awk 'NF' | LC_ALL=C sort)"
  artifact_paths_from_lock="$(yq -r '.pack_payload_digests[]?.files[]?.path' "$GENERATION_LOCK_FILE" 2>/dev/null | awk 'NF' | LC_ALL=C sort)"
  [[ "$artifact_paths_from_map" == "$artifact_paths_from_lock" ]] && pass "artifact map paths match generation lock files" || fail "artifact map paths do not match generation lock files"
  local published_files
  published_files="$(yq -r '.published_files[]?.path // ""' "$GENERATION_LOCK_FILE" 2>/dev/null | awk 'NF' | LC_ALL=C sort)"
  if [[ "$published_files" == $'.octon/generated/effective/extensions/artifact-map.yml\n.octon/generated/effective/extensions/catalog.effective.yml\n.octon/generated/effective/extensions/generation.lock.yml' ]]; then
    pass "generation lock published_files set valid"
  else
    fail "generation lock published_files set invalid"
  fi

  local source_path sha pack_payload_sha computed_payload_sha
  while IFS=$'\t' read -r source_path sha; do
    [[ -z "$source_path" ]] && continue
    if [[ ! -f "$ROOT_DIR/$source_path" ]]; then
      fail "artifact path missing: $source_path"
      continue
    fi
    [[ "$(ext_hash_file "$ROOT_DIR/$source_path")" == "$sha" ]] && pass "artifact digest current for $source_path" || fail "artifact digest stale for $source_path"
  done < <(yq -r '.artifacts[]? | [.source_path, .sha256] | @tsv' "$ARTIFACT_MAP_FILE" 2>/dev/null || true)

  local pack_id source_id payload_lines manifest_path version
  while IFS=$'\t' read -r pack_id source_id manifest_path version pack_payload_sha; do
    [[ -z "$pack_id" ]] && continue
    payload_lines=""
    while IFS=$'\t' read -r source_path sha; do
      [[ -z "$source_path" ]] && continue
      payload_lines+="${sha} ${source_path}"$'\n'
    done < <(yq -r ".pack_payload_digests[]? | select(.pack_id == \"$pack_id\" and .source_id == \"$source_id\") | .files[]? | [.path, .sha256] | @tsv" "$GENERATION_LOCK_FILE")
    computed_payload_sha="$(printf '%s' "$payload_lines" | ext_hash_text)"
    [[ "$computed_payload_sha" == "$pack_payload_sha" ]] && pass "payload digest current for $pack_id" || fail "payload digest stale for $pack_id"
    [[ -f "$ROOT_DIR/$manifest_path" ]] && pass "manifest path resolves for $pack_id" || fail "manifest path missing for $pack_id"
  done < <(yq -r '.pack_payload_digests[]? | [.pack_id, .source_id, .manifest_path, .version, .payload_sha256] | @tsv' "$GENERATION_LOCK_FILE" 2>/dev/null || true)

  echo "Validation summary: errors=$errors"
  if [[ $errors -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
