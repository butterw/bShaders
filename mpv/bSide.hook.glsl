//!HOOK MAIN
//!BIND HOOKED
//!DESC bSide_ex

/* bSide.hook by butterw
hook: MAIN, OUTPUT, LUMA, NATIVE
Apply different effects to different parts of the screen.

Input is typically a single video file. To display multiple video files use ffmpeg (or avisynth) as input, ex:
mpv --lavfi-complex="[vid1][vid2]hstack[vo]" "b:\Videos\file1.mp4" --external-file="b:\Videos\file2.mp4"
goal is typically for comparison purpose: No Effect (O) vs. Shader
OR to simulataneously display 4 different image channels/effects (ex: ROGB)

Input >> Shader Output: 
Splitscreen:  A | B      
Side-by-side: A0| A1 
>> can also be applied to vertical splitscreen 

Quad display (2x2), ex: 
.r  Original
.g .b
*/

#define pos HOOKED_pos
vec4 fx(vec4 color){ //example effect
	return 1-color; //invert
}	

vec4 hook() {
vec4 color = HOOKED_tex(pos);

/* Select desired output: */
#if 1 //2x2 channel display, ex rO-gb
	vec4 c1 = HOOKED_tex(2*pos -step(0.5, pos));
	if (pos.x<0.5) c1 = (pos.y<0.5) ? vec4(c1.r): vec4(c1.g);
	else c1 = (pos.y<0.5) ? c1: vec4(c1.b);
	return c1;
#elif 0 //side-by-side: fx(R)| R
	if (pos.x<0.5) return HOOKED_tex(pos+vec2(0.5, 0)); 
	return fx(color);
#else 
    // if (pos.x<0.5) return color; // Splitscreen: O | fx
	if (pos.y<0.5) return color; //Vertical splitscreen 
	return fx(color);	
#endif
}