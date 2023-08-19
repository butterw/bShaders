'use strict';

/* --- btime.js mpv script (shortened time OSD) --- */
/* v0.11 by butterw (2023/08) lightweight script.
use --script=path.to/btime.js OR install by copying to portable_config/scripts (tested on win10).

Short time format for On-Screen-Display.
ex OSD: 0:08 / 1:12, instead of 00:00:08 / 00:01:12.
the modified time strings are shown for a limited duration on OSD on seeks and/or on demand (default show-time hotkey: F11).
- ! mp.register_event("seek" redefines the `seek` OSD display:
1) use with --no-osd-on-seek
2) make sure there are no collisions with other loaded user scripts.

The OSD time format can be customized by the user.
by default, btime.js uses a short time format similar to the one used by youtube, but better suited for movies.

playback-time / duration
00:00:08 / 00:01:12	 (mpv default)
   00:08 / 01:12 (mpc-hc)
	0:08 / 1:12	 (btime)

00:06:04 / 01:27:09 (mpv default)
00:06:04 / 01:27:09 (mpc-hc)
   06:04 / 1:27:09 (btime)

01:02:08 / 01:27:09 (mpv default)
01:02:08 / 01:27:09 (mpc-hc)
 1:02:08 / 1:27:09 (btime)

*/
var duration;

function fmt_time_str(t_str)  {
	// shortens a time string, ex: duration
	if (t_str.substring(0, 3)== "00:") t_str=t_str.substring(3); //changes 00:01:12 to 01:12
	//drop the leading zero, changes 01:12 to 1:12 and 01:27:09 to 1:27:09 :
	if (t_str.charAt(0)=="0") t_str = t_str.substring(1); //mpc-hc format: comment out this line.
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
	var playtime = mp.get_property_osd("playback-time");
	playtime = playtime.substring(8-duration.length); //keep the same digits as duration
	if (duration.length==7 && playtime.charAt(0)=="0") {
		playtime = playtime.substring(2); //drop leading zero hours, ex: 06:04 / 1:27:09
	}
	mp.commandv("show-text", playtime +" / "+ duration); // custom OSD
}

/* This code bloc is commented out.
function on_seek() {
	var playtime = mp.get_property_osd("playback-time"); //"time-remaining"
	//playtime = fmt_time_str(playtime);

	// Alternative seek function that keeps the same digits as duration
	// can be used to achieve mpc-hc mode:
	playtime = playtime.substring(8-duration.length);
	mp.commandv("show-text", playtime +" / "+ duration);
}
*/
