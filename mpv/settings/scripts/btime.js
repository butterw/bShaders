'use strict';

var opts = {
    format: "btime", // <"youtube", "btime", "symetrical", "mpc-hc", "mpv">
    seek: true,
    ms: 1500,
    alt: false,
    percent: false,
};

/* --- btime.js mpv script (short time OSD) --- */
/* v0.40 (release) by butterw (2024/01/19)

v0.40: added option for display with percent progress: (percent-pos%) time-pos, OR with alt: -remaining-time (percent-pos%)
v0.30: --script-opts-add=btime-format=mpc-hc,btime-alt=yes
or script-opts/btime.conf
or runtime: cycle-value script-opts btime-format=mpc-hc,btime-alt=yes

v0.20: handle case where duration is undefined.
use --script=path.to/btime.js OR install by copying to portable_config/scripts (tested on win10).

Short time format for On-Screen-Display.
ex OSD: 0:08 / 1:12, instead of 00:00:08 / 00:01:12.
the modified time strings are shown for a limited duration on OSD on seeks and/or on demand.

Install
1) define hotkey for on demand show, ex: F11
input.conf: F11 script-binding btime/show
2) ! with option seek=true, redefines the `seek` OSD display.
a) use with --osd-on-seek=bar (mpv default) or --no-osd-on-seek
b) Make sure there are no collisions with other loaded user scripts.
3) Configurable via script-opts.

The OSD time format can be customized by the user.
by default, uses a short time format similar to youtube, but better suited for movies (btime).

playtime / duration
00:00:08 / 00:01:12 (mpv default)
   00:08 / 01:12    (mpc-hc, symetrical)
    0:08 / 1:12     (btime, youtube)
  - 1.04 / 1:12     (alt + btime)

 00:06:04 / 01:27:09 (mpv default, mpc-hc)
  0:06:04 / 1:27:09  (symetrical)
    06:04 / 1:27:09  (btime)
     6:04 / 1:27:09  (youtube)
- 1:21:05 / 1:27:09  (alt + btime)

01:02:08 / 01:27:09 (mpv default, mpc-hc)
 1:02:08 / 1:27:09  (btime, youtube, symetrical)
 - 25:01 / 1:27:09  (alt + btime)

*/
mp.options.read_options(opts, "btime", on_update);
function on_update() { //runtime update of script-opts: format, alt, ms
    print("ok, time format:", opts.format);
    duration = fmt_time_str(mp.get_property_osd("duration"));
};
var nbsp = " ";
function printd(pre, x){ print(pre, JSON.stringify(x)) } //printd("x:", x)
var duration; //str

mp.register_event("file-loaded", function() { // every time a new file is loaded, process the duration string
    duration = fmt_time_str(mp.get_property_osd("duration"));
});

function fmt_time_str(t_str) {
    // shortens a time string, ex: duration
    if (t_str === undefined) return "undefined"; //show: returned length needs to be 8 or more.
    if (opts.format!="mpv") {
        if (opts.format=="youtube" && t_str.substring(0, 4)== "00:0") t_str=t_str.substring(4); //youtube (playtime & duration): changes 00:01:12 to 1:12
        else {
            if (t_str.substring(0, 3)== "00:") t_str=t_str.substring(3); //btime, symetrical: changes 00:01:12 to 01:12
            if (opts.format!="mpc-hc" && t_str.charAt(0)=="0") t_str = t_str.substring(1); //btime, symetrical, youtube: drop the leading zero, changes 01:12 to 1:12 and 01:27:09 to 1:27:09
        }
    }
    return t_str;
}

mp.add_key_binding(null, "show", show);// input.conf: F11 script-binding btime/show
if (opts.seek) mp.register_event("seek", show);
function show() {
    var playtime = opts.alt ? mp.get_property_osd("time-remaining"): mp.get_property_osd("playback-time");
    if (playtime === undefined || (duration == "undefined" && playtime=="00:00:00")) return; //ex: image
    if (opts.format!="mpv") {
        if (opts.format=="youtube") playtime = fmt_time_str(playtime);
        else {
            playtime = playtime.substring(8-duration.length); //mpc-hc, symetrical, btime: keep the same digits as duration
            if (opts.format=="btime" && (duration.length==7 && playtime.charAt(0)=="0")) playtime = playtime.substring(2); //btime (playtime): drop leading zero on hours, 00:06:04 to 06:04 / 1:27:09
        }
    }
    if (opts.percent) {
        var percent = mp.get_property_osd("percent-pos", "");
        // if (percent) percent = "".concat("(", percent.length==1 ? "0": "", percent, "%) "); //ex: "(08%) "
        // playtime = "".concat(opts.alt ? "-": "", percent, playtime);
        if (percent) percent = "".concat(" (", percent.length==1 ? "0": "", percent, "%)"); //ex: "(08%) "
        playtime = "".concat(opts.alt ? "-": "", playtime, percent);
    }
    else playtime = "".concat(opts.alt ? "-": "", playtime, " / ", duration); // format the time display
    mp.commandv("show-text", playtime, opts.ms); // display on OSD (message duration: ms)
}
