#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

raw="${*:-}"
[[ -n "$raw" ]] || { print -- "örnek: khayal 20 dakikaya kahve"; exit 1; }

mins=10
hours=0
title="$raw"

if [[ "$raw" =~ '([0-9]+)[[:space:]]*(dakika|dk|min)' ]]; then
  mins="${match[1]}"
  hours=0
fi
if [[ "$raw" =~ '([0-9]+)[[:space:]]*(saat|hour|hr)' ]]; then
  hours="${match[1]}"
  mins=0
fi

if [[ "$raw" == *yarin* || "$raw" == *tomorrow* ]]; then
  when="$(date -v+1d -v9H -v0M -v0S '+%Y-%m-%d %H:%M:%S')"
else
  when="$(date -v+${hours}H -v+${mins}M '+%Y-%m-%d %H:%M:%S')"
fi

title="$(print -r -- "$raw" | sed -E \
  -e 's/[0-9]+[[:space:]]*(dakika|dk|min|saat|hour|hr)(ya|ye|e|sonra)?//gI' \
  -e 's/hatirlat|remind(er)?|yarin|tomorrow|sonra//gI' \
  -e 's/^[[:space:]]+|[[:space:]]+$//g' \
  -e 's/[[:space:]]+/ /g')"
[[ -z "$title" ]] && title="hatırlatma"

osascript - "$when" "$title" <<'APPLESCRIPT'
on run argv
	set whenText to item 1 of argv
	set remTitle to item 2 of argv
	set y to text 1 thru 4 of whenText as integer
	set mo to text 6 thru 7 of whenText as integer
	set d to text 9 thru 10 of whenText as integer
	set h to text 12 thru 13 of whenText as integer
	set mi to text 15 thru 16 of whenText as integer
	set remindDate to current date
	set year of remindDate to y
	set month of remindDate to mo
	set day of remindDate to d
	set hours of remindDate to h
	set minutes of remindDate to mi
	set seconds of remindDate to 0
	tell application "Reminders"
		if (count of lists) is 0 then
			make new list with properties {name:"Khayal"}
		end if
		tell list 1
			make new reminder with properties {name:remTitle, remind me date:remindDate}
		end tell
	end tell
	return remTitle
end run
APPLESCRIPT

khayal_ok "hatırlatma: $title  ·  $when"
