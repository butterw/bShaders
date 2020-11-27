//!HOOK MAIN
//!BIND HOOKED
//!DESC bSat

#define SatFactor 2.43 //0: gray, 1: no change, >1:Saturated ex:2.43

/* A lightweight rgb saturation/desaturation shader for mpv 
v0.1 by butterw
hook: MAIN, OUTPUT
*/

vec4 hook(){ 
	vec4 c0 = HOOKED_texOff(0);
	float gray = dot(c0, vec4(1/3., 1/3., 1/3., 0));
	return mix(vec4(gray), c0, SatFactor);
}