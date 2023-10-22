// $MinimumShaderProfile: ps_2_0

#define Amount 0.8
#define Laplacian 0
#define Show_Edge 0

/* --- sharpen (dx9) --- */
/* v1.10 (2023-10) released by butterw under GPLv3

Classic sharpener with adjustable amount of sharpening and Laplacian kernel choice.

Parameters:
- Amount: sharpening amount, default: 0.8 (0.8 means 80% sharpening), [0.0, ..], 0: no effect
- Laplacian: kernel choice, default: 0, [0, 1, 2, 15], 1: fastest.
- Show_Edge: default: 0 (sharpened image), [0, 1], 1: shows only the high-frequency detail.

sharpened image(sharpening amount) = original image + high-frequency detail
high-frequency detail is obtained by applying the chosen Laplacian kernel (scaled to Amount) to the original image.

Laplacian kernels, https://legacy.imagemagick.org/Usage/convolve/#sharpening
- Laplacian: 0, 3x3 kernel (9 texture, 15 arithmetic)
[ -1, -1, -1 ]
[ -1,  8, -1 ]
[ -1, -1, -1 ]

- Laplacian: 1, (3x3, +) kernel (5 texture, 8 arithmetic)
[  0, -1,  0 ]
[ -1,  4, -1 ]
[  0, -1,  0 ]

- Laplacian: 2, 3x3 kernel (9 texture, 15 arithmetic)
[ -2,  1, -2 ]
[  1,  4,  1 ]
[ -2,  1, -2 ]

- Laplacian: 15, (13 texture, 22 arithmetic)
Laplacian of Gaussians (LoG) 5x5 kernel (sigma: approx 1.4)
[  0,  0, -1,  0,  0 ]
[  0, -1, -2, -1,  0 ]
[ -1, -2, 16, -2, -1 ]
[  0, -1, -2, -1,  0 ]
[  0,  0, -1,  0,  0 ]

Kernel weights are calculated based on kernel choice and shader parameters.
*/

#if Show_Edge == 1
    #define v0 Amount
#else
    #define v0 (Amount+1.0)
#endif

#if Laplacian == 0
    #define v1 -0.125*Amount
    #define v2 -0.125*Amount
#elif Laplacian == 1
    #define v1 -0.25*Amount
    #define v2  0
#elif Laplacian == 2
    #define v1 0.25*Amount
    #define v2 -0.5*Amount
#elif Laplacian == 15
    #define v1 -0.125*Amount
    #define v2 -0.0625*Amount
#endif

/* ------ */
sampler s0: register(s0);
float2  p1: register(c1);

#define pixel_radius 1
#define dx pixel_radius*p1.x
#define dy pixel_radius*p1.y
#define CoefLuma float4(0.212656, 0.715158, 0.072186, 0) // BT.709 & sRBG luma coef (Monitors, HDTV)


float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex) *v0;
    /* Apply calculated kernel weights:
    [ v2,  v1, v2 ]
    [ v1,  v0, v1 ]
    [ v2,  v1, v2 ] */

    c0+= tex2D(s0, tex +float2(-dx,   0)) *v1;
    c0+= tex2D(s0, tex +float2( dx,   0)) *v1;
    c0+= tex2D(s0, tex +float2(  0, -dy)) *v1;
    c0+= tex2D(s0, tex +float2(  0,  dy)) *v1;

    c0+= tex2D(s0, tex +float2(-dx,  dy)) *v2;
    c0+= tex2D(s0, tex +float2( dx, -dy)) *v2;
    c0+= tex2D(s0, tex -float2(dx, dy))   *v2;
    c0+= tex2D(s0, tex +float2(dx, dy))   *v2;

#if Laplacian == 15
    c0+= tex2D(s0, tex -float2(2*dx,   0)) *v2;
    c0+= tex2D(s0, tex +float2(2*dx,   0)) *v2;
    c0+= tex2D(s0, tex -float2(  0, 2*dy)) *v2;
    c0+= tex2D(s0, tex +float2(  0, 2*dy)) *v2;
#endif

#if Show_Edge == 1
    return min(0.7, 7*dot(c0, CoefLuma));
    //return 2*length(c0);
#endif

    return c0;
}
