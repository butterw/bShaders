--[[ countdown.lua mpv script 
v0.12 by butterw (2023/08)

Displays a COUNTDOWN in seconds for the final seconds of the video (or music file).
This is done by setting osd-msg1.

To load this script at startup: --script=path.to/countdown.lua

--]]

mp.observe_property("time-remaining", "number", function(name, value)

	local s = 30 -- set the max NUMBER OF SECONDS to countdown.
	
	if value ~=nil and value <s then 
		s = "-".. tostring(math.floor(value + 0.5)) .."s"
		mp.command("no-osd set osd-msg1 "..s); --ex: -9s
	else 
		mp.command('no-osd set osd-msg1 ""');
	end
end)