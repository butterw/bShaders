// $MinimumShaderProfile: ps_4_0
#define Exposure 0.20


/* --- bExposure (dx11) --- */
/* v1.01 (06/2023) released by butterw under GPLv3
(1 texture, 1 arithmetic)

Exposure is an alternative way to increase/decrease brightness.

c0 = c0 *(1.0+Exposure) = c0 + c0*Exposure, with c0: pixel.rgb 
- parameter Exposure, [-1, 1], 0: no change
positive increases brightness, ex: 0.20

*/

Texture2D tex : register(t0);
SamplerState samp : register(s0);

float4 main(float4 pos : SV_POSITION, float2 coord : TEXCOORD) : SV_Target {
	float4 c0 = tex.Sample(samp, coord);

	return c0 *(1.0 + Exposure);
}
