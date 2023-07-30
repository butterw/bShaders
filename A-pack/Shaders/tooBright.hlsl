// $MinimumShaderProfile: ps_2_0
#define Multiply 0.20

/* --- tooBright (dx9) --- */
/* v1.40 (2023-07) released by butterw under GPLv3
 (1 texture, 3 arithmetic)

Apply when the picture is too bright.
Decreases brightness without clipping (Black point and White point are not changed).

Photoshop Multiply Blend, brightness/contrast curve:
out = (1-Multiply)*x + Multiply*x*x = Multiply*x^2 -Multiply*x +x
	with x, out: pixel.rgb in [0, 1.0]
	and Multiply>=0

parameter Multiply [-1, 1.0], 0: no effect.
>> Positive: (Multiply Blend) decreases brightness. Increases contrast in highlights. ex: 0.20
	- Brightness decrease is maximum at the mid-point (-Multiply/4).
	- Contrast = 2*Multiply*x +1-Multiply
	Contrast increases linearly with input level and is maximum at the White point (1+Multiply).
	Contrast: 1 at the mid-point.

negative: (Screen Blend) increases brightness.

*/
sampler s0: register(s0);


float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex);

	c0.rgb = lerp(c0, c0*c0, Multiply).rgb;
	return c0;
}