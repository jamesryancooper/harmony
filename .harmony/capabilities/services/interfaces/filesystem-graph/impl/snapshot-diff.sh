#!/usr/bin/env bash
# snapshot-diff.sh - compare two filesystem-graph snapshots.

set -o pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo '{"ok":false,"error":{"code":"ERR_FILESYSTEM_GRAPH_INPUT_INVALID","message":"jq is required."}}'
  exit 5
fi

base=""
head=""
state_dir=".harmony/runtime/_ops/state/snapshots"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      base="${2:-}"
      shift 2
      ;;
    --head)
      head="${2:-}"
      shift 2
      ;;
    --state-dir)
      state_dir="${2:-.harmony/runtime/_ops/state/snapshots}"
      shift 2
      ;;
    *)
      echo "{\"ok\":false,\"error\":{\"code\":\"ERR_FILESYSTEM_GRAPH_INPUT_INVALID\",\"message\":\"Unknown argument: $1\"}}"
      exit 5
      ;;
  esac
done

if [[ -z "$base" || -z "$head" ]]; then
  echo '{"ok":false,"error":{"code":"ERR_FILESYSTEM_GRAPH_INPUT_INVALID","message":"Both --base and --head are required."}}'
  exit 5
fi

state_abs="$(cd "$state_dir" && pwd)"

resolve_snapshot_dir() {
  local value="$1"
  if [[ -d "$value" ]]; then
    cd "$value" && pwd
    return 0
  fi
  if [[ -d "$state_abs/$value" ]]; then
    cd "$state_abs/$value" && pwd
    return 0
  fi
  return 1
}

if ! base_dir="$(resolve_snapshot_dir "$base")"; then
  echo "{\"ok\":false,\"error\":{\"code\":\"ERR_FILESYSTEM_GRAPH_NOT_FOUND\",\"message\":\"Base snapshot not found: $base\"}}"
  exit 4
fi

if ! head_dir="$(resolve_snapshot_dir "$head")"; then
  echo "{\"ok\":false,\"error\":{\"code\":\"ERR_FILESYSTEM_GRAPH_NOT_FOUND\",\"message\":\"Head snapshot not found: $head\"}}"
  exit 4
fi

base_files="$base_dir/files.jsonl"
head_files="$head_dir/files.jsonl"

if [[ ! -f "$base_files" || ! -f "$head_files" ]]; then
  echo '{"ok":false,"error":{"code":"ERR_FILESYSTEM_GRAPH_SNAPSHOT_INVALID","message":"files.jsonl missing in one or both snapshots."}}'
  exit 4
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/harmony-fsgraph-diff.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

base_tsv="$tmp_dir/base.tsv"
head_tsv="$tmp_dir/head.tsv"
diff_tsv="$tmp_dir/diff.tsv"

jq -r '[.path,.sha256] | @tsv' "$base_files" | LC_ALL=C sort -u > "$base_tsv"
jq -r '[.path,.sha256] | @tsv' "$head_files" | LC_ALL=C sort -u > "$head_tsv"

awk -F'\t' '
  NR==FNR { base[$1]=$2; next }
  { head[$1]=$2 }
  END {
    for (k in head) {
      if (!(k in base)) {
        print "added\t" k "\t" head[k]
      } else if (base[k] != head[k]) {
        print "changed\t" k "\t" base[k] "\t" head[k]
      }
    }
    for (k in base) {
      if (!(k in head)) {
        print "removed\t" k "\t" base[k]
      }
    }
  }
' "$base_tsv" "$head_tsv" | LC_ALL=C sort > "$diff_tsv"

details_json="$(jq -Rn '
  [inputs | select(length > 0) | split("\t")] as $rows |
  {
    added:   [ $rows[] | select(.[0] == "added")   | {path: .[1], sha256: .[2]} ],
    removed: [ $rows[] | select(.[0] == "removed") | {path: .[1], sha256: .[2]} ],
    changed: [ $rows[] | select(.[0] == "changed") | {path: .[1], base_sha256: .[2], head_sha256: .[3]} ]
  }
' < "$diff_tsv")"

jq -cn \
  --arg base "$(basename "$base_dir")" \
  --arg head "$(basename "$head_dir")" \
  --argjson details "$details_json" \
  '{ok:true,base_snapshot:$base,head_snapshot:$head,summary:{added:($details.added|length),removed:($details.removed|length),changed:($details.changed|length)},details:$details}'
