#define Red float4(1, 0, 0, 0)

/* test_linearSampling1_motif (pass-1)
Generates a black and white stripe test motif (8 pixels wide)

use:
PreResize=.\test_linearSampling1_motif;.\test_linearSampling2_result.hlsl;
*/

//sampler s0: register(s0);
sampler s0 = sampler_state {
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;//Point;
	AddressU = Clamp;	
};
float2  p0: register(c0);
float2  p1: register(c1); //pixel width


/* --- Main --- */
float4 main(float2 tex: TEXCOORD0): COLOR {

/* in hlsl (vs glsl) texel centers are located mid-texel (first center: 0.5 pixels)*/
//if (tex.x < 0.4*p1.x) return Red; // no print instruction in hlsl, for testing the only output is the screen !
if (frac(tex.x*p0.x/16) <0.5) return 1;
return 0;
}
