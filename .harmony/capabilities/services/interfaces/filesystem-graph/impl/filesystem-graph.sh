#!/usr/bin/env bash
# filesystem-graph.sh - operation dispatcher for filesystem + graph + discovery.

set -o pipefail

CONTRACT_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
DEFAULT_STATE_DIR="$REPO_ROOT/.harmony/runtime/_ops/state/snapshots"

if ! command -v jq >/dev/null 2>&1; then
  echo '{"ok":false,"filesystem_graph_contract_version":"1.0.0","command":"unknown","result":{},"errors":["ERR_FILESYSTEM_GRAPH_INPUT_INVALID: jq is required"]}'
  exit 5
fi

emit_success() {
  local command="$1"
  local result_json="$2"
  local snapshot_id="${3:-}"

  if [[ -n "$snapshot_id" ]]; then
    jq -cn \
      --arg v "$CONTRACT_VERSION" \
      --arg c "$command" \
      --arg s "$snapshot_id" \
      --argjson r "$result_json" \
      '{ok:true,filesystem_graph_contract_version:$v,command:$c,snapshot_id:$s,result:$r}'
  else
    jq -cn \
      --arg v "$CONTRACT_VERSION" \
      --arg c "$command" \
      --argjson r "$result_json" \
      '{ok:true,filesystem_graph_contract_version:$v,command:$c,result:$r}'
  fi
}

emit_error() {
  local command="$1"
  local code="$2"
  local message="$3"
  jq -cn \
    --arg v "$CONTRACT_VERSION" \
    --arg c "$command" \
    --arg e "$code: $message" \
    '{ok:false,filesystem_graph_contract_version:$v,command:$c,result:{},errors:[$e]}'
}

validate_rel_path() {
  local rel="$1"
  if [[ "$rel" == /* ]]; then
    return 1
  fi
  if [[ "$rel" == *".."* ]]; then
    return 1
  fi
  return 0
}

stat_kind() {
  local p="$1"
  if [[ -d "$p" ]]; then
    echo "dir"
  elif [[ -f "$p" ]]; then
    echo "file"
  else
    echo "missing"
  fi
}

stat_size() {
  local p="$1"
  if [[ -f "$p" ]]; then
    wc -c < "$p" | tr -d ' '
  else
    echo 0
  fi
}

stat_mtime() {
  local p="$1"
  if stat -f %m "$p" >/dev/null 2>&1; then
    stat -f %m "$p"
  else
    stat -c %Y "$p"
  fi
}

payload_raw="$(cat)"
if [[ -z "$(echo "$payload_raw" | tr -d '[:space:]')" ]]; then
  emit_error "unknown" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "Expected JSON input on stdin."
  exit 5
fi

if ! jq -e . >/dev/null 2>&1 <<<"$payload_raw"; then
  emit_error "unknown" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "Invalid JSON payload."
  exit 5
fi

command="$(jq -r '.command // empty' <<<"$payload_raw")"
input_payload="$(jq -c '.payload // {}' <<<"$payload_raw")"
snapshot_id_arg="$(jq -r '.snapshot_id // empty' <<<"$payload_raw")"
state_dir="$(jq -r '.state_dir // empty' <<<"$payload_raw")"

if [[ -z "$state_dir" ]]; then
  state_dir="$DEFAULT_STATE_DIR"
fi

mkdir -p "$state_dir"

get_current_snapshot_id() {
  local f="$state_dir/current"
  if [[ -f "$f" ]]; then
    tr -d ' \n\r\t' < "$f"
  else
    echo ""
  fi
}

resolve_snapshot_id() {
  if [[ -n "$snapshot_id_arg" ]]; then
    echo "$snapshot_id_arg"
  else
    get_current_snapshot_id
  fi
}

resolve_snapshot_dir() {
  local sid="$1"
  echo "$state_dir/$sid"
}

load_snapshot_required() {
  local sid="$1"
  local sdir
  sdir="$(resolve_snapshot_dir "$sid")"
  if [[ -z "$sid" || ! -d "$sdir" ]]; then
    return 1
  fi
  if [[ ! -f "$sdir/manifest.json" || ! -f "$sdir/nodes.jsonl" || ! -f "$sdir/edges.jsonl" || ! -f "$sdir/files.jsonl" ]]; then
    return 1
  fi
  echo "$sdir"
}

case "$command" in
  fs.list)
    rel_path="$(jq -r '.path // "."' <<<"$input_payload")"
    limit="$(jq -r '.limit // 200' <<<"$input_payload")"

    if ! validate_rel_path "$rel_path"; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_PATH_INVALID" "Path must be relative and must not contain '..'."
      exit 4
    fi

    abs_path="$REPO_ROOT/$rel_path"
    if [[ ! -d "$abs_path" ]]; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_NOT_FOUND" "Directory not found: $rel_path"
      exit 4
    fi

    entries_json="$(
      find "$abs_path" -mindepth 1 -maxdepth 1 | LC_ALL=C sort | head -n "$limit" | while IFS= read -r item; do
        name="$(basename "$item")"
        kind="$(stat_kind "$item")"
        jq -cn --arg name "$name" --arg kind "$kind" '{name:$name,kind:$kind}'
      done | jq -s '.'
    )"

    result="$(jq -cn --arg path "$rel_path" --argjson entries "$entries_json" '{path:$path,entries:$entries}')"
    emit_success "$command" "$result"
    ;;

  fs.read)
    rel_path="$(jq -r '.path // empty' <<<"$input_payload")"
    max_bytes="$(jq -r '.max_bytes // 16384' <<<"$input_payload")"

    if [[ -z "$rel_path" ]]; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "payload.path is required."
      exit 5
    fi

    if ! validate_rel_path "$rel_path"; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_PATH_INVALID" "Path must be relative and must not contain '..'."
      exit 4
    fi

    abs_path="$REPO_ROOT/$rel_path"
    if [[ ! -f "$abs_path" ]]; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_NOT_FOUND" "File not found: $rel_path"
      exit 4
    fi

    total_size="$(stat_size "$abs_path")"
    content="$(head -c "$max_bytes" "$abs_path")"
    truncated="false"
    if [[ "$total_size" -gt "$max_bytes" ]]; then
      truncated="true"
    fi

    result="$(jq -cn --arg path "$rel_path" --arg content "$content" --argjson total_size "$total_size" --argjson max_bytes "$max_bytes" --argjson truncated "$truncated" '{path:$path,content:$content,total_size:$total_size,max_bytes:$max_bytes,truncated:$truncated}')"
    emit_success "$command" "$result"
    ;;

  fs.stat)
    rel_path="$(jq -r '.path // empty' <<<"$input_payload")"

    if [[ -z "$rel_path" ]]; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "payload.path is required."
      exit 5
    fi

    if ! validate_rel_path "$rel_path"; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_PATH_INVALID" "Path must be relative and must not contain '..'."
      exit 4
    fi

    abs_path="$REPO_ROOT/$rel_path"
    if [[ ! -e "$abs_path" ]]; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_NOT_FOUND" "Path not found: $rel_path"
      exit 4
    fi

    kind="$(stat_kind "$abs_path")"
    size="$(stat_size "$abs_path")"
    mtime="$(stat_mtime "$abs_path")"

    result="$(jq -cn --arg path "$rel_path" --arg kind "$kind" --argjson size_bytes "$size" --argjson modified_epoch "$mtime" '{path:$path,kind:$kind,size_bytes:$size_bytes,modified_epoch:$modified_epoch}')"
    emit_success "$command" "$result"
    ;;

  fs.search)
    pattern="$(jq -r '.pattern // empty' <<<"$input_payload")"
    rel_path="$(jq -r '.path // "."' <<<"$input_payload")"
    limit="$(jq -r '.limit // 50' <<<"$input_payload")"

    if [[ -z "$pattern" ]]; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "payload.pattern is required."
      exit 5
    fi

    if ! validate_rel_path "$rel_path"; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_PATH_INVALID" "Path must be relative and must not contain '..'."
      exit 4
    fi

    abs_path="$REPO_ROOT/$rel_path"
    if [[ ! -e "$abs_path" ]]; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_NOT_FOUND" "Search path not found: $rel_path"
      exit 4
    fi

    if command -v rg >/dev/null 2>&1; then
      hits_raw="$(rg -n --no-heading -i --fixed-strings "$pattern" "$abs_path" | head -n "$limit" || true)"
    else
      hits_raw="$(grep -Rin --fixed-strings "$pattern" "$abs_path" | head -n "$limit" || true)"
    fi

    hits_json="$(
      if [[ -n "$hits_raw" ]]; then
        while IFS= read -r line; do
          [[ -z "$line" ]] && continue
          file_part="${line%%:*}"
          rest="${line#*:}"
          line_no="${rest%%:*}"
          snippet="${rest#*:}"
          rel_file="${file_part#$REPO_ROOT/}"
          jq -cn --arg path "$rel_file" --argjson line "$line_no" --arg snippet "$snippet" '{path:$path,line:$line,snippet:$snippet}'
        done <<< "$hits_raw" | jq -s '.'
      else
        echo '[]'
      fi
    )"

    result="$(jq -cn --arg pattern "$pattern" --arg path "$rel_path" --argjson hits "$hits_json" '{pattern:$pattern,path:$path,hits:$hits}')"
    emit_success "$command" "$result"
    ;;

  snapshot.build)
    root="$(jq -r '.root // "."' <<<"$input_payload")"
    set_current="$(jq -r '.set_current // true | if . then "true" else "false" end' <<<"$input_payload")"

    build_out="$(bash "$SCRIPT_DIR/snapshot-build.sh" --root "$root" --state-dir "$state_dir" --set-current "$set_current")"
    if ! jq -e '.ok == true' >/dev/null 2>&1 <<<"$build_out"; then
      echo "$build_out"
      exit 4
    fi
    sid="$(jq -r '.snapshot_id' <<<"$build_out")"
    emit_success "$command" "$build_out" "$sid"
    ;;

  snapshot.diff)
    base="$(jq -r '.base // empty' <<<"$input_payload")"
    head="$(jq -r '.head // empty' <<<"$input_payload")"

    if [[ -z "$head" ]]; then
      head="$(get_current_snapshot_id)"
    fi

    diff_out="$(bash "$SCRIPT_DIR/snapshot-diff.sh" --base "$base" --head "$head" --state-dir "$state_dir")"
    if ! jq -e '.ok == true' >/dev/null 2>&1 <<<"$diff_out"; then
      echo "$diff_out"
      exit 4
    fi
    emit_success "$command" "$diff_out"
    ;;

  snapshot.get-current)
    sid="$(get_current_snapshot_id)"
    if [[ -z "$sid" ]]; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_NOT_FOUND" "No active snapshot pointer found."
      exit 4
    fi

    sdir="$(resolve_snapshot_dir "$sid")"
    manifest="{}"
    if [[ -f "$sdir/manifest.json" ]]; then
      manifest="$(cat "$sdir/manifest.json")"
    fi

    result="$(jq -cn --arg snapshot_id "$sid" --arg snapshot_dir "$sdir" --argjson manifest "$manifest" '{snapshot_id:$snapshot_id,snapshot_dir:$snapshot_dir,manifest:$manifest}')"
    emit_success "$command" "$result" "$sid"
    ;;

  kg.get-node|kg.neighbors|kg.traverse|kg.resolve-to-file|discover.start|discover.expand|discover.explain|discover.resolve)
    sid="$(resolve_snapshot_id)"
    if [[ -z "$sid" ]]; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_NOT_FOUND" "No snapshot_id provided and no active snapshot pointer exists."
      exit 4
    fi

    sdir="$(load_snapshot_required "$sid" || true)"
    if [[ -z "$sdir" ]]; then
      emit_error "$command" "ERR_FILESYSTEM_GRAPH_SNAPSHOT_INVALID" "Snapshot artifacts missing or invalid for: $sid"
      exit 4
    fi

    case "$command" in
      kg.get-node)
        node_id="$(jq -r '.node_id // empty' <<<"$input_payload")"
        if [[ -z "$node_id" ]]; then
          rel_path="$(jq -r '.path // empty' <<<"$input_payload")"
          if [[ -z "$rel_path" ]]; then
            emit_error "$command" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "payload.node_id or payload.path is required."
            exit 5
          fi
          node_id="file:$rel_path"
        fi

        node_json="$(jq -c --arg id "$node_id" 'select(.node_id == $id)' "$sdir/nodes.jsonl" | head -n 1)"
        if [[ -z "$node_json" ]]; then
          emit_error "$command" "ERR_FILESYSTEM_GRAPH_NOT_FOUND" "Node not found: $node_id"
          exit 4
        fi

        result="$(jq -cn --argjson node "$node_json" '{node:$node}')"
        emit_success "$command" "$result" "$sid"
        ;;

      kg.neighbors)
        node_id="$(jq -r '.node_id // empty' <<<"$input_payload")"
        edge_type="$(jq -r '.edge_type // ""' <<<"$input_payload")"
        direction="$(jq -r '.direction // "out"' <<<"$input_payload")"
        limit="$(jq -r '.limit // 50' <<<"$input_payload")"

        if [[ -z "$node_id" ]]; then
          emit_error "$command" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "payload.node_id is required."
          exit 5
        fi

        edges_json="$(jq -s -c --arg id "$node_id" --arg edge_type "$edge_type" --arg direction "$direction" --argjson limit "$limit" '
          [ .[]
            | select((($direction == "in" and .dst == $id) or ($direction != "in" and .src == $id))
                     and ($edge_type == "" or .type == $edge_type))
          ]
          | .[:$limit]
        ' "$sdir/edges.jsonl")"

        neighbor_ids="$(jq -cn --argjson edges "$edges_json" --arg direction "$direction" '
          $edges
          | map(if $direction == "in" then .src else .dst end)
          | unique
        ')"

        neighbor_nodes="$(jq -s -c --argjson ids "$neighbor_ids" '[ .[] | (.node_id as $nid | select(($ids | index($nid)) != null)) ]' "$sdir/nodes.jsonl")"

        result="$(jq -cn --arg node_id "$node_id" --argjson edges "$edges_json" --argjson nodes "$neighbor_nodes" '{node_id:$node_id,edges:$edges,nodes:$nodes}')"
        emit_success "$command" "$result" "$sid"
        ;;

      kg.traverse)
        start_node_id="$(jq -r '.start_node_id // empty' <<<"$input_payload")"
        depth="$(jq -r '.depth // 2' <<<"$input_payload")"
        edge_type="$(jq -r '.edge_type // ""' <<<"$input_payload")"

        if [[ -z "$start_node_id" ]]; then
          emit_error "$command" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "payload.start_node_id is required."
          exit 5
        fi

        edges_all="$(jq -s -c '.' "$sdir/edges.jsonl")"
        frontier='[]'
        visited='[]'
        traversed='[]'

        frontier="$(jq -cn --arg id "$start_node_id" '[ $id ]')"
        visited="$frontier"

        i=0
        while [[ "$i" -lt "$depth" ]]; do
          step_edges="$(jq -cn --argjson edges "$edges_all" --argjson frontier "$frontier" --arg edge_type "$edge_type" '
            $edges
            | map(. as $edge | select((($frontier | index($edge.src)) != null) and ($edge_type == "" or $edge.type == $edge_type)))
          ')"

          next_frontier="$(jq -cn --argjson step "$step_edges" --argjson visited "$visited" '
            $step
            | map(.dst)
            | unique
            | map(select(($visited | index(.)) == null))
          ')"

          traversed="$(jq -cn --argjson a "$traversed" --argjson b "$step_edges" '$a + $b | unique_by(.src,.type,.dst)')"
          visited="$(jq -cn --argjson a "$visited" --argjson b "$next_frontier" '$a + $b | unique')"
          frontier="$next_frontier"

          if [[ "$(jq 'length' <<<"$frontier")" == "0" ]]; then
            break
          fi

          i=$((i + 1))
        done

        visited_nodes="$(jq -s -c --argjson ids "$visited" '[ .[] | (.node_id as $nid | select(($ids | index($nid)) != null)) ]' "$sdir/nodes.jsonl")"

        result="$(jq -cn --arg start_node_id "$start_node_id" --argjson depth "$depth" --argjson visited_node_ids "$visited" --argjson nodes "$visited_nodes" --argjson edges "$traversed" '{start_node_id:$start_node_id,depth:$depth,visited_node_ids:$visited_node_ids,nodes:$nodes,edges:$edges}')"
        emit_success "$command" "$result" "$sid"
        ;;

      kg.resolve-to-file|discover.resolve)
        node_id="$(jq -r '.node_id // empty' <<<"$input_payload")"
        if [[ -z "$node_id" ]]; then
          emit_error "$command" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "payload.node_id is required."
          exit 5
        fi

        node_json="$(jq -c --arg id "$node_id" 'select(.node_id == $id)' "$sdir/nodes.jsonl" | head -n 1)"
        if [[ -z "$node_json" ]]; then
          emit_error "$command" "ERR_FILESYSTEM_GRAPH_NOT_FOUND" "Node not found: $node_id"
          exit 4
        fi

        node_type="$(jq -r '.type' <<<"$node_json")"
        node_path="$(jq -r '.path // empty' <<<"$node_json")"

        if [[ "$node_type" != "file" && "$node_type" != "dir" ]]; then
          emit_error "$command" "ERR_FILESYSTEM_GRAPH_NOT_FOUND" "Node is not resolvable to a filesystem path: $node_id"
          exit 4
        fi

        abs_path="$REPO_ROOT/$node_path"
        result="$(jq -cn --arg node_id "$node_id" --arg type "$node_type" --arg path "$node_path" --arg abs_path "$abs_path" '{node_id:$node_id,type:$type,path:$path,absolute_path:$abs_path,exists:(($abs_path | length) > 0)}')"
        emit_success "$command" "$result" "$sid"
        ;;

      discover.start)
        query="$(jq -r '.query // empty' <<<"$input_payload")"
        limit="$(jq -r '.limit // 20' <<<"$input_payload")"

        if [[ -z "$query" ]]; then
          emit_error "$command" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "payload.query is required."
          exit 5
        fi

        query_lower="$(echo "$query" | tr '[:upper:]' '[:lower:]')"

        path_candidates="$(jq -s -c --arg q "$query_lower" --argjson limit "$limit" '
          [ .[]
            | .path as $path
            | select(($path | ascii_downcase | contains($q)))
            | {node_id:("file:" + $path), path:$path, score:1.0, reason:"path-match"}
          ]
          | .[:$limit]
        ' "$sdir/files.jsonl")"

        content_candidates='[]'
        if command -v rg >/dev/null 2>&1; then
          raw="$(rg -n -i --no-heading --fixed-strings "$query" "$REPO_ROOT" | head -n "$limit" || true)"
          if [[ -n "$raw" ]]; then
            content_candidates="$(
              while IFS= read -r line; do
                [[ -z "$line" ]] && continue
                file_part="${line%%:*}"
                rel_path="${file_part#$REPO_ROOT/}"
                jq -cn --arg node_id "file:$rel_path" --arg path "$rel_path" '{node_id:$node_id,path:$path,score:0.7,reason:"content-match"}'
              done <<< "$raw" | jq -s 'unique_by(.node_id)'
            )"
          fi
        fi

        candidates="$(jq -cn --argjson a "$path_candidates" --argjson b "$content_candidates" --argjson limit "$limit" '
          ($a + $b)
          | group_by(.node_id)
          | map(sort_by(.score) | last)
          | sort_by(-.score, .path)
          | .[:$limit]
        ')"

        frontier_ids="$(jq -cn --argjson c "$candidates" '$c | map(.node_id)')"

        result="$(jq -cn --arg query "$query" --argjson candidates "$candidates" --argjson frontier_ids "$frontier_ids" '{query:$query,candidates:$candidates,frontier_node_ids:$frontier_ids}')"
        emit_success "$command" "$result" "$sid"
        ;;

      discover.expand)
        node_ids="$(jq -c '.node_ids // []' <<<"$input_payload")"
        limit="$(jq -r '.limit // 100' <<<"$input_payload")"

        if [[ "$(jq 'length' <<<"$node_ids")" == "0" ]]; then
          emit_error "$command" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "payload.node_ids must be a non-empty array."
          exit 5
        fi

        edges_json="$(jq -s -c --argjson ids "$node_ids" --argjson limit "$limit" '
          [ .[] | (.src as $src | select(($ids | index($src)) != null)) ] | .[:$limit]
        ' "$sdir/edges.jsonl")"

        next_ids="$(jq -cn --argjson edges "$edges_json" '$edges | map(.dst) | unique')"
        nodes_json="$(jq -s -c --argjson ids "$next_ids" '[ .[] | (.node_id as $nid | select(($ids | index($nid)) != null)) ]' "$sdir/nodes.jsonl")"

        result="$(jq -cn --argjson frontier "$node_ids" --argjson edges "$edges_json" --argjson next_node_ids "$next_ids" --argjson nodes "$nodes_json" '{frontier_node_ids:$frontier,edges:$edges,next_node_ids:$next_node_ids,nodes:$nodes}')"
        emit_success "$command" "$result" "$sid"
        ;;

      discover.explain)
        query="$(jq -r '.query // ""' <<<"$input_payload")"
        candidate_node_ids="$(jq -c '.candidate_node_ids // []' <<<"$input_payload")"

        if [[ "$(jq 'length' <<<"$candidate_node_ids")" == "0" ]]; then
          emit_error "$command" "ERR_FILESYSTEM_GRAPH_INPUT_INVALID" "payload.candidate_node_ids must be a non-empty array."
          exit 5
        fi

        nodes_json="$(jq -s -c --argjson ids "$candidate_node_ids" '[ .[] | (.node_id as $nid | select(($ids | index($nid)) != null)) ]' "$sdir/nodes.jsonl")"
        manifest_json="$(cat "$sdir/manifest.json")"

        explanations="$(jq -cn --arg query "$query" --argjson nodes "$nodes_json" --argjson manifest "$manifest_json" '
          $nodes
          | map({
              node_id: .node_id,
              path: (.path // ""),
              reason: (if $query == "" then "candidate" else "query-aligned" end),
              provenance: {
                snapshot_id: $manifest.snapshot_id,
                input_fingerprint: $manifest.input_fingerprint,
                sha256: (.sha256 // null)
              }
            })
        ')"

        result="$(jq -cn --arg query "$query" --argjson explanations "$explanations" '{query:$query,explanations:$explanations}')"
        emit_success "$command" "$result" "$sid"
        ;;
    esac
    ;;

  *)
    emit_error "${command:-unknown}" "ERR_FILESYSTEM_GRAPH_OPERATION_UNSUPPORTED" "Unsupported command: ${command:-<empty>}"
    exit 5
    ;;
esac
