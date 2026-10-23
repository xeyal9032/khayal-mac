#!/bin/zsh
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: reveal.sh /absolute/path" >&2
  exit 1
fi
target="$1"
if [[ ! -e "$target" ]]; then
  echo "not found: $target" >&2
  exit 1
fi
open -R "$target"
echo "revealed: $target"
