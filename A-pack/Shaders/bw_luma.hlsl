// $MinimumShaderProfile: ps_2_0

/* --- bw_luma (dx9) --- */
/* v1.40 (07/2023) released by butterw under GPLv3

Displays the grayscale luminance (HDTV luma) image derived from rgb.
Same as the Grayscale shader included with mpc-be (different from the one in mpc-hc).

*/
sampler s0: register(s0);
#define CoefLuma float4(0.2126, 0.7152, 0.0722, 0) //sRGB, HDTV

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex);

	return dot(c0, CoefLuma);
}