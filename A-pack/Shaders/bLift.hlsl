// $MinimumShaderProfile: ps_2_0
#define Lift 0.05

/* --- bLift (dx9) --- */
/* v1.0 (2023-06) released by butterw under GPLv3 

pixel.rgb = pixel.rgb*(1 -0.5*Lift) +0.5*Lift
- rgb Lift Parameter (default value: 0.05)
negative: darkens the image, 0: no change, positive: lightens the image
  
Lift limits image burn-out vs a brightness adjustment (rgb shift): 
pixel.rgb = pixel.rgb + Brightness
*/
sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR { 
    float4 c0 = tex2D(s0, tex);
	
    return c0*(1 -0.5*Lift) +0.5*Lift;
}