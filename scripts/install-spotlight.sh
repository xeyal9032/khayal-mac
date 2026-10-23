#!/bin/zsh
set -euo pipefail
APP="$HOME/Applications/Khayal.app"
mkdir -p "$HOME/Applications"

osacompile -o "$APP" <<'APPLESCRIPT'
tell application "Terminal"
	activate
	do script "source ~/.zshrc >/dev/null 2>&1; cd ~; khayal"
end tell
APPLESCRIPT

/usr/libexec/PlistBuddy -c 'Set :CFBundleName Khayal' "$APP/Contents/Info.plist" 2>/dev/null \
  || /usr/libexec/PlistBuddy -c 'Add :CFBundleName string Khayal' "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleDisplayName Khayal' "$APP/Contents/Info.plist" 2>/dev/null \
  || /usr/libexec/PlistBuddy -c 'Add :CFBundleDisplayName string Khayal' "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier com.khayal.mac' "$APP/Contents/Info.plist" 2>/dev/null \
  || /usr/libexec/PlistBuddy -c 'Add :CFBundleIdentifier string com.khayal.mac' "$APP/Contents/Info.plist"

mdimport "$APP" >/dev/null 2>&1 || true
print -- "Spotlight uygulaması: $APP"
print -- "Cmd+Space → Khayal yaz → Enter"
