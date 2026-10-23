#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

khayal_banner "$("$SCRIPT_DIR/status.sh" --line 2>/dev/null || true)"
khayal_title
print -- "  ${KH_MG}${KH_B}demo${KH_RST}  ${KH_DIM}Mac’i bozmaz${KH_RST}"
"$SCRIPT_DIR/status.sh"
"$SCRIPT_DIR/doctor.sh"
"$SCRIPT_DIR/notify.sh" "Khayal" "Hazırım." >/dev/null 2>&1 || true
khayal_chime
print -- "  ${KH_CY}${KH_B}khayal${KH_RST} ${KH_DIM}yaz ve bir şey iste. Cümle yeter.${KH_RST}"
print -- ""
