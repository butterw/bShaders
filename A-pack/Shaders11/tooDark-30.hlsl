// $MinimumShaderProfile: ps_4_0
#define Multiply -0.30

/* --- tooDark (dx11) --- */
/* v1.35 (2023-07) released by butterw under GPLv3
 (1 texture, 3 arithmetic)

Apply when the picture is too dark. 
Black and White point are not changed (no clipping). 

Photoshop Screen Blend, brightness/contrast curve: 
c0 = (1-Multiply)*c0 + Multiply*c0*c0
	with c0: pixel.rgb in [0, 1.0] 
	and Multiply<=0 

parameter Multiply [-1, 1.0], 0: no effect.
>> negative: (Screen Blend) increases brightness, increases constrast in shadows, ex: -0.30 
	- Brightness increase is maximum at the mid-point.
	- Contrast = 2*Multiply*c0+1-Multiply 
	Contrast is maximum: (1-Multiply) at the black point and decreases linearly with input level. 
	Contrast:1 at the mid-point.
positive: (Multiply Blend) decreases brightness, increases contrast in highlights.

*/
Texture2D tex: register(t0);
SamplerState samp: register(s0);


float4 main(float4 pos: SV_POSITION, float2 coord: TEXCOORD): SV_Target {
	float4 c0 = tex.Sample(samp, coord);

	c0.rgb = lerp(c0, c0*c0, Multiply).rgb;
	return c0;
}