# macOS recipes

Full pane map: [settings.md](settings.md). Prefer `scripts/ayar.sh`.

## System Settings panes

```bash
open "x-apple.systempreferences:com.apple.preference.security"          # Gizlilik ve Güvenlik
open "x-apple.systempreferences:com.apple.preference.trackpad"         # Trackpad
open "x-apple.systempreferences:com.apple.Displays-Settings.extension" # Ekranlar
open "x-apple.systempreferences:com.apple.Sound-Settings.extension"    # Ses
open "x-apple.systempreferences:com.apple.WiFi-Settings.extension"     # Wi-Fi
open "x-apple.systempreferences:com.apple.Network-Settings.extension"  # Ağ
open "x-apple.systempreferences:com.apple.Appearance-Settings.extension" # Görünüm
open "x-apple.systempreferences:com.apple.Users-Groups-Settings.extension"
open "x-apple.systempreferences:com.apple.preferences.sharing"
open "/System/Library/PreferencePanes/Spotlight.prefPane"
```

If a pane URL fails, fall back to: `open -a "System Settings"` and tell the user the sidebar item.

## Finder

```applescript
tell application "Finder"
  activate
  open POSIX file "/Users/khayal-macbook/Downloads"
  set collapsed of Finder window 1 to false
end tell
```

New folder:

```bash
mkdir -p "/Users/khayal-macbook/Desktop/YeniKlasor" && open "/Users/khayal-macbook/Desktop/YeniKlasor"
```

Move to Trash (recoverable):

```bash
osascript -e 'tell application "Finder" to delete POSIX file "/Users/khayal-macbook/Downloads/old.zip"'
```

Empty Trash — **confirm first**:

```bash
osascript -e 'tell application "Finder" to empty trash'
```

## Windows

```applescript
tell application "System Events"
  tell process "Google Chrome"
    set frontmost to true
    set position of window 1 to {80, 80}
    set size of window 1 to {1280, 800}
  end tell
end tell
```

Needs Accessibility permission.

## Appearance

```applescript
tell application "System Events"
  tell appearance preferences
    set dark mode to true -- or false
  end tell
end tell
```

## Volume / mute

```bash
osascript -e 'set volume output volume 30'
osascript -e 'set volume with output muted'
osascript -e 'set volume without output muted'
```

## Notifications (Do Not Disturb / Focus)

Prefer opening Focus settings rather than silently enabling Focus:

```bash
open "x-apple.systempreferences:com.apple.Focus-Settings.extension"
```

## Spotlight search from agent

```bash
mdfind -onlyin /Users/khayal-macbook 'kMDItemDisplayName == "*rapor*"c'
mdfind -onlyin /Users/khayal-macbook/Downloads 'kMDItemContentTypeTree == "public.image"'
```

## Docker

```bash
open -a Docker
# wait until:
docker info >/dev/null 2>&1
```

## Keep the Mac awake (temporary)

```bash
caffeinate -dimsu -t 3600
```

Do not leave `caffeinate` running unbounded unless asked.

## Battery / lock / sleep

```bash
pmset -g batt
~/.cursor/skills/khayal-mac/scripts/lock.sh
pmset displaysleepnow
# confirm first:
pmset sleepnow
```

## Restart Finder / show hidden files

```bash
killall Finder
defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder
defaults write com.apple.finder AppleShowAllFiles -bool false; killall Finder
```

## Listening ports

```bash
lsof -nP -iTCP -sTCP:LISTEN | awk 'NR==1 || /LISTEN/'
```

## Notification

```bash
~/.cursor/skills/khayal-mac/scripts/notify.sh "Khayal" "İş bitti"
```

## Zip / unzip

```bash
ditto -c -k --sequesterRsrc --keepParent "/path/dir" "$HOME/Desktop/dir.zip"
unzip -q "/path/file.zip" -d "/dest"
```
