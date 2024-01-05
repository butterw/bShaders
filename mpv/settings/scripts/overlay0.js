'use strict';

/* --- overlay0.js mpv script (osd_overlay example) --- 
v0.01 by butterw (2023/12), License: GPLv3
*/
var bar_h = 6
var bar_w = 0.94 //[0 to 1.0]
var bar_y = 0.95 //[0 to 1.0]
var bar_color = "\\1c&0000FF"; //red
var bar_bg_color = "\\1c&BBBBBB\\1a&AA";
var t_readout_font = "\\Arial\\fs20"  //"\\fnSegoe UI\\fs22\\b1" //"\\fnSegoe UI Semibold\\fs22";
var t_readout_color = "\\1c&F8F8F8\\1a&00";
var t_readout_bg = "\\4a&35\\4c&202020\\shad0.5";
var low_opacity_bg = "\\4a&E8\\4c&101010\\shad0.5";

/* This simple script displays/updates an (ass-based) OSD overlay: 
- a red on semi-transparent progress-bar (similar to youtube)
- a playtime / duration time string.
- and 2 static messages: 
- mpv default style  
- semi-transparent background.
 
It also shows video duration using standard OSD.

usage: mpv --scripts=path.to/overlay0.js path.to/video.mp4 
Recommended options (mpv.conf or command-line):  
 --no-osd-scale-by-window
 --osd-back-color = "#e6202020"
 --osd-shadow-offset = 4
 --no-osc
 --no-osd-bar

Notes:
! For back-padding with shadow parameters --osd-back-color must not be fully transparent.
The --osd-scale-by-window option only affects regular OSD text, not the overlay.

*/
var nbsp = " ";
var ov;
var osd_dims;
var duration;
var playtime;
var percent_pos;
var osd_dims;

mp.register_event("file-loaded", function() {
	duration = mp.get_property_osd("duration"); //ex: "00:01:02"
	//shows duration text on standard OSD for 30s 
	// ! the text will only be updated when a new file is loaded.
	//pad background with --osd-shadow-offset=4
	mp.commandv("show-text", duration, 30000);
});

function rectangle(x0, y0, w, h, An) {
	// ex: rectangle(0, 700, 700, 5, 7)
	// "{\\pos("+ x0 +","+ y0+")\\p1}m 0 0 l "+ w +" 0 l "+ w +" "+ h +" l 0 "+ h
	return "".concat("{\\p1\\an", An,"\\pos(", x0, ",", y0, ")}m 0 0 l ", w, " 0 l ", w, " ", h, " l 0 ", h);
}
/* Anchor Point, default: \\An7
 7 8 9
 4 5 6
 1 2 3 
 
progress_bar & bg_bar (\\An1), bar.y<  ======bar_w x bar_h======  < 
 */

function update_bar() {
	playtime = mp.get_property_osd("time-pos");
	var time_str = nbsp + playtime + " / " + duration + nbsp; //padding with nbsp

	if (!ov) ov = mp.create_osd_overlay();	
	if (!ov.hidden) {
		var msg_default = "{\\rDefault\\an9}mpv Default\\Nan9"; //Default style applied to top right of screen message with 2 lines.	

		var msg = "01 / 2024";
		msg = "\n".concat("{\\an1\\pos(100, 400)", t_readout_color, low_opacity_bg, "\\fnArial\\b1\\fs20\\bord0}", msg);
	
		var y0 = bar_y*osd_dims.h; 
		var x0 = 0.5*(1-bar_w)*osd_dims.w; 
		var t_readout_pos = "\\pos(" + Math.round(0.015*osd_dims.w) +","+ Math.round(y0+osd_dims.h/360) + ")";
		var t_readout = "\n".concat("{\\an7", t_readout_pos, t_readout_font, t_readout_color, t_readout_bg, "\\bord0}", time_str);

		x0 = Math.round(x0);	
		y0 = Math.round(y0);
		var w = bar_w*osd_dims.w;
		var default_pre = "{\\rDefault\\shad0\\bord0";
		var bg_bar = "\n".concat(default_pre, bar_bg_color, "}",    rectangle(x0, y0, Math.round(w), bar_h, 1));
		var progress_bar = "\n".concat(default_pre, bar_color, "}", rectangle(x0, y0, Math.round(percent_pos*0.01*w), bar_h, 1));
		
		ov.res_x = osd_dims.w; // res_x, res_y (default: 0, 720) >> change to osd-dimensions (.w, .h)
		ov.res_y = osd_dims.h;
		if (osd_dims.h <359.9) t_readout=""; // don't display the time readout if osd height is less than 360 pixels. 
		ov.data = msg_default + msg + t_readout + bg_bar + progress_bar;
		ov.update();
	}
}

mp.observe_property("osd-dimensions", "native", function(name, value) {
 	osd_dims = value;
	print(osd_dims.w, 'x', osd_dims.h);
	update_bar();
});

mp.observe_property("percent-pos", "number", function(name, value) {
 	percent_pos = value;
	update_bar();
});