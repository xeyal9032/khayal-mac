#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
LABEL="com.khayal.downloads"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"
ORG="$SCRIPT_DIR/organize-downloads.sh"
UID_N="$(id -u)"

enable() {
  mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
  cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>${ORG}</string>
    <string>--quiet</string>
  </array>
  <key>WatchPaths</key>
  <array>
    <string>${HOME}/Downloads</string>
  </array>
  <key>StandardOutPath</key>
  <string>${HOME}/Library/Logs/khayal-downloads.log</string>
  <key>StandardErrorPath</key>
  <string>${HOME}/Library/Logs/khayal-downloads.log</string>
</dict>
</plist>
EOF
  launchctl bootout "gui/${UID_N}/${LABEL}" >/dev/null 2>&1 || true
  if launchctl bootstrap "gui/${UID_N}" "$PLIST" 2>/dev/null; then
    print -- "Downloads otomatik düzenleme AÇIK."
  elif launchctl load "$PLIST" 2>/dev/null; then
    print -- "Downloads otomatik düzenleme AÇIK (load)."
  else
    print -- "LaunchAgent yazıldı ama yüklenemedi: $PLIST" >&2
    exit 1
  fi
  "$ORG" || true
}

disable() {
  launchctl bootout "gui/${UID_N}/${LABEL}" >/dev/null 2>&1 || true
  launchctl unload "$PLIST" >/dev/null 2>&1 || true
  print -- "Downloads otomatik düzenleme KAPALI."
}

case "${1:-}" in
  ac|on|enable) enable ;;
  kapat|off|disable) disable ;;
  *)
    print -- "usage: downloads-watch.sh ac|kapat" >&2
    exit 1
    ;;
esac
