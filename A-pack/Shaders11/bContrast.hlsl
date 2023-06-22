// $MinimumShaderProfile: ps_4_0
#define bk 10
#define wh 245

/* --- bContrast (dx11), aka 16-235mod to 0-255 --- */
/* v1.02 (06/2023) released by butterw under GPLv3
(1 texture, 1 arithmetic)

Expands the rgb histogram, increasing the contrast.
Can be useful to lift the haze on lackluster internet videos.

Modified version of the MPC-HC shader "16-235 to 0-255.hlsl".
allows custom values instead of (16, 235) for the new rgb black/white points, 
ex: (bk: 10, wh: 245)

c0 = (c0 -const_1) *const_2 = c0*const_2 -const_1*const_2
c0 =  c0*255./(wh-bk) - bk/255.*255./(wh-bk)
c0 =  (c0*255. - bk) /(wh-bk)
	with c0: pixel.rgb in [0, 1.0]

*/
Texture2D tex : register(t0);
SamplerState samp : register(s0);
#define const_1 ( bk/255.)
#define const_2 (255.0/(wh-bk))

float4 main(float4 pos : SV_POSITION, float2 coord : TEXCOORD) : SV_Target {
	float4 c0 = tex.Sample(samp, coord);

	return (c0 -const_1) *const_2;
}
