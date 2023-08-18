'use strict';

/* --- btime.js mpv script (shortened time OSD) --- */
/* v0.10 by butterw (2023/08) lightweight script
use --script=path.to/btime.js OR install by copying to portable_config/scripts (tested on win10).

Short time format for On-Screen-Display.
ex OSD: 0:08 / 1:12, instead of 00:00:08 / 00:01:12.
the modified time strings are shown for a limited duration on OSD on seeks and/or on demand (default show-time hotkey: F11).
- redefines the seek display (use with --no-osd-on-seek)

The OSD time format can be customized by the user.
by default, btime.js uses a short time format similar to the one used by youtube, but better suited for movies.

playback-time / duration
00:00:08 / 00:01:12	 (mpv default)
	0:08 / 1:12	 (btime)

00:06:04 / 01:27:09 (mpv default)
   06:04 / 1:27:09 (btime)

01:02:08 / 01:27:09 (mpv default)
 1:02:08 / 1:27:09 (btime)

 */

var duration;

function fmt_time_str(t_str)  {
	// shortens a time string, ex: duration
	if (t_str.substring(0, 3)== "00:") t_str=t_str.substring(3); //(short format, ex: mpc-hc) 01:12
	if (t_str.charAt(0)=="0") t_str = t_str.substring(1); //drop the leading zero >> 1:12 and 1:27:09 (shortest)
	return t_str;
}

mp.register_event("file-loaded", function() {
	// every time a new file is loaded, process the duration string
	duration = fmt_time_str(mp.get_property_osd("duration"));
});


mp.add_key_binding("F11", "show-time", on_seek);
// input.conf: F11 script-binding show-time
mp.register_event("seek", on_seek);
function on_seek() {
	var playtime = mp.get_property_osd("playback-time"); //"time-remaining"
	//playtime = fmt_time_str(playtime);
	playtime = playtime.substring(8-duration.length); //keep the same digits as duration
	if (duration.length==7 && playtime.charAt(0)=="0") {
		playtime = playtime.substring(2); //drop leading zero hours, ex: 06:04 / 1:27:09
	}
	mp.commandv("show-text", playtime +" / "+ duration); // custom OSD
}