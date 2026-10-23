#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

print -- "  ${KH_YL}${KH_B}CPU${KH_RST}"
ps -arcwwwxo pid,pcpu,comm | awk 'NR>=2 && NR<=8 {printf "  %5s  %5s%%  %s\n",$1,$2,$3}'
print -- ""
print -- "  ${KH_YL}${KH_B}bellek${KH_RST}"
ps -arcwwwxo pid,pmem,rss,comm | awk 'NR>=2 && NR<=8 {printf "  %5s  %5s%%  %s\n",$1,$2,$4}'
print -- ""
khayal_dim "kapatmak: khayal <uygulama> kapat — Cursor/WindowServer öldürme"
