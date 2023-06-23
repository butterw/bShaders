// $MinimumShaderProfile: ps_2_0
#define Contrast 0.10

/* --- contrast (dx9) --- */
/* v1.10 (06/2023) released by butterw under GPLv3
(1 texture, 1 arithmetic)

Increases or decreases contrast by symmetrical expansion of the rgb histogram around 0.5. 	

c0 = c0 + Contrast*(c0-0.5)=c0*(1+Contrast)-0.5*Contrast
	with c0: pixel.rgb in [0, 1.0]

Parameter Contrast, [-1.0, ..], 0: no effect
-100: All mid-gray (0.5)
positive: increases the Contrast, ex: 0.10
negative: decreases the Contrast.

the mid-point (0.5) is unaffected by Contrast.

Alternative: the shader contrastBW(bk, wh) allows symmetrical and asymmetrical expansion.

*/
sampler s0: register(s0);


float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex);

    return c0*(1 +Contrast) -0.5*Contrast;
}