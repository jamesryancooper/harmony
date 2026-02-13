#!/usr/bin/env bash
# validate-service-independence.sh - Ensure core services do not reference external kit packages.

set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

errors=0

log_error() {
  echo -e "${RED}ERROR:${NC} $1"
  ((errors++)) || true
}

log_success() {
  echo -e "${GREEN}✓${NC} $1"
}

scan_path() {
  local target="$1"
  local hits
  hits="$(rg -n "packages/kits|@harmony/" "$target" || true)"
  if [[ -n "$hits" ]]; then
    log_error "Found forbidden external kit reference(s) in $target"
    echo "$hits"
  else
    log_success "No forbidden kit references in $target"
  fi
}

main() {
  scan_path "$SERVICES_DIR/manifest.yml"
  scan_path "$SERVICES_DIR/registry.yml"
  scan_path "$SERVICES_DIR/governance/guard"
  scan_path "$SERVICES_DIR/modeling/prompt"
  scan_path "$SERVICES_DIR/operations/cost"
  scan_path "$SERVICES_DIR/planning/flow"

  echo
  if [[ $errors -gt 0 ]]; then
    echo "Independence validation failed: $errors error(s)."
    exit 1
  fi

  echo "Independence validation passed: 0 errors."
}

main "$@"
