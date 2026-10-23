# Operations catalog

Settings panes and toggles: [settings.md](settings.md) and `scripts/ayar.sh`.

## Status / energy

```bash
~/.cursor/skills/khayal-mac/scripts/status.sh
pmset -g batt
pmset -g custom
df -h /
# display sleep now / Mac sleep (confirm sleep):
pmset displaysleepnow
pmset sleepnow
```

## Volume / sound

```bash
osascript -e 'set volume output volume 30'
osascript -e 'set volume with output muted'
osascript -e 'set volume without output muted'
osascript -e 'output volume of (get volume settings)'
```

## Network / Wi-Fi

```bash
~/.cursor/skills/khayal-mac/scripts/ayar.sh wifi ac
~/.cursor/skills/khayal-mac/scripts/ayar.sh wifi kapat
networksetup -listallhardwareports
ipconfig getifaddr en0
lsof -nP -iTCP -sTCP:LISTEN | head
```

DNS flush (sudo, only if asked):

```bash
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```

## Dock / Finder / screenshots

```bash
ayar.sh dock gizle
ayar.sh dock goster
ayar.sh gizli ac
defaults write com.apple.screencapture location "/Users/khayal-macbook/Desktop"
defaults write com.apple.screencapture type png
killall SystemUIServer
```

## Processes

```bash
killall "Google Chrome"
killall -9 "Google Chrome"   # if still stuck
```

Do not kill Cursor, WindowServer, kernel_task, loginwindow.

## Files

```bash
ditto -c -k --sequesterRsrc --keepParent "/path/dir" "$HOME/Desktop/dir.zip"
unzip -q "/path/file.zip" -d "/dest"
mdfind -onlyin "$HOME" 'name:foo'
```

Organize Downloads only after a listed plan and yes. Move, don't delete.

## Time Machine / updates / storage

```bash
tmutil status
tmutil listbackups
open "x-apple.systempreferences:com.apple.Software-Update-Settings.extension"
softwareupdate -l          # list; install only if asked
du -sh "$HOME"/Library/Caches
```

## Lock / notify / dev

```bash
~/.cursor/skills/khayal-mac/scripts/lock.sh
~/.cursor/skills/khayal-mac/scripts/notify.sh "Khayal" "Bitti"
open -a Cursor "/Users/khayal-macbook/yeniphpfile"
open -a Docker
docker ps
```
