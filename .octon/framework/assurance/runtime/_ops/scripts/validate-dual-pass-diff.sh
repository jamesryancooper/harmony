#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <pass-a-dir> <pass-b-dir>" >&2
  exit 2
fi

diff -ru "$1" "$2"
