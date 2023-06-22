// $MinimumShaderProfile: ps_4_0
#define Lift 0.05

/* --- bLift (dx11) --- */
/* v1.0 (2023-06) released by butterw under GPLv3 

pixel.rgb = pixel.rgb*(1 -0.5*Lift) +0.5*Lift
- rgb Lift Parameter (default value: 0.05)
negative: darkens the image, 0: no change, positive: lightens the image
  
Lift limits image burn-out vs a brightness adjustment (rgb shift): 
pixel.rgb = pixel.rgb + Brightness 
*/

Texture2D tex : register(t0);
SamplerState samp : register(s0);

float4 main(float4 pos : SV_POSITION, float2 coord : TEXCOORD) : SV_Target {
	float4 c0 = tex.Sample(samp, coord);

	return c0*(1 -0.5*Lift) +0.5*Lift;
}