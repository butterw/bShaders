// $MinimumShaderProfile: ps_2_0
#define Multiply 0.30

/* --- tooBright (dx9) --- */

/* v1.31 (2023-07) released by butterw under GPLv3
 (1 texture, 3 arithmetic)

Apply when the picture is too bright. 
Black and White point are not changed (no clipping). 

Photoshop Multiply Blend, brightness/contrast curve: 
c0 = (1-Multiply)*c0 + Multiply*c0*c0
	with c0: pixel.rgb in [0, 1.0]

parameter Multiply [-1, 1.0], 0: no effect, ex: 0.3.
positive: (Multiply Blend) decreases brightness and increases contrast in highlights.
	Contrast increases linearly with input level and is maximum at the white point.
negative: (Screen Blend)   increases brightness and constrast in shadows. 	 
*/

sampler s0: register(s0);


float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex);
	
	c0.rgb = lerp(c0, c0*c0, Multiply).rgb;
	return c0;
}