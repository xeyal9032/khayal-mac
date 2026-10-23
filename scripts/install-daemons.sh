#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
UID_N="$(id -u)"
GUI="gui/${UID_N}"
AGENTS="$HOME/Library/LaunchAgents"
BIN="$HOME/.khayal/bin"
mkdir -p "$AGENTS" "$BIN" "$HOME/Library/Logs" "$HOME/.khayal"

write_plist() {
  local label="$1" interval="$2"
  shift 2
  [[ "$1" == "x" ]] && shift
  local plist="$AGENTS/${label}.plist"
  {
    print -- '<?xml version="1.0" encoding="UTF-8"?>'
    print -- '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'
    print -- '<plist version="1.0"><dict>'
    print -- "<key>Label</key><string>${label}</string>"
    print -- '<key>ProgramArguments</key><array>'
    print -- '<string>/bin/zsh</string>'
    for a in "$@"; do
      print -- "<string>${a}</string>"
    done
    print -- '</array>'
    if [[ "$interval" == "calendar" ]]; then
      print -- '<key>StartCalendarInterval</key><dict>'
      print -- '<key>Hour</key><integer>20</integer>'
      print -- '<key>Minute</key><integer>0</integer>'
      print -- '</dict>'
    elif [[ "$interval" != "0" ]]; then
      print -- "<key>StartInterval</key><integer>${interval}</integer>"
    fi
    print -- "<key>StandardOutPath</key><string>$HOME/Library/Logs/${label}.log</string>"
    print -- "<key>StandardErrorPath</key><string>$HOME/Library/Logs/${label}.log</string>"
    print -- '<key>RunAtLoad</key><true/>'
    print -- '</dict></plist>'
  } > "$plist"
  launchctl bootout "${GUI}/${label}" >/dev/null 2>&1 || true
  launchctl bootstrap "$GUI" "$plist" 2>/dev/null || launchctl load "$plist" 2>/dev/null || true
}

if swiftc -O -o "$BIN/khayal-hotkey" "$SCRIPT_DIR/KhayalHotkey.swift" 2>/dev/null; then
  :
else
  print -- "⌥Space için Xcode lisansı gerekir: sudo xcodebuild -license" >&2
  print -- "Şimdilik: Cmd+Space → Khayal" >&2
fi

if [[ -x "$BIN/khayal-hotkey" ]]; then
  cat > "$AGENTS/com.khayal.hotkey.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.khayal.hotkey</string>
  <key>ProgramArguments</key>
  <array>
    <string>${BIN}/khayal-hotkey</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
</dict>
</plist>
EOF
  launchctl bootout "${GUI}/com.khayal.hotkey" >/dev/null 2>&1 || true
  launchctl bootstrap "$GUI" "$AGENTS/com.khayal.hotkey.plist" 2>/dev/null \
    || launchctl load "$AGENTS/com.khayal.hotkey.plist" 2>/dev/null || true
  print -- "⌥Space kısayolu yüklendi"
fi

write_plist com.khayal.pano 8 x "$SCRIPT_DIR/pano.sh" watch
write_plist com.khayal.saglik 900 x "$SCRIPT_DIR/saglik.sh" --watch
write_plist com.khayal.yarin calendar x "$SCRIPT_DIR/yarin.sh" --notify

print -- "daemons: pano, sağlık (15dk), yarın özeti (20:00), kısayol"
