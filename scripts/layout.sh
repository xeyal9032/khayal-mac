#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

open -a "Google Chrome" >/dev/null 2>&1 || true
open -a "Cursor" >/dev/null 2>&1 || true
sleep 0.8

osascript <<'APPLESCRIPT'
tell application "Finder"
	set {sx1, sy1, sx2, sy2} to bounds of window of desktop
end tell
set menuH to 32
set dockH to 0
try
	tell application "System Events"
		if autohide of dock preferences is false then set dockH to 70
	end tell
end try
set W to sx2 - sx1
set H to sy2 - sy1
set mid to sx1 + (W div 2)
set topY to sy1 + menuH
set botY to sy2 - dockH
set leftBounds to {sx1, topY, mid, botY}
set rightBounds to {mid, topY, sx2, botY}

tell application "Google Chrome"
	activate
	if (count of windows) is 0 then make new window
	try
		set bounds of window 1 to leftBounds
	end try
end tell

delay 0.2

tell application "System Events"
	if exists process "Cursor" then
		tell process "Cursor"
			set frontmost to true
			try
				set position of window 1 to {mid, topY}
				set size of window 1 to {W div 2, botY - topY}
			end try
		end tell
	end if
end tell
APPLESCRIPT

khayal_ok "Chrome solda, Cursor sağda"
khayal_dim "Pencere kıpırdamazsa: Sistem Ayarları → Gizlilik → Erişilebilirlik → Terminal / Cursor"
