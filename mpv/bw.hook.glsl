//!HOOK MAIN
//!BIND HOOKED
//!DESC Black&White

#define CoefMonochrome vec4(0.18, 0.41, 0.41, 0) 

/* custom RGB grayscale conversion v0.1 
shader tested on mpv v0.33 by butterw

vec4(0.18, 0.41, 0.41, 0) //Agfa 200X from SweetFx.Monochrome
vec4(1/3., 1/3., 1/3., 0) //Equal weight
vec4(0.2126, 0.7152, 0.0722, 0) //sRGB, HDTV Luma
*/

vec4 hook(){ 
	vec4 c0 = HOOKED_texOff(0);
	return vec4(dot(c0, CoefMonochrome));
}