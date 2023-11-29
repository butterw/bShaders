// $MinimumShaderProfile: ps_2_0
#define Strength 16.
#define Curve01  0.25
#define Show_Grain 0

/* --- grain (dx9) --- */ 
/* v1.0 (2023-11) released by butterw under GPLv3
Gaussian noise generation is from "semi-random grayscale noise.hlsl", (C) 2011 Jan-Willem Krans (janwillem32 <at> hotmail.com), license: GPLv2.
(1 texture, 42 arithmetic) >> (1 texture, 38 arithmetic with Curve01:1).

Filmgrain is a physical characteric of film media, digital camera sensors don't have grain, only noise. A small amount of grain paradoxically increases perceived sharpness and quality (ex: sources that have been denoised prior to encoding). But adding too much just degrades the signal-over-noise ratio. It is recommended to adjust the Strength down so the grain is barely visible.
Grain shaders typically generate a dynamic luma noise pattern and blend it with the original image. Grain is calculated for each xy pixel of the image using a pseudo-random hash function with time and counter variables used as seed, leading to a dynamic grain pattern updated every frame. Additive grain blending does not significantly alter the original brightness and contrast of the image.
This shader allows to apply less grain to dark and bright areas vs midtones by multiplying grain with a shaping function based on luma. The shaping function is a tunable parabola centered at midgray. The values in x:0 and x:1.0 are set by parameter Curve01.

out = c0.rgb + noiseStrength*grain
	with c0 and out pixel.rgb values in [0, 1.0].
	and noiseStrength = 0.01*Strength.

grain = gShape(luma, Curve01) *grain
	with grain, positive or negative grayscale value in [-0.125, 0.125], random variable with gaussian distribution.
	and gShape in [0, 1.0].

## Parameters ##
- Strength, percentage, ex: 16. [0 to 35.0], 0: no effect.
- Curve01, curve shaping parameter, ex:0.25, typ [0 to 1.0], 1.0: uniform grain , 0: parabola(luma).
gshape(luma:0) = gshape(luma:1.0) = Curve 
- Show_Grain, 0: default, [0 or 1] 1: display only the noise pattern. 

Grain should only be added after any sharpening operations are performed (sharpening generated grain is undesirable).
When upscaling with no post-resize sharpening, grain can be added pre-resize with some advantages:
- less pixels to process: faster.
- any resizing (ex bicubic A=-0.60, scaling ratio=1.33x) smooths the shape of the distribution and results in a clean gaussian.
- the grain size is scaled. This may achieve a more pleasing result for scaling ratios up to 2x, as single pixels are fairly small at 1080p or higher.
*/

#define noiseStrength Strength*0.01 //apply Strength scaling factor.
#define n 4 //number of randomization iterations, ex:4, ! a lower RunCount will cause patterned noise.
#define PI acos(-1) //3.14159265
const static float4 RandomFactors = { pow(PI, 4), exp(5), pow(13, 0.5*PI), sqrt(1997) }; // Randomization factors
#define rnd(u) r_in.u = frac( dot(r_in, RandomFactors) );
sampler s0: register(s0);
float4  p0: register(c0);
#define CoefLuma float3(0.2126, 0.7152, 0.0722) //sRGB, HDTV
#define gshape(x) lerp(1 - pow((2*x -1), 2), 1, Curve01) // C + (1-C)*(1 -(2*x-1)^2) = 1 + (C-1)*(2*x-1)^2  //for negative C, use: max(gshape(luma), 0)  

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 r_in = float4( tex.xy, p0.zw *1.0/65536 +exp(5) ); // xy input coordinates and time factors (clock and counter)
	for(int i=0; i< n; i++) { rnd(x) rnd(y) rnd(z) rnd(w) };  // randomize
	float grain;	
	#if Show_Grain == 1
		grain = 0.25 -dot(r_in, 0.125); //in [-0.125, 0.125]
		return 0.5 + grain;
	#endif
	grain = 0.25*noiseStrength -dot(r_in, 0.125*noiseStrength); // noiseStrength*grain
	float4 c0 = tex2D(s0, tex);
	float luma = dot(c0.rgb, CoefLuma);
	grain = gshape(luma)*grain; 
	return c0 + grain;
}