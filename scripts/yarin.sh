#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

notify_only="${1:-}"

khayal_title
facts="$("$SCRIPT_DIR/status.sh" --line 2>/dev/null || true)"
if [[ "$notify_only" != "--notify" ]]; then
  khayal_banner "$facts"
fi

print -- "  ${KH_YL}${KH_B}yarın — hava${KH_RST}"
hava="$(curl -fsS --max-time 6 'https://wttr.in/?format=%l:+%c+%t+%h&T' 2>/dev/null || true)"
if [[ -n "$hava" ]]; then
  print -- "  ${KH_CY}${hava}${KH_RST}"
else
  khayal_dim "  hava alınamadı"
fi
print -- ""

print -- "  ${KH_YL}${KH_B}yarın — takvim${KH_RST}"
cal_out="$(osascript "$SCRIPT_DIR/calendar-today.applescript" 1 2>/dev/null || true)"
if [[ -z "$cal_out" ]]; then
  khayal_dim "  Takvim izni yok"
  summary="Yarın özeti: takvim izni yok"
else
  print -r -- "$cal_out" | while IFS= read -r row; do
    print -- "  ${KH_GN}•${KH_RST} $row"
  done
  summary="Yarın: $(print -r -- "$cal_out" | head -3 | tr '\n' ';')"
fi
print -- ""

if [[ "$notify_only" == "--notify" ]]; then
  "$SCRIPT_DIR/notify.sh" "Khayal — yarın" "${summary:0:180}"
fi
