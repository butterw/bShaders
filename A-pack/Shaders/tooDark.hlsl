// $MinimumShaderProfile: ps_2_0
#define Multiply -0.3

/* --- tooDark (dx9) --- */

/* v1.30 (2023-07) released by butterw under GPLv3
 (1 texture, 3 arithmetic)


Photoshop Screen or Multiply Blend brightness/contrast curves 
c0 = (1-Multiply)*c0 + Multiply*c0*c0
	with c0: pixel.rgb in [0, 1.0]

parameter Multiply [-1, 1], 0: no effect
positive: (Multiply Blend) decreases brightness and increases contrast in highlights without clipping.
negative: (Screen Blend)   increases brightness and constrast in shadows without clipping. 
	Apply when picture is too dark. ex: Outdoor night shots, ex: -0.3.

*/

sampler s0: register(s0);


float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex);
	
	c0.rgb = lerp(c0, c0*c0, Multiply).rgb;
	return c0;
}