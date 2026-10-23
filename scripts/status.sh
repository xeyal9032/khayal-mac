#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

batt="$(pmset -g batt 2>/dev/null || true)"
batt_pct="$(print -r -- "$batt" | grep -Eo '[0-9]+%' | head -1)"
batt_n="${batt_pct%%%}"
if print -r -- "$batt" | grep -qi 'AC Power'; then
  batt_src="şarjda"
elif print -r -- "$batt" | grep -qi 'Battery Power'; then
  batt_src="pil"
else
  batt_src="?"
fi

disk_avail="$(df -h / | awk 'NR==2 {print $4}')"
disk_usedp="$(df -h / | awk 'NR==2 {print $5}')"
disk_n="${disk_usedp%%%}"

ip=""
for iface in en0 en1 en2; do
  ip="$(ipconfig getifaddr "$iface" 2>/dev/null || true)"
  [[ -n "$ip" ]] && break
done
[[ -z "$ip" ]] && ip="offline"

vol="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || echo "?")"
muted="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null || echo "?")"
front="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || echo "?")"
host="$(scutil --get ComputerName 2>/dev/null || print -- Mac)"
osver="$(sw_vers -productVersion 2>/dev/null || print -- "?")"

if [[ "${1:-}" == "--line" ]]; then
  print -- "${batt_pct:-?} ${batt_src}  ·  ${disk_avail:-?} boş  ·  ${ip}"
  exit 0
fi

batt_col="$KH_GN"
if [[ "$batt_n" == <-> ]]; then
  if (( batt_n < 20 )); then batt_col="$KH_RD"
  elif (( batt_n < 50 )); then batt_col="$KH_YL"
  fi
fi

print -- ""
print -- "  ${KH_CY}${KH_B}durum${KH_RST}  ${KH_DIM}${host} · macOS ${osver}${KH_RST}"
khayal_hr
print -- "  ${KH_YL}Pil${KH_RST}     ${batt_col}$(khayal_bar "${batt_n:-0}" 14)${KH_RST}  ${batt_pct:-?}  ${KH_DIM}${batt_src}${KH_RST}"
print -- "  ${KH_YL}Disk${KH_RST}    ${KH_BL}$(khayal_bar "${disk_n:-0}" 14)${KH_RST}  ${disk_avail:-?} boş  ${KH_DIM}${disk_usedp:-?}${KH_RST}"
print -- "  ${KH_YL}Ağ${KH_RST}      ${ip}"
print -- "  ${KH_YL}Ses${KH_RST}     ${vol}%  ${KH_DIM}sessiz=${muted}${KH_RST}"
print -- "  ${KH_YL}Önde${KH_RST}    ${front}"
print -- ""
