// $MinimumShaderProfile: ps_4_0
#define Vibrance 0.35

/* --- vibrance (dx11) --- */
/* v1.40 (2023-07) released by butterw under GPLv3
(1 texture, 9 arithmetic).

Smart saturation (or desaturation). Protects skin tones from excessive adjustments.

- Vibrance parameter, [-1, 1.0], 0: no effect 
>> Positive: saturates low-saturation pixels first, ex: 0.35
negative: reduces saturation of high-saturation pixels first, ex: -0.15

Simplified version of SweetFx.Vibrance. 
Calculates a saturation measure, then applies saturation based on it.
Affects color only, no effect on grays.  
*/

Texture2D tex: register(t0);
SamplerState samp: register(s0);
#define CoefLuma float4(0.2126, 0.7152, 0.0722, 0) //sRGB, HDTV

float4 main(float4 pos: SV_POSITION, float2 coord: TEXCOORD): SV_Target {
	float4 c0 = tex.Sample(samp, coord);

	float colorSat = max(max(c0.r, c0.g), c0.b) - min(min(c0.r, c0.g), c0.b); // >=0, 5 arithmetic
	colorSat = 1.0+Vibrance -abs(Vibrance)*colorSat;
	c0.rgb = lerp(dot(c0, CoefLuma), c0.rgb, colorSat);
	return c0;
}