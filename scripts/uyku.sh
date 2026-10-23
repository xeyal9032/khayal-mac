#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

"$SCRIPT_DIR/appearance.sh" dark >/dev/null
defaults write com.apple.dock autohide -bool true
killall Dock 2>/dev/null || true
osascript -e 'set volume output volume 15' >/dev/null 2>&1 || true
khayal_ok "uyku rutini: karanlık mod, Dock gizli, ses 15"
"$SCRIPT_DIR/notify.sh" "Khayal" "Uyku rutini hazır"

if [[ "${1:-}" == "uyu" || "${1:-}" == "--uyu" ]]; then
  khayal_dim "Mac 3 sn içinde uyuyor…"
  sleep 3
  pmset sleepnow
fi
