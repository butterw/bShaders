//!HOOK OUTPUT
//!BIND HOOKED
//!DESC CrossHatch

/* CrossHatch (style Effect for video content)
A different effect is produced based on HOOK point: LUMA (colors) or OUTPUT/MAIN (Red + 2 grays + White) 

adapted to mpv .hook by butterw 
from https://github.com/pixijs/pixi-filters/blob/master/filters/cross-hatch/src/crosshatch.frag (MIT License)
*/

#define Hatch_mode 2 //default: 2 [0, 1, 2, 3] 
#define White vec4(245, 245, 245, 255)/255.

vec4 hook(){
#define _hatch 1.25*pow(2, Hatch_mode) 
    vec4 color = White; //Background Color
    float lum = length(HOOKED_texOff(0).rgb); //Gray
	
	float coords_sum  = gl_FragCoord.x + gl_FragCoord.y;
	float coords_diff = gl_FragCoord.x - gl_FragCoord.y;
	
	
    if ((lum < 1.) && mod(coords_sum, _hatch) == 0.) // */*
		color = vec4(0.25);

    if ((lum < 0.75) && mod(coords_diff, _hatch) == 0.) // *\*
        color = vec4(1., 0, 0, 1); //Red

    if ((lum < 0.50) && mod(coords_sum -5, _hatch) == 0.) // */offset*
        color = vec4(0.5);

    if ((lum < 0.3) && mod(coords_diff -5, _hatch) == 0.0)// *\offset* 
        color = vec4(0.5);
return color;
}
