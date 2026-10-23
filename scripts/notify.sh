#!/bin/zsh
set -euo pipefail
title="${1:-Khayal}"
body="${2:-Bitti}"
osascript -e "display notification $(printf '%s' "$body" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))') with title $(printf '%s' "$title" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
