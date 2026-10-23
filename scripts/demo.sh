#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

clear 2>/dev/null || true
khayal_title
khayal_banner "$("$SCRIPT_DIR/status.sh" --line 2>/dev/null || true)"
print -- "  ${KH_MG}${KH_B}demo${KH_RST}  ${KH_DIM}üç saniye · hiçbir şeyi bozmaz${KH_RST}"
print -- ""
sleep 0.35
"$SCRIPT_DIR/status.sh"
sleep 0.2
"$SCRIPT_DIR/doctor.sh"
"$SCRIPT_DIR/notify.sh" "Khayal" "Hazırım — wow." >/dev/null 2>&1 || true
khayal_chime
print -- "  ${KH_CY}${KH_B}khayal${KH_RST} ${KH_DIM}yaz ve bir şey iste. Cümle yeter.${KH_RST}"
print -- ""
