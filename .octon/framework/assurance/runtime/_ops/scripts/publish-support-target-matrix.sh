#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/publication-wrapper-common.sh"
run_publication_wrapper support-target-matrix
