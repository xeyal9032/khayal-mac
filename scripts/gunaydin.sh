#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

khayal_title
facts="$("$SCRIPT_DIR/status.sh" --line 2>/dev/null || true)"
khayal_banner "$facts"

print -- "  ${KH_YL}${KH_B}hava${KH_RST}"
hava="$(curl -fsS --max-time 6 'https://wttr.in/?format=%l:+%c+%t+%h+%w' 2>/dev/null || true)"
if [[ -n "$hava" ]]; then
  print -- "  ${KH_CY}${hava}${KH_RST}"
else
  khayal_dim "  hava alınamadı (çevrimdışı)"
fi
print -- ""

print -- "  ${KH_YL}${KH_B}takvim — bugün${KH_RST}"
cal_out="$(osascript "$SCRIPT_DIR/calendar-today.applescript" 2>/dev/null || true)"
if [[ -z "$cal_out" ]]; then
  khayal_dim "  Takvim izni yok. İlk seferde Takvim uygulaması izin sorar."
  khayal_dim "  Sistem Ayarları → Gizlilik → Takvimler"
else
  print -r -- "$cal_out" | while IFS= read -r row; do
    print -- "  ${KH_GN}•${KH_RST} $row"
  done
fi
print -- ""
khayal_dim "  khayal yan yana  ·  khayal duzenle  ·  khayal ›"
print -- ""
