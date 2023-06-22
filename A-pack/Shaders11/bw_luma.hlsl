// $MinimumShaderProfile: ps_4_0

/* --- bw_luma (dx11) --- */
/* v1.0 (06/2023) released by butterw under GPLv3

Displays the grayscale luminance (luma) image derived from rgb.
Same shader as the Grayscale shader included with mpc-be (different from the one in mpc-hc).

*/
Texture2D tex : register(t0);
SamplerState samp : register(s0);
#define CoefLuma float4(0.2126, 0.7152, 0.0722, 0) //sRGB, HDTV

float4 main(float4 pos : SV_POSITION, float2 coord : TEXCOORD) : SV_Target {
    float4 c0 = tex.Sample(samp, coord);

    return dot(c0, CoefLuma);
}
