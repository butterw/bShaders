// $MinimumShaderProfile: ps_4_0
#define Screen 0.24

/* --- tooDark (dx11) --- */
/* v1.40 (2023-07) released by butterw under GPLv3
 (1 texture, 3 arithmetic)

Apply when the picture is too dark.
Increases brightness without clipping (Black point and White point are not changed).

Photoshop Screen Blend, brightness/contrast curve:
out = -Screen*x*x + (1+Screen)*x = -Screen*x^2 +Screen*x + x
    with x, out: pixel.rgb in [0, 1.0]
    and Screen >=0

parameter Screen [-1, 1.0], 0: no effect.
>> Positive: (Screen Blend) increases brightness, increases constrast in shadows, ex: 0.24
    - Brightness increase is maximum at the mid-point (Screen/4).
    - Contrast = 1+Screen -2*Screen*x
    Contrast is maximum at the Black point (1+Screen) and decreases linearly with input level.
    Contrast:1 at the mid-point.

negative: (Multiply Blend) decreases brightness, increases contrast in highlights.

*/
Texture2D tex: register(t0);
SamplerState samp: register(s0);
#define Multiply -Screen //to ensure a positive user parameter.

float4 main(float4 pos: SV_POSITION, float2 coord: TEXCOORD): SV_Target {
    float4 c0 = tex.Sample(samp, coord);

    c0.rgb = lerp(c0, c0*c0, Multiply).rgb;
    return c0;
}