'use strict';

//* --- switch-shaders.js mpv script --- */ 
//* part of A-pack v1.40 by butterw
//- modified from https://github.com/mpv-player/mpv/issues/8512
//
// This script extends the mpv video-player by providing a switch to disable/restore current shaders.
//  
// To install, copy this file to the mpv subfolder: .\portable_config\scripts (assuming a Windows portable install).
// Then add a keybinding for the switch (ex: CTRL+p) in input.conf, ex:
//  CTRL+p script-message switch-shaders
//
//*

var shaders_status= [] 
mp.register_script_message("switch-shaders", function() {
	var shaders_str = mp.get_property("glsl-shaders");
	if (!shaders_str.length && shaders_status.length) { //shaders-on: restore glsl-shaders (but only if empty!)
		shaders_status.forEach(function(shader) {mp.commandv("change-list", "glsl-shaders", "append", shader)});
		mp.osd_message(mp.get_property("glsl-shaders"), 0.5)
		print("shaders-on:", shaders_status)		
		shaders_status = []		
	} else { //shaders-off: store current glsl-shaders	
		shaders_status = mp.get_property("glsl-shaders").split(',')
		mp.set_property("glsl-shaders", "")
		mp.osd_message("shaders-off", 0.5)
		//print("shaders-off", shaders_status)
	}
});

var is_first_run = true 
var shaders = ""