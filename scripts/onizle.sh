#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"
WD="$("$SCRIPT_DIR/workdir.sh" get)"
PORT="${KHAYAL_PORT:-8787}"
PIDF="$HOME/.khayal/preview.pid"
mkdir -p "$HOME/.khayal"
cd "$WD"

if [[ "${1:-}" == "durdur" || "${1:-}" == "stop" ]]; then
  if [[ -f "$PIDF" ]]; then
    kill "$(cat "$PIDF")" 2>/dev/null || true
    rm -f "$PIDF"
  fi
  khayal_ok "önizleme kapandı"
  exit 0
fi

if [[ -f "$PIDF" ]]; then
  old="$(cat "$PIDF")"
  if kill -0 "$old" 2>/dev/null; then
    khayal_dim "zaten açık  pid $old"
    open "http://127.0.0.1:${PORT}/"
    exit 0
  fi
  rm -f "$PIDF"
fi

start_bg() {
  "$@" >/tmp/khayal-preview.log 2>&1 &
  print $! > "$PIDF"
}

if [[ -f vite.config.js || -f vite.config.ts ]] && [[ -d node_modules ]]; then
  start_bg npx --yes vite --port "$PORT" --host 127.0.0.1
elif [[ -f next.config.mjs || -f next.config.js ]] && [[ -d node_modules ]]; then
  start_bg npx --yes next dev -p "$PORT"
elif [[ -f index.php ]] && command -v php >/dev/null 2>&1; then
  start_bg php -S "127.0.0.1:${PORT}"
elif [[ -f index.js ]] && command -v node >/dev/null 2>&1; then
  start_bg env PORT="$PORT" node index.js
else
  if [[ -f package.json && ! -d node_modules ]]; then
    khayal_dim "önce: khayal paketler"
  fi
  start_bg python3 -m http.server "$PORT" --bind 127.0.0.1
fi

sleep 0.35
khayal_ok "önizleme  http://127.0.0.1:${PORT}/  ($WD)"
open "http://127.0.0.1:${PORT}/"
khayal_dim "durdur: khayal onizle durdur"
