#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../../../../../../.." && pwd)"
PACK_ID="octon-pack-scaffolder"
SOURCE_ID="bundled-first-party"
DISPATCHER_ID="octon-pack-scaffolder"
CATALOG="$REPO_ROOT/.octon/generated/effective/extensions/catalog.effective.yml"
ROUTING="$REPO_ROOT/.octon/generated/effective/capabilities/routing.effective.yml"
ARTIFACT_MAP="$REPO_ROOT/.octon/generated/effective/capabilities/artifact-map.yml"

pass_count=0
fail_count=0

pass() { echo "PASS: $1"; pass_count=$((pass_count + 1)); }
fail() { echo "FAIL: $1" >&2; fail_count=$((fail_count + 1)); }

assert_file() {
  local path="$1" label="$2"
  if [[ -f "$path" ]]; then
    pass "$label"
  else
    fail "$label"
  fi
}

assert_route() {
  local target="$1" expected_route="$2"
  local output route_id
  output="$(
    bash "$REPO_ROOT/.octon/framework/orchestration/runtime/_ops/scripts/resolve-extension-route.sh" \
      --pack-id "$PACK_ID" \
      --source-id "$SOURCE_ID" \
      --dispatcher-id "$DISPATCHER_ID" \
      --inputs-json "{\"target\":\"$target\",\"pack_id\":\"demo-pack\"}"
  )"
  route_id="$(jq -r '.selected_route_id // ""' <<<"$output")"
  if [[ "$route_id" == "$expected_route" ]]; then
    pass "route resolves for target=$target"
  else
    fail "route resolves for target=$target"
  fi
}

assert_host_projection() {
  local host="$1" kind="$2" name="$3" path
  if [[ "$kind" == "command" ]]; then
    path="$REPO_ROOT/.${host}/commands/${name}.md"
  else
    path="$REPO_ROOT/.${host}/skills/${name}/SKILL.md"
  fi
  assert_file "$path" "host projection exists: $host/$kind/$name"
}

main() {
  assert_file "$CATALOG" "extension catalog exists"
  assert_file "$ROUTING" "capability routing exists"
  assert_file "$ARTIFACT_MAP" "capability artifact map exists"

  if yq -e ".published_active_packs[]? | select(.pack_id == \"$PACK_ID\" and .source_id == \"$SOURCE_ID\")" "$CATALOG" >/dev/null 2>&1; then
    pass "pack is published active"
  else
    fail "pack is published active"
  fi

  if yq -e ".packs[]? | select(.pack_id == \"$PACK_ID\" and .source_id == \"$SOURCE_ID\") | .route_dispatchers[]? | select(.dispatcher_id == \"$DISPATCHER_ID\")" "$CATALOG" >/dev/null 2>&1; then
    pass "dispatcher published into extension catalog"
  else
    fail "dispatcher published into extension catalog"
  fi

  assert_route "pack" "create-pack"
  assert_route "prompt-bundle" "create-prompt-bundle"
  assert_route "skill" "create-skill"
  assert_route "command" "create-command"
  assert_route "context-doc" "create-context-doc"
  assert_route "validation-fixture" "create-validation-fixture"

  local host
  for host in claude cursor codex; do
    assert_host_projection "$host" command "octon-pack-scaffolder"
    assert_host_projection "$host" command "octon-pack-scaffolder-create-pack"
    assert_host_projection "$host" skill "octon-pack-scaffolder"
    assert_host_projection "$host" skill "octon-pack-scaffolder-create-pack"
  done

  if yq -e ".packs[]? | select(.pack_id == \"$PACK_ID\" and .source_id == \"$SOURCE_ID\") | .routing_exports.commands[]? | select(.capability_id == \"octon-pack-scaffolder\") | .projection_source_path == \".octon/generated/effective/extensions/published/octon-pack-scaffolder/bundled-first-party/commands/octon-pack-scaffolder.md\"" "$CATALOG" >/dev/null 2>&1; then
    pass "catalog references compiled command projection"
  else
    fail "catalog references compiled command projection"
  fi

  if yq -e ".packs[]? | select(.pack_id == \"$PACK_ID\" and .source_id == \"$SOURCE_ID\") | .routing_exports.skills[]? | select(.capability_id == \"octon-pack-scaffolder\") | .projection_source_path == \".octon/generated/effective/extensions/published/octon-pack-scaffolder/bundled-first-party/skills/octon-pack-scaffolder\"" "$CATALOG" >/dev/null 2>&1; then
    pass "catalog references compiled skill projection"
  else
    fail "catalog references compiled skill projection"
  fi

  echo "Passed: $pass_count"
  echo "Failed: $fail_count"
  if [[ $fail_count -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
