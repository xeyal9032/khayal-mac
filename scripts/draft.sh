#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

app="$(print -r -- "${1:-telegram}" | tr '[:upper:]' '[:lower:]')"
shift || true
msg="${*:-}"
[[ -n "$msg" ]] || { print -- "örnek: khayal taslak telegram merhaba nasılsın"; exit 1; }

mkdir -p "$HOME/.khayal/drafts"
file="$HOME/.khayal/drafts/$(date +%Y%m%d-%H%M%S).txt"
print -r -- "$msg" > "$file"
printf '%s' "$msg" | pbcopy

case "$app" in
  telegram|tg) open -a Telegram; target="Telegram" ;;
  whatsapp|wa) open -a WhatsApp; target="WhatsApp" ;;
  mail|email) open -a Mail; target="Mail" ;;
  *) open -a Telegram; target="Telegram" ;;
esac

khayal_ok "taslak panoda ve $file"
khayal_dim "$target açık — yapıştır, gönder butonuna sen bas (ajan göndermez)"
"$SCRIPT_DIR/notify.sh" "Khayal taslak" "$target: panoya kopyalandı, sen gönder"
