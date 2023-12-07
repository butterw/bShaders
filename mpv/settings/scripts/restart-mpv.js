'use strict';
mp.add_key_binding("Shift+F5", "restart-mpv", restart_mpv); // input.conf: Shift+F5 script-binding restart-mpv
//mp.register_script_message("restart-mpv", restart_mpv);   // input.conf: Shift+F5 script-message restart-mpv

/* --- restart-mpv.js (mpv script) --- */
/* v0.20 by butterw (2023/12). tested on Win10.  
v0.20 requires mpv v0.37-dev (v0.37.0-70-g562450f5)
v0.11 by butterw (2023/12/06), tested on Win10 with mpv 0.36 and 0.37-dev.

restarts mpv: keeps current shaders (and recompiles them if the source code was modified).
*/

function restart_mpv() {
	var s = "--glsl-shaders="+ mp.get_property("glsl-shaders"); 
	print("restart mpv", s);
	mp.commandv("run", "mpv.com", mp.get_property("path"), s);
	mp.command("quit");
}
