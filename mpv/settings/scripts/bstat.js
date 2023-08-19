'use strict';

/* --- bstat.js mpv script (better stats) --- */
/* v0.20 by butterw (2023/08) no longer redefines seek.
tested on win10. To install, copy to portable_config/scripts
makes use of user-data properties (req. mpv v0.36).

- show-time ms: show mpc-hc style time string: 34:25 / 45:10
- pause-eof (use with --keep-open). When you reach the end of video, play from the start on play/pause (like mpc-hc).
- restart-mpv: can be useful when testing scripts or shaders (reloads shaders).
- each time a new file is loaded:
	- calculates and makes available new (user-data) properties, ex: the duration in mpc-hc shortened format.
	- prints a [bstats] bloc to the terminal output with:
		- file path
		- file-size calculation with adaptative rounding using either base10 or base2 units (M: 1e6 bytes by default) or (1024*1024 bytes).
		- Aspect-ratio using exact (by default) or near (~) ratio calculation. Takes into account container DAR.
		- average (audio-video file) bitrate calculation based on file-size and duration (replaces scripts/avg-bitrate.js).
[bstat]
[bstat] c:\Vids\myVideo.mp4
[bstat] 3.8M, a9/16, 1939kb/s
- some basic javascript utility functions (ex: floating-point rounding, print properties).

ex: custom osd
--osd-msg2 = "${osd-sym-cc} ${percent-pos}% of ${user-data/duration}\n${user-data/res} ${user-data/ar}\n${user-data/file-size}\n${user-data/avg-bitrate}-${audio-bitrate:}\n${video-format:}: ${video-bitrate:}"

input.conf:
 O no-osd cycle-values osd-level 2 1 # toggles the custom osd
 SPACE	  script-message pause-eof
 t		  script-message show-time 1500
 Shift+F5 script-binding restart-mpv

*/
var duration;


function fmt_time_str(t_str)  {
	// shortens a time string, ex: duration. Mpv default: 00:03:08 and 01:27:09
	if (t_str.substring(0, 3)== "00:") t_str=t_str.substring(3); //change to 03:08 and 01:27:09
	//if (t_str.charAt(0)=="0") t_str = t_str.substring(1); //drops the leading zero 3:08 and 1:27:09 (shortest)
	return t_str;
}

mp.register_event("file-loaded", function() {
	// runs every time a new file is loaded.
	// terminal: 3.6M, ar16/9, 1124kb/s
	var fsize_B	 = mp.get_property_number("file-size"); //Bytes
	duration = mp.get_property_number("duration"); //seconds
	var avg_bitrate = calc_bitrate(fsize_B, duration);
	var fsize_str  = K1000(fsize_B);
	// Alternative: to display filesize in MB
	// calculated with proper rounding: K1024(fsize_B)+"B";
	// or from mpv MiB: mp.get_property_osd("file-size").replace("i", "");
	duration = fmt_time_str(mp.get_property_osd("duration"));

	// the following new properties are made available:
	mp.set_property("user-data/duration", duration); //27:39 like mpc-hc
	mp.set_property("user-data/file-size", fsize_str);	//805M
	var term_str = mp.get_property("path")+"\n";
	var ar_str = calc_aspect();
	mp.set_property("user-data/avg-bitrate", avg_bitrate);	//1253 kb/s
	mp.set_property("user-data/ar", ar_str);  //a16/9

	term_str+= fsize_str +", "+	 ar_str +", "+ avg_bitrate.replace(" ", "");
	print(term_str);
});

// On-demand update or osd display
// input.conf: t script-binding show-time //optional parameter: a duration in ms.
mp.register_script_message("show-time", function(ms) {
	print("%", pct);	var playtime = mp.get_property_osd("playback-time");
	playtime = playtime.substring(8-duration.length); //keep the same digits as duration
	if (isNaN(ms) || ms<100) mp.commandv("show-text", playtime +" / "+ duration); //04:12 / 27:39
	else mp.commandv("show-text", playtime +" / "+ duration, ms);
});

mp.register_script_message("pause-eof", function() {
// mpc-hc: when you reach the end of the video, seeks back to the start on Play/Pause (use with --keep-open)
// input.conf: SPACE script-message pause-eof
	if (mp.get_property("pause")=="yes") {
		if (mp.get_property("eof-reached")=="yes") mp.command("no-osd seek 0 absolute");
		mp.set_property("pause", "no");
	}
	else mp.set_property("pause", "yes");
});

mp.add_key_binding("Shift+F5", "restart-mpv", restart_mpv);
// input.conf: Shift+F5 script-binding restart-mpv
function restart_mpv() {
	var s = "--glsl-shaders=";
	s+= mp.get_property("glsl-shaders").replace(/,/g, ";");
	print("restart mpv", s);
	mp.commandv("run", "mpv.com", mp.get_property("path"), s);
	mp.command("quit");
}

function K1000(B) {
// ex: 1.686G > 880M > 18.5M > 125.5K (Bytes)
	return (B>1e9)? fmt_fp(B*1e-9, 3)+"G": (B>100e6)? Math.round(B*1e-6)+"M": (B>1e6)? fmt_fp(B*1e-6, 1)+"M": fmt_fp(B*1e-3, 1)+"K";
}

function K1024(B) {
// ex: 1.56G > 880M > 18.5M > 125K (Bytes)
	var MB = 1024*1024;
	var GB = 1024*MB;
	return (B>GB)? fmt_fp(B/GB, 2)+"G": (B>(100*MB))? Math.round(B/MB)+"M": (B>(1*MB))? fmt_fp(B/MB, 1)+"M": Math.round(B/1024)+"K";
}

function calc_bitrate(B, duration_s) {
// ex: 2564 kb/s or "" (kilobits per second)
	var avg_bitrate = "";
	if ((duration_s>0) && !isNaN(B)) {
		avg_bitrate = Math.round(0.008* B/duration_s);
		avg_bitrate+= " kb/s";
	}
	return avg_bitrate;
}

function near_equal(x, y) { return (Math.abs(x - y)) <= 0.001; }
function calc_aspect() {
// exact ratio calculation, takes into account DAR
// ex: "ar16/9"
// user-data/whp: 1920×1080p60 or 360×480
	print();
	var dw = mp.get_property_number("video-params/dw");
	if (!dw) {
		mp.set_property("user-data/res", "");
		mp.set_property("user-data/ar",	 "");
		return "";
	}
	var dh = mp.get_property_number("video-params/dh");
	var whp = fmt_fp(mp.get_property_number("container-fps"), 2);
	whp = (whp!=1)? "p"+ whp: "";
	whp = dw +"×"+ dh + whp;
	// print("whp:", whp);
	mp.set_property("user-data/res", whp);
	var ar = dw/dh;
	dw = ar*9/16;
	if		(dw ==1) ar="16/9";
	else if (near_equal(dw, 1)) ar="~16/9"; //ex 480p: 854x480
	else if (ar == 1.50)	ar="3/2";
	else if (ar*3/4 ==1)	ar="4/3";
	else if (ar == 1.25)	ar="5/4";
	else if (ar == 0.5625)	ar="9/16";
	else if (ar == 0.625)	ar="10/16";
	else if (ar*3/2 ==1)	ar="2/3";
	else if (ar == 0.75)	ar="3/4";
	else if (ar == 0.80)	ar="4/5";
	else ar = fmt_fp(ar, 2);
	return "a" + ar;
}

function fmt_fp(x, n) {
	var m = Math.pow(10, n);
	return String(Math.round(x *m)/m);
}

function oprint(property) { //property_osd
	var p = mp.get_property_osd(property);
	if (p=="") p='""';
	print(" "+ property +" osd:", p);
}

function rprint(property) { //=property
	var p = mp.get_property(property);
	if (p=="") p='""';
	print(" "+ property, p);
}

function nprint(property) { //property_number
	var p = mp.get_property_number(property);
	if (p=="") p='""';
	print(" "+ property +" number:", p);
}

function fprint(property) { //full print
	oprint(property); rprint(property); nprint(property);
	print();
}
