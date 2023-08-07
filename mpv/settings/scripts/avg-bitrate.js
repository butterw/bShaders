'use strict';

/* --- avg-bitrate.js mpv script  --- */
/* v0.20 by butterw (2023/08/07), tested on Windows
this version of avg-bitrate.js uses the new user-data feature (requires mpv v0.36).
https://github.com/butterw/bShaders/blob/master/mpv/settings/scripts/avg-bitrate.js

- avg-bitrate.js v0.11 might be a better starting point for writing custom osd scripts, and doesn't use user-data:
https://github.com/butterw/bShaders/blob/e6827e3363310804d1a2ed03bd1cec5b7bb67aba/mpv/settings/scripts/avg-bitrate.js

Calculates the average bitrate of the loaded audio-video file (in kilobits per second).
The result is stored in the property user-data/avg-bitrate (ex: 1726 kb/s).

To install, copy this script to the mpv subfolder: .\portable_config\scripts (assuming a Windows portable install).
Check you have only one version of avg-bitrate in scripts to avoid confusion/conflicts.

Basic use: 
display avg-bitrate on osd for 2 seconds when you press key a:
input.conf: a no-osd show-text "${user-data/avg-bitrate}" 2000

How to toggle a custom osd with a keybinding (the osd is permanently visible until disabled, it updates when a new file is loaded):
mpv.conf or mpv cli: --osd-msg2="${filename}\n${file-size}\n${user-data/avg-bitrate}"
input.conf: O no-osd cycle-values osd-level 2 1

Audio/video file average bitrate calculation using filesize_Bytes/duration_s:
avg-bitrate (in kilobits per second, kb/s) = 8/1000.0 * file-size_bytes / duration_s
	for local video/audio files seems to match `mediainfo > Overall bit rate`.
	Note that the file duration is not always exactly known, so this is an estimate.
avg-bitrate returns an empty string in the following cases:
! images have duration: 0
! video streamed with yt-dlp have filesize: NaN
	use video-bitrate property instead.

In some cases, the (keyframe based) `video-bitrate` property isn't very useful:
- it is (undefined) at the start of the video and after seeks (calculation requires two keyframes).
- it varies a lot on some medium/low bitrate video.

*/

var filesize_Bytes = 0.0;
var duration_s	   = 0.0;
var bitrate_kbps;

// function is run every time a new file is loaded:
mp.register_event("file-loaded", function() {
	filesize_Bytes = mp.get_property_number("file-size");
	duration_s	   = mp.get_property_number("duration");
	bitrate_kbps   = "";

	if ((duration_s>0) && !isNaN(filesize_Bytes)) {
		bitrate_kbps = Math.round(0.008*filesize_Bytes/duration_s);
		print(bitrate_kbps, "kb/s"); //[avg-bitrate] 1710 kb/s
		bitrate_kbps = bitrate_kbps +" kb/s";
	}

	mp.set_property("user-data/avg-bitrate", bitrate_kbps);
});
