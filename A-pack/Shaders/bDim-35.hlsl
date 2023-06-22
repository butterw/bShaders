// $MinimumShaderProfile: ps_2_0
#define Exposure -0.35


/* --- bDim (dx9), bExposure with a negative value --- */
/* v1.0 (06/2023) released by butterw under GPLv3
/* (1 texture, 1 arithmetic) 


c0 = c0 *(1.0+Exposure) = c0 + c0*Exposure, with c0: pixel.rgb 

Dims or lights-up the video
- parameter Exposure, [-1, ..], default: -0.1, 0: no change, -1: All black. 
negative: dims, positive: lights-up
 
c0 = c0 *(1.0+Exposure) = c0 + c0*Exposure, with c0: pixel.rgb

*/

sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex);

	return c0 *(1.0 + Exposure);
}