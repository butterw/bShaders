// $MinimumShaderProfile: ps_4_0
#define Exposure 0.08

/* --- bExposure (dx11) --- */
/* v1.40 (07/2023) released by butterw under GPLv3
/* (1 texture, 1 arithmetic)

Exposure increases (or decreases) contrast/brightness.

out = x * (1 + Exposure) = x + x*Exposure
    with x, out: pixel.rgb in [0, 1.0]

Exposure doesn't affect the Black point (0, 0).
- Contrast: 1+Exposure.
- Brightness change: Exposure*x. Maximum at the White point.

- parameter Exposure, [-1.0, ..], 0: no change, -1: All black
>> Positive: increases contrast/brightness, ex: 0.08
    ! input> 1/(1+Exposure) will be clipped.

negative: decreases contrast/brightness (dims), output<= 1+Exposure.

*/
Texture2D tex: register(t0);
SamplerState samp: register(s0);

float4 main(float4 pos: SV_POSITION, float2 coord: TEXCOORD): SV_Target {
    float4 c0 = tex.Sample(samp, coord);

    c0.rgb = c0.rgb *(1.0 + Exposure);
    return c0;
}
