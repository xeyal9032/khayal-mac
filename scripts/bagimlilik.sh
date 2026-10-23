#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"
WD="$("$SCRIPT_DIR/workdir.sh" get)"
cd "$WD"

did=0
if [[ -f package.json ]]; then
  if ! command -v npm >/dev/null 2>&1; then
    khayal_err "npm yok"
    exit 1
  fi
  khayal_dim "npm install  ($WD)"
  npm install
  did=1
fi
if [[ -f composer.json ]]; then
  if command -v composer >/dev/null 2>&1; then
    khayal_dim "composer install  ($WD)"
    composer install --no-interaction
    did=1
  else
    khayal_dim "composer yok — atlandı"
  fi
fi
if (( did == 0 )); then
  khayal_dim "package.json / composer.json yok"
  exit 0
fi
khayal_ok "bağımlılıklar hazır"
