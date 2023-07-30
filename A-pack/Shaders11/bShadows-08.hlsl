// $MinimumShaderProfile: ps_4_0
#define Shadows -0.08

/* --- bShadows (dx11) --- */
/* v1.40 (2023-07) released by butterw under GPLv3
(1 texture, 5 arithmetic)

Darken (or lighten) the shadows.

out = x + Shadows*(1-x)^4
	with x, out: pixel.rgb in [0, 1.0].

- parameter Shadows [-1, 1.0], 0: no change
>> Negative: darkens the shadows, ex: -0.10
Use to ensure shadows are darks, doesn't alter the rest of the picture.
Can be used to correct raised black levels.
for Shadows:-0.10, clipped input <0.0736, first order approximation: clips <S/(4S-1)
	a cheaper alternative would be to use bLift (or expand7_255).

positive: lighten the shadows

*/
#define LumaCoef float4(0.2126, 0.7152, 0.0722, 0)

Texture2D tex: register(t0);
SamplerState samp: register(s0);

float4 main(float4 pos: SV_POSITION, float2 coord: TEXCOORD): SV_Target {
	float4 c0 = tex.Sample(samp, coord);
	float shadowsBleed = 1.0 - dot(c0, LumaCoef);
	shadowsBleed *=shadowsBleed;
	shadowsBleed *=shadowsBleed;
	//shadowsBleed *=shadowsBleed; //tryout: (1-luma)**8

	return c0 + Shadows*shadowsBleed;
}
