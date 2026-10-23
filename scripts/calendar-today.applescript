on run argv
	set offsetDays to 0
	if (count of argv) > 0 then
		try
			set offsetDays to (item 1 of argv) as integer
		end try
	end if
	with timeout of 12 seconds
		set dayStart to current date
		set time of dayStart to 0
		set dayStart to dayStart + (offsetDays * days)
		set dayEnd to dayStart + (1 * days)
		set linesOut to {}
		tell application "Calendar"
			repeat with c in calendars
				try
					set evs to (every event of c whose start date ≥ dayStart and start date < dayEnd)
					repeat with e in evs
						set s to start date of e
						set hh to text -2 thru -1 of ("0" & (hours of s))
						set mm to text -2 thru -1 of ("0" & (minutes of s))
						set end of linesOut to hh & ":" & mm & "  " & (summary of e)
					end repeat
				end try
			end repeat
		end tell
		if (count of linesOut) is 0 then
			if offsetDays is 0 then
				return "bugun etkinlik yok"
			else
				return "yarin etkinlik yok"
			end if
		end if
		set AppleScript's text item delimiters to linefeed
		return linesOut as text
	end timeout
end run
