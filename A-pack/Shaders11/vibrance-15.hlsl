// $MinimumShaderProfile: ps_4_0
#define Vibrance -0.15

/* --- vibrance (dx11) --- */
/* v1.10 (2023-06) released by butterw under GPLv3
simplified version of SweetFx.Vibrance
 (1 texture, 10 arithmetic)

- Vibrance parameter, [-1.0, ..], 0: no effect 
positive: saturates low-saturation pixels more
negative: reduces saturation of high-saturation pixels more, ex: -0.15
*/

Texture2D tex : register(t0);
SamplerState samp : register(s0);

#define CoefLuma float4(0.2126, 0.7152, 0.0722, 0) //sRGB, HDTV

float4 main(float4 pos : SV_POSITION, float2 coord : TEXCOORD) : SV_Target {
	float4 c0 = tex.Sample(samp, coord);

	
	float2 colorxy = (c0.r > c0.g) ? c0.gr: c0.rg;
	float colorSat = max(c0.b, colorxy.y) -min(c0.b, colorxy.x); // max3(r,g,b)-min3(r,g,b): >0
    c0.rgb = lerp(dot(CoefLuma, c0), c0.rgb, 1.0+Vibrance-colorSat*abs(Vibrance));

	return c0;
}