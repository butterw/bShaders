#define Offset_sampling 0.5 //0.5 is linear sampling offset, any value different from 0 should produce some interpolation. 

/* test_linearSampling2_result (pass-2)
Linear sampling is a performance optimization exploited by some convolution kernel shaders (such as: LumaSharpen, gaussian blur, etc.). 
This test allows you to determine if it is working as expected.

tested on mpc-hc v1.9.6 + EVR-CP, also tested on mpc-be
on my setup (intel hd4400 igpu), I am seeing Nearest Neighbor (No interpolation) instead of Linear interpolation, with rounding artefacts for Offset_sampling 0.5 !

use:
PreResize=.\test_linearSampling_motif;.\test_linearSampling_result.hlsl;
*/

// sampler s0: register(s0); 
sampler s0 = sampler_state {
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;//Point;
	AddressU = Clamp;	
};

float2  p0: register(c0);
float2  p1: register(c1);
#define Red   float4(1, 0, 0, 0)
#define Green float4(0, 1, 0, 0)

/* --- Main --- */
float4 main(float2 tex: TEXCOORD0): COLOR {
	// float4 res = lerp(tex2D(s0, tex), tex2D(s0, tex + float2(p1.x, 0)), Offset_sampling);
	float4 res  = tex2D(s0, tex + p1*float2(Offset_sampling, 0)) ;
	if (abs(res.r-0.5)<0.001) return Green; // Expected interpolation for Offset_sampling 0.5 
	if (res.r!=0 && res.r!=1) return Red; // otherwise, if there is any interpolation at all, you will see some red in output
	return res;
}
