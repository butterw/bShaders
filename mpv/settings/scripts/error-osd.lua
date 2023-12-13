--[[ Display error messages in OSD for a couple seconds
butterw (2023-12-13): modified code from https://github.com/mpv-player/mpv/issues/7631
- filter log, only display "file" errors. 

example: wrong shader filename or path 
> mpv --glsl-shaders=abba.glsl video.mp4
displays in terminal, in red:
[file] Cannot open file 'abba.glsl': No such file or directory
Failed to open abba.glsl.

--log-file=my.log
[   0.011][v][cplayer] Setting option 'glsl-shaders' = 'abba.glsl' (flags = 8)
...
[   0.074][e][file] Cannot open file 'abba.glsl': No such file or directory
[   0.075][e][stream] Failed to open abba.glsl.



log-message (MPV_EVENT_LOG_MESSAGE)
    This contains, in addition to the default event fields, the following fields:
    prefix:      The module prefix, identifies the sender of the message. This is what the terminal player puts in front of the message text when using the --v option, and is also what is used for --msg-level.
    level:       The log level as string. See msg.log for possible log level names. Note that later versions of mpv might add new levels or remove (undocumented) existing ones.
    text:        The log message. The text will end with a newline character. Sometimes it can contain multiple lines.
    Keep in mind that these messages are meant to be hints for humans. You should not parse them, and prefix/level/text of messages might change any time.

]]--
local ov = mp.create_osd_overlay("ass-events")

mp.enable_messages('error')
mp.register_event('log-message', function(log)
    message = "{\\c&H0000CC>&}[" .. log.prefix .. "] " .. log.text
	if log.prefix == "file" then
		ov.data = ov.data .. message
		ov:update()

		mp.add_timeout(4, function ()
			local endln = ov.data:find('\n') + 1
			ov.data = ov.data:sub(endln)
			ov:update()
		end)
	end
end)