#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

watch="${1:-}"

batt="$(pmset -g batt 2>/dev/null || true)"
pct="$(print -r -- "$batt" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
pct="${pct:-100}"
ac=0
print -r -- "$batt" | grep -qi 'AC Power' && ac=1

load="$(sysctl -n vm.loadavg 2>/dev/null | awk '{print $2}')"
cpu="$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s}')"

ping_ms="?"
ok_net=1
if ping_out="$(ping -c 2 -W 1000 1.1.1.1 2>/dev/null)"; then
  ping_ms="$(print -r -- "$ping_out" | awk -F'/' '/round-trip|min\/avg/{print $5; exit}')"
  ping_ms="${ping_ms%.*}"
  ping_ms="${ping_ms:-0}"
else
  ok_net=0
  ping_ms="yok"
fi

alerts=()
if (( pct <= 20 && ac == 0 )); then alerts+=("pil %${pct} — şarj et"); fi
if (( cpu >= 180 )); then alerts+=("CPU yüksek (${cpu}%)"); fi
if [[ "$ok_net" -eq 0 ]]; then
  alerts+=("ağ yok")
elif [[ "$ping_ms" != "yok" && "$ping_ms" == <-> && "$ping_ms" -ge 180 ]]; then
  alerts+=("Wi-Fi zayıf (${ping_ms} ms)")
fi

if [[ "$watch" == "--watch" ]]; then
  if (( ${#alerts[@]} > 0 )); then
    "$SCRIPT_DIR/notify.sh" "Khayal sağlık" "${(j:, :)alerts}"
  fi
  exit 0
fi

print -- "  ${KH_YL}${KH_B}sağlık${KH_RST}"
print -- "  Pil   %${pct}  ac=$ac"
print -- "  CPU   ${cpu}%   load $load"
print -- "  Ağ    ${ping_ms} ms"
if (( ${#alerts[@]} > 0 )); then
  for a in "${alerts[@]}"; do
    print -- "  ${KH_RD}!${KH_RST} $a"
  done
else
  khayal_ok "sorun yok"
fi
