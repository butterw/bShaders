// $MinimumShaderProfile: ps_2_0
#define Lift 0.05

/* --- bLift (dx9) --- */
/* v1.01 (2023-06) released by butterw under GPLv3 

c0 = c0*(1 -0.5*Lift) +0.5*Lift = c0 +0.5*Lift*(1-c0) 
	with c0: pixel.rgb in [0, 1.0]

- Parameter rgb Lift, 0: no change 
negative: darkens the image 
positive: lightens the image, ex: 0.05
  
Lift limits image crushing
vs. a brightness adjustment (rgb shift): c0 = c0 + Brightness
*/
sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR { 
    float4 c0 = tex2D(s0, tex);
	
    return c0*(1 -0.5*Lift) +0.5*Lift;
}
