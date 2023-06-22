// $MinimumShaderProfile: ps_2_0
#define a 10
#define b 245

/* --- bContrast, aka 16-235mod to 0-255 (dx9) --- */
/* v1.0 (06/2023) released by butterw under GPLv3
(1 texture, 1 arithmetic)

modified version of the MPC-HC shader "16-235 to 0-255.hlsl". 
allows custom values instead of just (16, 235) for (a, b)

pixel.rgb = (pixel.rgb -const_1) *const_2 = pixel.rgb*const_2 -const_1*const_2
Default parameters (a: 10, b: 245)
Expands the rgb histogram, increasing the contrast. 
Can be useful to lift the haze on lackluster internet videos.  

*/
sampler s0: register(s0);
#define const_1 ( a/255.)
#define const_2 (255.0/(b-a))

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex);

	return (c0 -const_1) *const_2;
}
