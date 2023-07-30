// $MinimumShaderProfile: ps_4_0
#define Contrast 0.10

/* --- contrast (dx11) --- */
/* v1.40 (07/2023) released by butterw under GPLv3
(1 texture, 1 arithmetic)

Increases (or decreases) contrast by symmetrical expansion of the rgb histogram around the mid-point (0.5, 0.5). 	
For asymmetrical expansion use the shader expandB_W (bk, wh) instead.

out = x + Contrast*(x-0.5) = (1+Contrast)*x -0.5*Contrast
	with x, out: pixel.rgb in [0, 1.0]
	
Mid-point is unaffected by contrast.
contrast, d/dx: 1+Contrast
brightness change: Contrast*(x-0.5)

parameter Contrast, [-1.0, ..], 0: no effect, -1: All mid-gray (0.5)
>> Positive: increases the contrast, ex: 0.10
brightness is increased above the mid-point, and decreased below the mid-point.
! input will be clipped:
	<   Contrast/2. *1/(1+Contrast) 
	> 1-Contrast/2. *1/(1+Contrast)
for Contrast 0.10: clips <0.0455 and >0.954 
	
negative: decreases the contrast.

*/
Texture2D tex: register(t0);
SamplerState samp: register(s0);

float4 main(float4 pos: SV_POSITION, float2 coord: TEXCOORD): SV_Target {
	float4 c0 = tex.Sample(samp, coord);

	c0.rgb = c0.rgb*(1 +Contrast) -0.5*Contrast;
	return c0;
}