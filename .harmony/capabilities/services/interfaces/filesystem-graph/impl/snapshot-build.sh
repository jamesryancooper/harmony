#!/usr/bin/env bash
# snapshot-build.sh - deterministic filesystem snapshot artifact builder.

set -o pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo '{"ok":false,"error":{"code":"ERR_FILESYSTEM_GRAPH_INPUT_INVALID","message":"jq is required."}}'
  exit 5
fi

root="."
state_dir=".harmony/runtime/_ops/state/snapshots"
set_current="true"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)
      root="${2:-.}"
      shift 2
      ;;
    --state-dir)
      state_dir="${2:-.harmony/runtime/_ops/state/snapshots}"
      shift 2
      ;;
    --set-current)
      set_current="${2:-true}"
      shift 2
      ;;
    *)
      echo "{\"ok\":false,\"error\":{\"code\":\"ERR_FILESYSTEM_GRAPH_INPUT_INVALID\",\"message\":\"Unknown argument: $1\"}}"
      exit 5
      ;;
  esac
done

if [[ ! -d "$root" ]]; then
  echo "{\"ok\":false,\"error\":{\"code\":\"ERR_FILESYSTEM_GRAPH_PATH_INVALID\",\"message\":\"Root path not found: $root\"}}"
  exit 4
fi

root_abs="$(cd "$root" && pwd)"
mkdir -p "$state_dir"
state_abs="$(cd "$state_dir" && pwd)"

if command -v mktemp >/dev/null 2>&1; then
  tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/harmony-fsgraph-build.XXXXXX")"
else
  tmp_dir="/tmp/harmony-fsgraph-build.$$"
  mkdir -p "$tmp_dir"
fi

cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

file_list="$tmp_dir/file-list.txt"
seed_tsv="$tmp_dir/seed.tsv"
files_jsonl="$tmp_dir/files.jsonl"
nodes_jsonl="$tmp_dir/nodes.jsonl"
edges_jsonl="$tmp_dir/edges.jsonl"
dirs_txt="$tmp_dir/dirs.txt"

: > "$seed_tsv"
: > "$files_jsonl"
: > "$nodes_jsonl"
: > "$edges_jsonl"
: > "$dirs_txt"

skip_snapshots="$root_abs/.harmony/runtime/_ops/state/snapshots"

find "$root_abs" \
  \( -path "$root_abs/.git" -o -path "$skip_snapshots" -o -path "$state_abs" \) -prune -o \
  -type f -print | LC_ALL=C sort > "$file_list"

if [[ ! -s "$file_list" ]]; then
  echo '{"ok":false,"error":{"code":"ERR_FILESYSTEM_GRAPH_NOT_FOUND","message":"No files discovered for snapshot."}}'
  exit 4
fi

stat_mtime() {
  local f="$1"
  if stat -f %m "$f" >/dev/null 2>&1; then
    stat -f %m "$f"
  else
    stat -c %Y "$f"
  fi
}

while IFS= read -r abs_file; do
  rel="${abs_file#$root_abs/}"
  sha="$(shasum -a 256 "$abs_file" | awk '{print $1}')"
  size="$(wc -c < "$abs_file" | tr -d ' ')"
  mtime="$(stat_mtime "$abs_file")"

  printf '%s\t%s\t%s\t%s\n' "$rel" "$sha" "$size" "$mtime" >> "$seed_tsv"

  jq -cn \
    --arg path "$rel" \
    --arg sha256 "$sha" \
    --argjson size_bytes "$size" \
    --argjson modified_epoch "$mtime" \
    '{path:$path,sha256:$sha256,size_bytes:$size_bytes,modified_epoch:$modified_epoch}' >> "$files_jsonl"

  jq -cn \
    --arg node_id "file:$rel" \
    --arg path "$rel" \
    --arg sha256 "$sha" \
    '{node_id:$node_id,type:"file",path:$path,sha256:$sha256}' >> "$nodes_jsonl"

  dir_path="$(dirname "$rel")"
  printf '%s\n' "$dir_path" >> "$dirs_txt"

  jq -cn \
    --arg src "dir:$dir_path" \
    --arg dst "file:$rel" \
    '{src:$src,dst:$dst,type:"CONTAINS"}' >> "$edges_jsonl"

done < "$file_list"

while IFS= read -r dir_path; do
  d="$dir_path"
  while true; do
    printf '%s\n' "$d" >> "$dirs_txt"
    [[ "$d" == "." ]] && break
    d="$(dirname "$d")"
  done
done < <(awk -F'\t' '{print $1}' "$seed_tsv" | xargs -n1 dirname 2>/dev/null || true)

LC_ALL=C sort -u "$dirs_txt" > "$tmp_dir/dirs-unique.txt"

while IFS= read -r dir_path; do
  [[ -z "$dir_path" ]] && continue
  jq -cn \
    --arg node_id "dir:$dir_path" \
    --arg path "$dir_path" \
    '{node_id:$node_id,type:"dir",path:$path}' >> "$nodes_jsonl"

  if [[ "$dir_path" != "." ]]; then
    parent="$(dirname "$dir_path")"
    jq -cn \
      --arg src "dir:$parent" \
      --arg dst "dir:$dir_path" \
      '{src:$src,dst:$dst,type:"CONTAINS"}' >> "$edges_jsonl"
  fi
done < "$tmp_dir/dirs-unique.txt"

LC_ALL=C sort -u "$files_jsonl" -o "$files_jsonl"
LC_ALL=C sort -u "$nodes_jsonl" -o "$nodes_jsonl"
LC_ALL=C sort -u "$edges_jsonl" -o "$edges_jsonl"
LC_ALL=C sort -u "$seed_tsv" -o "$seed_tsv"

fingerprint="$(shasum -a 256 "$seed_tsv" | awk '{print $1}')"
snapshot_id="snap-${fingerprint:0:16}"
snapshot_dir="$state_abs/$snapshot_id"

mkdir -p "$snapshot_dir"
cp "$files_jsonl" "$snapshot_dir/files.jsonl"
cp "$nodes_jsonl" "$snapshot_dir/nodes.jsonl"
cp "$edges_jsonl" "$snapshot_dir/edges.jsonl"

file_count="$(wc -l < "$files_jsonl" | tr -d ' ')"
node_count="$(wc -l < "$nodes_jsonl" | tr -d ' ')"
edge_count="$(wc -l < "$edges_jsonl" | tr -d ' ')"

manifest_path="$snapshot_dir/manifest.json"
created_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

jq -cn \
  --arg snapshot_id "$snapshot_id" \
  --arg root "$root_abs" \
  --arg input_fingerprint "$fingerprint" \
  --arg created_at "$created_at" \
  --argjson files "$file_count" \
  --argjson nodes "$node_count" \
  --argjson edges "$edge_count" \
  '{snapshot_id:$snapshot_id,root:$root,input_fingerprint:$input_fingerprint,created_at:$created_at,counts:{files:$files,nodes:$nodes,edges:$edges}}' > "$manifest_path"

if [[ "$set_current" == "true" ]]; then
  printf '%s\n' "$snapshot_id" > "$state_abs/current"
fi

jq -cn \
  --arg snapshot_id "$snapshot_id" \
  --arg snapshot_dir "$snapshot_dir" \
  --arg manifest "$manifest_path" \
  --argjson files "$file_count" \
  --argjson nodes "$node_count" \
  --argjson edges "$edge_count" \
  --arg set_current "$set_current" \
  '{ok:true,snapshot_id:$snapshot_id,snapshot_dir:$snapshot_dir,manifest:$manifest,counts:{files:$files,nodes:$nodes,edges:$edges},set_current:($set_current=="true")}'
