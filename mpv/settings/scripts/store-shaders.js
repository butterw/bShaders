'use strict';

// store/restore shaders script for mpv by butterw
// put in .\portable_config\scripts mpv subfolder. 
// input.conf: F9 script-message store-shaders
// https://mpv.io/manual/stable/#javascript

var is_first_run = true 
var shaders = ""
function store_shaders() { //store current shader config on first run, this config will be restored by subsequent calls 
	if (is_first_run) { 
	print("store-shaders", is_first_run)
	shaders = mp.get_property("glsl-shaders")	
	} else { mp.set_property("glsl-shaders", shaders.replace(/,/g, ";"));} //js global string replacement !
	is_first_run = false;
}
mp.register_script_message("store-shaders", store_shaders); 
mp.add_key_binding("F9", "store-shaders", store_shaders); //hotkey will be overriden by input.conf if a binding for the same key is defined or pre-defined.
store_shaders() //optional: auto-store initial shader config 
