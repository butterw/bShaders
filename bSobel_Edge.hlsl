#define T_Sobel 0.2 //Threshold: higher means less edges on screen
#define White_limit 180/255. // <1. to avoid bright white 

/* --- bSobel by butterw v1.0 
Sobel Edge Detection in Luma (3x3 kernel) 
	with Threshold and White_limit: gray output on black background
	(8 texture, 25 arithmetic) you can save 1 extra instruction by applying CoefLuma on edge rather than on float4 delta

use: post-resize for best results
pass1 in a Canny Edge Filter: you could precede it by a pre-resize smoothing filter (ex: gaussian blur 5x5).
--- */
sampler s0: register(s0);
float2 p1:  register(c1);
#define px p1.x
#define py p1.y
#define CoefLuma float4(0.212656, 0.715158, 0.072186, 0) // BT.709 & sRBG luma coef (Monitors, HDTV)
// #define T_Sobel_sq (T_Sobel*T_Sobel)
// #define Red   float4(1, 0, 0, 0)
#define Black16  float4(16, 16, 16, 0)/255.


float4 Sobel_Edge(float2 tex){
	float4 c1 = tex2D(s0, tex - p1);
	float4 c2 = tex2D(s0, tex + float2(  0, -py));
	float4 c3 = tex2D(s0, tex + float2( px, -py));
	float4 c4 = tex2D(s0, tex + float2(-px,   0));
	float4 c5 = tex2D(s0, tex + float2( px,   0));
	float4 c6 = tex2D(s0, tex + float2(-px,  py));
	float4 c7 = tex2D(s0, tex + float2(  0,  py));
	float4 c8 = tex2D(s0, tex + p1);

	float delta1 = dot(c8 -c1 -2*c4 -c6 + c3 + 2*c5, CoefLuma);
	c1 += c3;
	c6 += c8;
	float delta2 = dot(c6 + 2*c7 -c1 -2*c2, CoefLuma);
	float edge = sqrt(delta1*delta1 + delta2*delta2); //
	return (edge>T_Sobel) ? min(edge, White_limit): 0; //Black16; 	
}


float4 main(float2 tex: TEXCOORD0): COLOR {
	// float4 c0 = tex2D(s0, tex);
	return Sobel_Edge(tex);
}
