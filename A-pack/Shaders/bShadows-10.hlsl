// $MinimumShaderProfile: ps_2_0
#define Shadows -0.10

/* --- bShadows (dx9) --- */
/* v1.0 (2023-06) released by butterw under GPLv3 


pixel.rgb = pixel.rgb + Shadows*(1-luma)**4

- Shadows Parameter (default value: -0.10)
negative: darkens the shadows, 0: no change, positive: lighten the shadows   

*/

#define LumaCoef float4(0.2126, 0.7152, 0.0722, 0) 
sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR { 
    float4 c0 = tex2D(s0, tex);
	float shadowsBleed = 1.0 -dot(c0, LumaCoef);
    shadowsBleed *=shadowsBleed; 
	shadowsBleed *=shadowsBleed;
	
    return c0 + Shadows *shadowsBleed;
}