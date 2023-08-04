'use strict';

/* --- avg-bitrate.js mpv script --- */
/* v0.1 by butterw (2023/08/04)

Video file average_bitrate calculation using filesize_Bytes/duration_s
avg-bitrate (in kilobits per second, kb/s) = 8/1000.0 * file-size_bytes / duration_s
	for local video/audio files seems to match `mediainfo > Overall bit rate`.

! images have duration: 0
! video streamed with yt-dlp has filesize: NaN
	use --osd-msg1=" ${video-bitrate}" instead. 
	
The (keyframe based) `video-bitrate` property isn't always very useful for two reasons:
- it is (undefined) at the start of the video and after seeks (calculation requires two keyframes). 
- it varies an awful lot on some medium/low bitrate video. 

To install, copy this script to the mpv subfolder: .\portable_config\scripts (assuming a Windows portable install).
you can add a keybinding (ex: a) for display in portable_config\input.conf:
 a script-message avg-bitrate
 
Customization: this script can operate every time a new file is loaded or (by default) on demand via a keybinding. 
*/

var filesize_Bytes = 0.0;
var duration_s	   = 0.0;

/*
// optional: script is run every time a new file is loaded:
mp.register_event("file-loaded", function() {
	filesize_Bytes = parseFloat(mp.get_property("file-size"));
	duration_s	   = parseFloat(mp.get_property("duration"));
	//print("filesize_Bytes:", filesize_Bytes);
	//print("duration_s:", duration_s);
	//print(0.008*filesize_Bytes/duration_s, " Kbps");
	var bitrate_kbps = Math.round(0.008*filesize_Bytes/duration_s);
	print(bitrate_kbps, "kb/s"); //[avg_bitrate] 1710 kb/s
	// mp.osd_message(bitrate_kbps + " kb/s", 0.7); //displays on OSD for 0.7s
	mp.set_property("osd-msg1", bitrate_kbps + " kb/s") //permanent OSD display, until changed
});
*/

// On demand script output:
mp.register_script_message("avg-bitrate", function() {
	filesize_Bytes = parseFloat(mp.get_property("file-size"));
	duration_s	   = parseFloat(mp.get_property("duration"));
	if ((duration_s>0) && !isNaN(filesize_Bytes)) {
		var bitrate_kbps = Math.round(0.008*filesize_Bytes/duration_s);
		print(bitrate_kbps, "kb/s"); //[avg_bitrate] 1710 kb/s
		mp.osd_message(bitrate_kbps + " kb/s", 0.7);
	}
});
