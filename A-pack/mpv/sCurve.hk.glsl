//!HOOK MAIN
//!BIND HOOKED
//!DESC sCurve (sigmoid)

#define S 0.05 
/* --- sCurve (mpv glsl.hook) --- 
/* v1.40 (2023-11) released by butterw under GPLv3
(1 texture, 12 arithmetic)

Boosts (or reduces) midtone contrast by applying a blended s-curve (based on a Sigmoid).
- With S>0:
Reduces contrast in darks and brights, but doesn't clip them. For small values of S, brightness of darks and brights isn't affected much.
When clipping is undesirable, an S-curve provides a good alternative to a broader contrast.10 (or expand10_245) adjustment.

- With S<0: inverse S-curve.
reduces midtone contrast, but increases contrast in darks and brights.

Sigmoid equation
out = 1.0/( 1.0 + exp(-14*x +7.0) ) = 1.0/( 1.0 + exp(-14(x-0.5))   
	with x, out: pixel.rgb in [0, 1.0].

The curve is symmetrical around the midpoint (x=0.5) and doesn't change the Black point (x=0) or White point (x=1).
Contrast boost at the midpoint: S*2.5.
Contrast degradation at the Black and White points: S.

parameter S, Blending Strength, [-1.0, 1.0], 0: no effect, typ: [-0.2, 0.2]
- Positive: increases midtone contrast, ex:0.05
Not good with dark scenes, especially with higher values of S, because of the reduced contrast (and brightness) in Shadows.
It is not typically necessary to increase contrast for movies (though a low Strength s-curve adjustment could be beneficial in special cases, ex: faded colors in older films).

Alternative s-curve equation
out = 0.5 + x1/( 0.5 + abs(x1) )
	with x1 = x - 0.5.  
This is curve #2 in sweetfx.curves. ex: s2(0.125) and is slightly simpler to calculate, (1 texture, 9 arithmetic). 
Sigmoid has higher peak contrast boost, and less contrast/brightness degradation in darks, but has a narrower midtone contrast boost.
Contrast boost at the midpoint: S.
Contrast degradation at the Black and White points: S/2.
	
*/
vec4 hook(){
	vec4 c0 = HOOKED_texOff(0);
	
	c0.rgb = mix(c0.rgb, 1/( 1.0 + exp(-14*c0.rgb +7) ), S);
	return c0; 
}
