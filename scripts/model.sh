#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"
FILE="$HOME/.khayal/model"
mkdir -p "$HOME/.khayal"
DEFAULT='composer-2.5[fast=true]'

case "${1:-get}" in
  get)
    if [[ -s "$FILE" ]]; then
      print -- "$(cat "$FILE")"
    else
      print -- "$DEFAULT"
    fi
    ;;
  hizli|fast)
    print -- 'composer-2.5[fast=true]' > "$FILE"
    khayal_ok "model: composer-2.5 fast (az düşün, çabuk iş)"
    ;;
  guc|güç|strong)
    print -- 'composer-2.5[fast=false]' > "$FILE"
    khayal_ok "model: composer-2.5 (daha derin, daha yavaş)"
    ;;
  set)
    [[ -n "${2:-}" ]] || { print -- "khayal model set <id>"; exit 1; }
    print -- "$2" > "$FILE"
    khayal_ok "model: $2"
    ;;
  *)
    print -- "$1" > "$FILE"
    khayal_ok "model: $1"
    ;;
esac
