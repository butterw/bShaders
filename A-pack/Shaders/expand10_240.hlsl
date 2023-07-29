// $MinimumShaderProfile: ps_2_0
#define bk 10
#define wh 240

/* --- expandB_W (dx9) xB_W --- */
/* v1.40 (07/2023) released by butterw under GPLv3
(1 texture, 1 arithmetic)

Expands the rgb histogram by applying the levels curve, increasing the contrast.
Can be useful to lift the haze on lackluster internet videos.

! Parameter values (bk, wh) use rgb8 color scale [0, 255.0], not [0, 1.0].
bk: new black point, wh: new white point, (bk:0, wh:255): no effect
! Any input below bk, or above wh will be clipped.

Modified version of the MPC-HC shader "16-235 to 0-255.hlsl".
allows custom values instead of (16, 235) for the new rgb Black/White points
	ex: (bk: 10, wh: 240), contrast=1.109
	The 2 parameters allow for asymmetrical expansion (bk!= 255-wh) which is not available with the (single parameter) constrast shader.

Levels curve is a linear equation:
out = (x -const_1) *contrast = x*contrast -const_1*contrast
	with contrast = 255.0/(wh-bk)
	and x, out: input, output pixel.rgb in [0, 1.0].
out = (x*255. -bk) /(wh-bk)

*/
sampler s0: register(s0);
#define const_1   (bk/255.)
#define constrast (255.0/(wh-bk))

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex);

	c0.rgb = c0.rgb*constrast -const_1*constrast;
    return c0;
}