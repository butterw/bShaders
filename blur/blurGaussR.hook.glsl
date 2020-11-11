/* Fast pixel shader gaussian blur (2 passes: Horiz. followed by Vert. Pass) 
by butterw

req. 5 texel reads per pixel per pass.
Separable Gaussian Kernel + hw linear sampling (9-tap filter approx.):  
http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
 
--glsl-shaders="./s/blurGaussR.hook;./s/blurGauss.hook;./s/blurGauss.hook"
blurGaussR.hook: Downscales the input texture by 2, to increase blur strength.
	WIDTH HOOKED.w 2 /
	HEIGHT HOOKED.h 2 /
blurGauss.hook: no Downscaling
*/

//!HOOK MAIN
//!BIND HOOKED
//!WIDTH HOOKED.w 2 /
//!HEIGHT HOOKED.h 2 /
//!DESC blurGaussR

#define Offsets vec3(0.0, 1.3846153846, 3.2307692308)
#define K		vec3(0.2270270270, 0.3162162162, 0.0702702703)

vec4 hook(){ //Horiz Pass
	vec4 c0 = HOOKED_tex(HOOKED_pos) *K[0];
	uint i=1; //unroll loop			
        c0+= HOOKED_tex(HOOKED_pos +HOOKED_pt*vec2(Offsets[i], 0)) *K[i];
        c0+= HOOKED_tex(HOOKED_pos -HOOKED_pt*vec2(Offsets[i], 0)) *K[i];
	i=2;
        c0+= HOOKED_tex(HOOKED_pos +HOOKED_pt*vec2(Offsets[i], 0)) *K[i];
        c0+= HOOKED_tex(HOOKED_pos -HOOKED_pt*vec2(Offsets[i], 0)) *K[i];
	return c0;
}


//--------------------------------------------
//!HOOK MAIN
//!BIND HOOKED
//!DESC blurGauss_Y

#define Offsets vec3(0.0, 1.3846153846, 3.2307692308)
#define K		vec3(0.2270270270, 0.3162162162, 0.0702702703)

vec4 hook(){ //Vert. Pass
	vec4 c0 = HOOKED_tex(HOOKED_pos) *K[0];
	uint i=1; //unroll loop			
        c0+= HOOKED_tex(HOOKED_pos +HOOKED_pt*vec2(0, Offsets[i])) *K[i];
        c0+= HOOKED_tex(HOOKED_pos -HOOKED_pt*vec2(0, Offsets[i])) *K[i];
	i=2;
        c0+= HOOKED_tex(HOOKED_pos +HOOKED_pt*vec2(Offsets[i], 0)) *K[i];
        c0+= HOOKED_tex(HOOKED_pos -HOOKED_pt*vec2(Offsets[i], 0)) *K[i];
	return c0;
}
