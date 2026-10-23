#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
ROOT="${SCRIPT_DIR:h}"
source "$SCRIPT_DIR/ui.sh"

if [[ ! -d "$ROOT/.git" ]]; then
  khayal_err "git repo yok — git clone https://github.com/xeyal9032/khayal-mac.git $ROOT"
  exit 1
fi

khayal_dim "çekiliyor: github.com/xeyal9032/khayal-mac"
if git -C "$ROOT" pull --ff-only origin main; then
  chmod +x "$ROOT/scripts/"* 2>/dev/null || true
  mkdir -p "$HOME/.local/bin"
  ln -sfn "$ROOT/scripts/khayal" "$HOME/.local/bin/khayal"
  if [[ -f "$ROOT/scripts/completions/_khayal" ]]; then
    mkdir -p "$HOME/.zsh/completions"
    cp "$ROOT/scripts/completions/_khayal" "$HOME/.zsh/completions/_khayal"
  fi
  khayal_ok "güncel  v$(khayal_version)"
else
  khayal_err "çekilemedi — ağ veya çakışan değişiklik"
  exit 1
fi
