// $MinimumShaderProfile: ps_2_0
#define Brightness 0.06

/* --- brightenD: rgbShift + bShadows (dx9) --- */
/* v1.40 (2023-07) released by butterw under GPLv3
(1 texture, 5 arithmetic) 

out = x + Brightness -Brightness*(1-x)^4
	with x, out: pixel.rgb in [0, 1.0].

Changes brightness without affecting the black point.

param Brightness, brightness change outside of Shadows [-1, 1.0], 0: no effect
>> positive: increases brightness without raising the black point.
Contrast is increased in Shadows, but otherwise remains unchanged.
! clips input >1-Brightness. 

negative: decreases brightness without clipping Shadows.
output <= 1+Brightness. 
Contrast is decreased in Shadows, but otherwise remains unchanged.

*/
sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR { 
    float4 c0 = tex2D(s0, tex);
	float4 shadowsBleed = 1.0-c0;
    shadowsBleed*= shadowsBleed; 
	shadowsBleed*= shadowsBleed;
	shadowsBleed = -Brightness*shadowsBleed +Brightness;
    return c0 + shadowsBleed;
}