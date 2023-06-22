// $MinimumShaderProfile: ps_4_0
#define bk 10
#define wh 245

/* --- bContrast (dx11), aka 16-235mod to 0-255 --- */
/* v1.01 (06/2023) released by butterw under GPLv3
(1 texture, 1 arithmetic)

modified version of the MPC-HC shader "16-235 to 0-255.hlsl".
allows custom values instead of just (16, 235) for the rgb black and white points.

Default parameters (bk: 10, wh: 245) for the rgb black and white points.
pixel.rgb = (pixel.rgb -const_1) *const_2 = pixel.rgb*const_2 -const_1*const_2
Expands the rgb histogram, increasing the contrast.
Can be useful to lift the haze on lackluster internet videos.

*/
Texture2D tex : register(t0);
SamplerState samp : register(s0);
#define const_1 ( bk/255.)
#define const_2 (255.0/(wh-bk))

float4 main(float4 pos : SV_POSITION, float2 coord : TEXCOORD) : SV_Target {
	float4 c0 = tex.Sample(samp, coord);

	return (c0 -const_1) *const_2;
}