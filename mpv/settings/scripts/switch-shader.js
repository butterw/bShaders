'use strict';
var shader_status= [];

// mpv: disable/enable all shaders with a switch hotkey
// modified from https://github.com/mpv-player/mpv/issues/8512 by butterw
// https://mpv.io/manual/stable/#javascript
// put in .\portable_config\scripts subfolder. 
// input.conf: CTRL+p script-message switch-shaders
 
mp.register_script_message("switch-shaders", function() {
    if (shader_status.length) { //shaders-on: restore glsl-shaders
        shader_status.forEach(function(shader) {  
            mp.commandv("change-list", "glsl-shaders", "append", shader);
        });
		shader_status = [];
		// mp.osd_message("shaders-on", 0.5)	
		mp.osd_message(mp.get_property("glsl-shaders"), 0.5) 
    } else { //shaders-off: store current glsl-shaders  
        shader_status = mp.get_property("glsl-shaders").split(',');
		mp.set_property("glsl-shaders", "")
		mp.osd_message("shaders-off", 0.5)
    }
});
