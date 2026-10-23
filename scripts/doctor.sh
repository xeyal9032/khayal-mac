#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
ROOT="${SCRIPT_DIR:h}"
source "$SCRIPT_DIR/ui.sh"

okn=0
badn=0
warnn=0

row_ok()   { okn=$((okn+1));   print -- "  ${KH_GN}✔${KH_RST}  ${(r:18:: :)1} ${KH_DIM}$2${KH_RST}"; }
row_bad()  { badn=$((badn+1)); print -- "  ${KH_RD}✖${KH_RST}  ${(r:18:: :)1} ${KH_RD}$2${KH_RST}"; }
row_warn() { warnn=$((warnn+1)); print -- "  ${KH_YL}●${KH_RST}  ${(r:18:: :)1} ${KH_YL}$2${KH_RST}"; }

print -- ""
print -- "  ${KH_CY}${KH_B}doctor${KH_RST}  ${KH_DIM}v$(khayal_version) · $(scutil --get ComputerName 2>/dev/null || print -- Mac)${KH_RST}"
khayal_hr

if [[ -x "$ROOT/scripts/khayal" ]]; then
  row_ok "CLI" "$ROOT/scripts/khayal"
else
  row_bad "CLI" "khayal binary yok"
fi

if git --version >/dev/null 2>&1; then
  row_ok "git" "$(git --version | awk '{print $3}')"
else
  row_bad "git" "Xcode lisansı: sudo xcodebuild -license accept"
fi

if [[ -x "$HOME/.local/bin/agent" ]] || command -v agent >/dev/null 2>&1; then
  row_ok "agent" "$(command -v agent 2>/dev/null || print -- "$HOME/.local/bin/agent")"
else
  row_warn "agent" "curl https://cursor.com/install -fsS | bash"
fi

if node --version >/dev/null 2>&1; then
  row_ok "node" "$(node --version)"
else
  row_warn "node" "yok"
fi

if docker info >/dev/null 2>&1; then
  row_ok "docker" "çalışıyor"
elif command -v docker >/dev/null 2>&1; then
  row_warn "docker" "CLI var, daemon kapalı"
else
  row_warn "docker" "yok"
fi

if [[ -f "$HOME/Library/Preferences/netlify/config.json" ]] || [[ -f "$HOME/.netlify/config.json" ]]; then
  row_ok "netlify" "oturum var"
else
  row_warn "netlify" "khayal yayin login"
fi

if launchctl list 2>/dev/null | grep -q 'com.khayal'; then
  row_ok "daemons" "$(launchctl list 2>/dev/null | grep -c 'com.khayal' | tr -d ' ') görev"
else
  row_warn "daemons" "khayal pro kur"
fi

if [[ -d "$HOME/Applications/Khayal.app" ]]; then
  row_ok "spotlight" "Khayal.app"
else
  row_warn "spotlight" "khayal spotlight"
fi

if [[ -x "$HOME/.khayal/bin/khayal-hotkey" ]]; then
  row_ok "kısayol" "⌥Space"
else
  row_warn "kısayol" "khayal pro kur"
fi

if [[ -L "$HOME/.local/bin/khayal" || -x "$HOME/.local/bin/khayal" ]]; then
  row_ok "PATH" "~/.local/bin/khayal"
else
  row_warn "PATH" "khayal kur"
fi

if [[ -d "$ROOT/.git" ]]; then
  br="$(git -C "$ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || print -- "?")"
  row_ok "repo" "github.com/xeyal9032/khayal-mac ($br)"
else
  row_warn "repo" "git clone yok"
fi

ui="$(osascript -e 'tell application "System Events" to get UI elements enabled' 2>/dev/null || print -- "?")"
if [[ "$ui" == "true" ]]; then
  row_ok "erişilebilirlik" "açık"
else
  row_warn "erişilebilirlik" "Sistem Ayarları → Gizlilik"
fi

khayal_hr
tot=$((okn+badn+warnn))
print -- "  ${KH_GN}${okn} hazır${KH_RST}  ${KH_YL}${warnn} uyarı${KH_RST}  ${KH_RD}${badn} hata${KH_RST}  ${KH_DIM}/ ${tot}${KH_RST}"
if (( badn == 0 )); then
  print -- "  ${KH_GN}${KH_B}ajan operasyonel.${KH_RST}"
  khayal_chime
else
  print -- "  ${KH_RD}önce kırmızıları düzelt.${KH_RST}"
fi
print -- ""
exit 0
