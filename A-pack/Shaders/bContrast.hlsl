// $MinimumShaderProfile: ps_2_0
#define bk 10
#define wh 245

/* --- bContrast, aka 16-235mod to 0-255 (dx9) --- */
/* v1.01 (06/2023) released by butterw under GPLv3
(1 texture, 1 arithmetic)

modified version of the MPC-HC shader "16-235 to 0-255.hlsl".
allows custom values instead of just (16, 235) for the rgb black and white points.

Default parameters (bk: 10, wh: 245) for the rgb black and white points.
pixel.rgb = (pixel.rgb -const_1) *const_2 = pixel.rgb*const_2 -const_1*const_2
Expands the rgb histogram, increasing the contrast.
Can be useful to lift the haze on lackluster internet videos.

*/
sampler s0: register(s0);
#define const_1 ( bk/255.)
#define const_2 (255.0/(wh-bk))

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex);

    return (c0 -const_1) *const_2;
}
