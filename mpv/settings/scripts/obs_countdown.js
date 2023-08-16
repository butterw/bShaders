'use strict';

/* --- obs_countdown.js mpv script --- */
/* v0.11 by butterw (2023/08)

Displays a countdown in seconds for the final seconds of the video.
This is done by writing to osd-msg1.

to load this script at startup: --script=path.to/obs_countdown.js
*/

mp.observe_property("time-remaining", "number", function (name, value) {
	var s = 30; // sets the max number of seconds to countdown.
	if (value==undefined || value>s) {
		mp.command('no-osd set osd-msg1 ""');
		return;
	}
	s = "-"+ Math.round(value) +"s";
	mp.command("no-osd set osd-msg1 "+ s); //ex: -30s
	//if (mp.get_property("eof-reached")=="yes") mp.command('no-osd set osd-msg1 ""'); //clears the text after 0s.
});