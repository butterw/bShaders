// $MinimumShaderProfile: ps_2_0
#define SharpenAmount 0.8
#define Threshold 0.6
#define Show_Edge 10

/* --- unsharp (dx9) --- */

/* v1.20 (2023-10) released by butterw under GPLv3
(9 texture, 16 arithmetic, threshold: +4 ari)

Sharpens using the classic unsharp mask method (available in photo editing application such as photoshop, photodemon, etc.).
Sharpening shaders are typically used post-resize.

Sharpening means increasing the contrast of details.
In the unsharp mask method a low-pass filtered (blurred) image is substracted from the original image to obtain the high-frequency detail image.
This shader uses a 3x3 gaussian filter to calculate the blurred image.
  detail = original - blurred
  sharpened = original + SharpenAmount*detail

Detail can have positive or negative values. This corresponds to the positive and negative overshoot on edges and causes the brightness of sharpened details to be increased or decreased.

Over-sharpening should be avoided as it will cause a halo on high constrast edges. Sharpening requires a reasonably clean source video (in particular if the source is upscaled on a large display) as it will reenforce existing artifacts such as aliasing, etc. A detail threshold value can be applied to only sharpen strong edges or to prevent sharpening of noise/artifacts.
The Show_Edge parameter allows the display of the threshold mask and edges for analysis.

Parameters
- SharpenAmount, default: 0.8 (0.8 means 80% sharpening) [0, ..], 0: no effect.
- Threshold (in 8bit pixel levels): detail (absolute luma value) below the threshold is not sharpened. default: 0, [0.0, ..], typ: 0.0 to 10., 0: no effect.
- Show_Edge,  default: -1 (disabled): show sharpened image, [0, 1, 10, 2]
0: show low detail area (sub-threshold) as a red mask.
1: show edges (high-frequency detail above threshold), as luma on grey background.
10: 1+0.
*/
#define Red float4(0.7, 0, 0, 1)//0.25

sampler s0: register(s0);
float2 p1:  register(c1);
#define dx  p1.x
#define dy  p1.y
#define CoefLuma float4(0.212656, 0.715158, 0.072186, 0) // BT.709 & sRBG luma coefficient
#define scaled_Threshold Threshold/255.0

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 original = tex2D(s0, tex);

    /* Computation of the blurred image (gaussian filter)
    Get neighboring pixels:
      [ 1, 2, 3 ]
      [ 4, o, 5 ]
      [ 6, 7, 8 ] */
    float4 c1 = tex2D(s0, tex + float2(-dx, -dy));
    float4 c2 = tex2D(s0, tex + float2(  0, -dy));
    float4 c3 = tex2D(s0, tex + float2( dx, -dy));
    float4 c4 = tex2D(s0, tex + float2(-dx,   0));
    float4 c5 = tex2D(s0, tex + float2( dx,   0));
    float4 c6 = tex2D(s0, tex + float2(-dx,  dy));
    float4 c7 = tex2D(s0, tex + float2(  0,  dy));
    float4 c8 = tex2D(s0, tex + float2( dx,  dy));

    /* Gaussian kernel 3x3 weights:
      [ 1, 2, 1 ]
      [ 2, 4, 2 ]
      [ 1, 2, 1 ], normalization: *1/16 = 0.0625 */
    float4 blurred = (c1 + c3 + c6 + c8 + 2*(c2 + c4 + c5 + c7) + 4*original) *0.0625;
    float4 detail = original - blurred; //detail is positive or negative rgba.

    // Apply Threshold to detail
    if ( abs(dot(detail, CoefLuma))<scaled_Threshold ) {
        detail = float4(0, 0, 0, 1);
        #if (Show_Edge ==0 || Show_Edge ==10)
            return Red;
        #endif
    }

    #if (Show_Edge ==1 || Show_Edge ==10)
        return min(0.65, dot(detail, 12*CoefLuma)+0.15);
    #endif

    return original + SharpenAmount*detail;
}