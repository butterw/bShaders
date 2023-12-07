'use strict';
/* --- restart-mpv.js (mpv script) --- */
/* v0.10 by butterw (2023/12/06), tested on Win10 with mpv 0.36 and 0.37-dev.

keeps current shaders (and recompiles them if the source code was modified).
*/

mp.add_key_binding("Shift+F5", "restart-mpv", restart_mpv); // (input.conf): Shift+F5 script-binding restart-mpv
//mp.register_script_message("restart-mpv", restart_mpv);   // input.conf:   Shift+F5 script-message restart-mpv

function restart_mpv() {
	var sep = mp.get_property("platform")=="windows" ? ";": ":";
	var s = "--glsl-shaders="+ mp.get_property_native("glsl-shaders");
	s = s.replace(/,/g, sep);
	print("restart mpv", s);
	mp.commandv("run", "mpv.com", mp.get_property("path"), s);
	mp.command("quit");
}