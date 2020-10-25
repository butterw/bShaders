//!HOOK LUMA //OUTPUT
//!BIND HOOKED
//!DESC dots

#define Scale 0.45 //[0.3, 0.6] default: 0.4. Higher for smaller dots

/* default hook: LUMA >> Luma Dots + Chroma
Art/Style Effect for Video content

adapted/mod by butterw from https://github.com/pixijs/pixi-filters/blob/master/filters/dot/src/dot.frag (MIT License)
...grayscale, mostly black and white version: OUTPUT+CHROMA hooks, can use 2instances.
*/

float pattern(){
	#define Angle 5.
	float s = sin(Angle), c = cos(Angle);
    vec2 coord = HOOKED_pos * input_size;
    vec2 pt = Scale* vec2(dot(vec2(c, -s), coord), dot(vec2(s, c), coord));
	vec2 sp = sin(pt); 
    return 4 *sp.x *sp.y;
}

vec4 hook(){
	float luma = HOOKED_texOff(0).r;    
	return vec4(clamp(10*luma-5 + pattern(), 16/255., 245/255.)); // Clamped output
    // return vec4(10*luma-5 + pattern());
}

//!HOOK NONE //CHROMA
//!BIND HOOKED
//!DESC NoChroma

/* default hook: NONE, if activated zeroes out Chroma */
vec4 hook() {
	return vec4(0.5); //zeroes out Chroma: Luma Only
}
