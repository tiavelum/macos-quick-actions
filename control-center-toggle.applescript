-- Control Center Toggle
--
-- Opens macOS Control Center, which ships with no keyboard shortcut of its
-- own. Compiled into an application bundle by install.sh, because the
-- Accessibility grant that lets it drive the UI attaches to an application
-- at a path — not to a script, and not to whatever runs the script.
--
-- Menu bar items are matched on AXIdentifier rather than on their visible
-- label: the label is locale-dependent and is not the element's name, so
-- `click menu bar item "Control Center"` fails with
-- "Can't get menu bar item ...".

on run {input, parameters}
	tell application "System Events"
		tell process "ControlCenter"
			repeat with itm in menu bar items of menu bar 1
				try
					if (value of attribute "AXIdentifier" of itm) contains "controlcenter" then
						click itm
						exit repeat
					end if
				end try
			end repeat
		end tell
	end tell
	return input
end run
