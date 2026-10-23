#!/bin/zsh
set -euo pipefail
out="${1:-$HOME/Desktop/khayal-$(date +%Y%m%d-%H%M%S).png}"
screencapture -x "$out"
print -- "$out"
