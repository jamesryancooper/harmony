#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_OCTON_DIR="$(cd -- "$SCRIPT_DIR/../../../../../" && pwd)"
OCTON_DIR="${OCTON_DIR_OVERRIDE:-$DEFAULT_OCTON_DIR}"
ROOT_DIR="${OCTON_ROOT_DIR:-$(cd -- "$OCTON_DIR/.." && pwd)}"
MANIFEST_FILE="$OCTON_DIR/octon.yml"
VERSION_FILE="$ROOT_DIR/version.txt"

errors=0
fail() { echo "[ERROR] $1"; errors=$((errors + 1)); }
pass() { echo "[OK] $1"; }

main() {
  echo "== Version Parity Validation =="

  [[ -f "$MANIFEST_FILE" ]] && pass "root manifest exists" || fail "missing root manifest"
  [[ -f "$VERSION_FILE" ]] && pass "version.txt exists" || fail "missing version.txt"

  if [[ -f "$MANIFEST_FILE" && -f "$VERSION_FILE" ]]; then
    local manifest_version txt_version
    manifest_version="$(yq -r '.versioning.harness.release_version // ""' "$MANIFEST_FILE")"
    txt_version="$(tr -d '[:space:]' < "$VERSION_FILE")"
    if [[ -n "$manifest_version" && "$manifest_version" == "$txt_version" ]]; then
      pass "version.txt matches root manifest release version ($txt_version)"
    else
      fail "version.txt and .octon/octon.yml release version diverge"
    fi
  fi

  echo "Validation summary: errors=$errors"
  [[ $errors -eq 0 ]]
}

main "$@"
