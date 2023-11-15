// $MinimumShaderProfile: ps_2_0
#define Exposure -0.35

/* --- bDim (dx9), bExposure --- */
/* v1.40 (11/2023) released by butterw under GPLv3
(1 texture, 1 arithmetic)

Exposure: Dims or lights-up the video.

c0 = c0 *(1.0+Exposure) = c0 + c0*Exposure 
  with c0: pixel.rgb in [0, 1.0].

- Parameter Exposure, typ: [-0.8 to 1], 0: no effect.
[-1, ..] -1: All black.
negative: dims, ex: -0.35
with strong values (ex: -0.8) can be used for a night-for-day effect (make a day-shot look like a night shot).
positive: lights-up.
ex: 1.0 will blow-up White for a kind of vintage effect.
*/
sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex);

    c0.rgb = c0 *(1.0 + Exposure);
    return c0;
}
