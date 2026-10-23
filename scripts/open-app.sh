#!/bin/zsh
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: open-app.sh \"App Name\"" >&2
  exit 1
fi
open -a "$1"
echo "opened: $1"
