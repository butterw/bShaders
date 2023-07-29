// $MinimumShaderProfile: ps_2_0
#define SatFactor -0.25

/* --- dSat (dx9) --- */
/* v1.40 (2023-07) released by butterw under GPLv3
 (1 texture, 3 arithmetic)

A lightweight desaturation shader with a touch of red exposure to avoid pasty grey skintones.
faster than vibrance-15.

param SatFactor [-1, ..], 0: no Effect, -1: Gray
negative: desaturation, ex:-0.25

*/
#define rExposure float3(0.05, 0.008, 0)
#define LumaCoef float4(0.2126, 0.7152, 0.0722, 0)

sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex);

	float gray = dot(c0, LumaCoef);
	c0 = lerp(gray, c0, 1.0 + SatFactor);
	c0.rgb = c0.rgb *(1.0 + rExposure);
	return c0;
}