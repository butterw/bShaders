// $MinimumShaderProfile: ps_4_0
#define Shadows -0.10

/* --- bShadows (dx11) --- */
/* v1.0 (2023-06) released by butterw under GPLv3


pixel.rgb = pixel.rgb + Shadows*(1-luma)**4

- Shadows Parameter (default value: -0.10)
negative: darkens the shadows, 0: no change, positive: lighten the shadows   

*/

#define LumaCoef float4(0.2126, 0.7152, 0.0722, 0)

Texture2D tex : register(t0);
SamplerState samp : register(s0);

float4 main(float4 pos : SV_POSITION, float2 coord : TEXCOORD) : SV_Target {
	float4 c0 = tex.Sample(samp, coord);
	float shadowsBleed = 1.0 - dot(c0, LumaCoef);
	shadowsBleed *= shadowsBleed;
	shadowsBleed *= shadowsBleed;

	return c0 + Shadows * shadowsBleed;
}
