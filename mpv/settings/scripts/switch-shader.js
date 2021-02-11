'use strict';
var shaders_status= []
var vf_status= []

// put in .\portable_config\scripts subfolder. 
// input.conf: CTRL+p script-message switch-shaders
// input.conf: CTRL+l script-message switch-vf
// modified from https://github.com/mpv-player/mpv/issues/8512 by butterw 
// - v0.1 added similar functionality for ffmpeg video filters (vf) 
// doc: https://mpv.io/manual/stable/#javascript

 
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
		print("shaders-off", shaders_status)
    }
});

mp.register_script_message("switch-vf", function() {
	var vf_str = mp.get_property("vf");
    if (!vf_str.length && vf_status.length) { //video filter-on: restore vf (but only if vf is empty!)
		vf_status.forEach(function(vfilter) {mp.commandv("change-list", "vf", "append", vfilter)});
		print("vf-on:", vf_status) //mp.msg.info()
		vf_status = []
    } else { //vfilter-off: store current vf 
        vf_status = mp.get_property("vf").split(',')
		mp.set_property("vf", "")
		mp.osd_message("vf-off", 0.5)
		print("vf-off", vf_status)
    }	
});
