// $MinimumShaderProfile: ps_2_0
#define Exposure 0.20


/* --- bExposure (dx9) --- */
/* v1.0 (06/2023) released by butterw under GPLv3
/* (1 texture, 1 arithmetic)

pixel.rgb = pixel.rgb *(1.0+Exposure) = pixel.rgb + pixel.rgb*Exposure 

- parameter Exposure, [-1, 1], default: -0.1, 0: no change
Exposure is an alternative way to increase/decrease brightness.

*/

sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex);

	return c0 *(1.0 + Exposure);
}
