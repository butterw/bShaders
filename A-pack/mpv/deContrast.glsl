//!HOOK MAIN
//!BIND HOOKED
//!DESC deContrast

#define S -0.07
#define n 4 

/* --- deContrast (mpv glsl.hook) --- */

/* v1.50 (2023-11) released by butterw under GPLv3
n:4 (1 texture, 6 arithmetic).
(with S<0, ex: -0.07) Reduces midtone contrast. Also boosts contrast in shadows/highlights.

# Sn brightness/contrast curve
out = f(x, S) = x + S/2*(2*x-1) *(1-(2*x-1)^n) = x + S/2*x1 *(1-x1^n)
    with n even >0 (ex: 4, 6, 8, 16, etc.)
    and x1 = 2*x -1
    and x, out pixel.rgb in [0, 1.0].

# Brightness
f(x:0)=0; f(0.5)=0.5; f(1)=1.
S<0: brightness is increased below the midpoint (x: 0.5) and decreased above the midpoint.

# Contrast
- contrast(x:0.5): 1+S
- contrast(x:0)=contrast(x:1): 1-S*n


Parameter S [-0.15, 0.15], 0: no effect
- S>0: This symmetrical S-curve is a smoothed version of the contrast/levels linear curve. It provide a constant contrast increase (S) for a wide midtone range (with n=4+), and while it doesn't clip, contrast is decreased (up to S*n) in the highlights/shadows region. Because of this the sigmoid (sCurve shader) is probably a better choice for increasing contrast.
- S<0: inverse S-curve. Now contrast is decreased by a constant value (S) in a wide midtone range and contrast is increased in the Shadows/Highlights (by |S|*n at x=0 and x=1).
The plot https://github.com/butterw/bShaders/blob/master/img/deContrast_vs_contrast.png compares the contrast for different adjustment methods. This shader can be used to correct over-contrasted videos to get a more natural looking result. It's also good for restoring contrast/improving brightness in dark or bright videos.

Parameter n, even integer [4: default, 8, 16, 6, ..]
The higher n is, the wider the midtone contrast decrease range (with S<0) but also the stronger the contrast increase in highlights/shadows.
n:8 (1 texture, 7 arithmetic)
n:4 (1 texture, 6 arithmetic), default
n:2 (1 texture, 5 arithmetic), S3(S/2) Hermite smoothstep interpolation. no flat midtone contrast decrease range.
*/

vec4 hook(){
	vec4 c0 = HOOKED_texOff(0);
	
	vec3 c1 = 2*c0.rgb -1;
	#if   n == 2
	c0.rgb+= 0.5*S *c1 *( 1.0 -c1*c1);
	#elif n == 4
	vec3 c2 = c1*c1;
	c0.rgb+= 0.5*S *c1 *( 1.0 -c2*c2);
	#elif n == 8
	vec3 c2 = c1*c1; c2 = c2*c2;
	c0.rgb+= 0.5*S *c1 *( 1.0 -c2*c2);	
	#else
	c0.rgb+= 0.5*S *c1 *( 1.0 -pow(c0, vec3(n)) );
	#endif
	
	return c0; 
}