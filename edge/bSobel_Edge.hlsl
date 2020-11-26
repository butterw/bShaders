#define T_Sobel 0.15 //Threshold: higher means less detection
#define Mode 1 //[0, 1, 2] Default 1: Inverted Sobel, 0: Sobel, 2: Cartoon
#define WhiteLimit 180/255. // <1. clamp output to avoid bright white 
#define SatFactor 1.8 //2.43 //0: gray, 1: no change, >1: Saturated Colors

/* --- bSobel_Edge by butterw v1.3 
Sobel Edge Detection in Luma (3x3 kernel) with adjustable Threshold
tested in mpc-hc (8 texture, 25 arithmetic)

Typically provides the best quality used post-upscale.   

Changelog v1.3:
- added Inverted Mode (Dark lines on White_limit background)
- added Cartoon Mode  (Dark Edges + Saturated Color)
--- */

sampler s0: register(s0);
float2  p1: register(c1);
#define px p1.x
#define py p1.y
#define CoefLuma float4(0.212656, 0.715158, 0.072186, 0) // BT.709 & sRBG luma coef (HDTV, SDR Monitors)

float4 Sobel_Edge(float2 tex){
	float4 c8 = tex2D(s0, tex +p1);
	       c8-= tex2D(s0, tex -p1);
	float4 c3 = tex2D(s0, tex +float2( px, -py));
		   c3-= tex2D(s0, tex +float2(-px,  py));	
	float4 c4 = tex2D(s0, tex +float2(-px,   0));
	float4 c5 = tex2D(s0, tex +float2( px,   0));	
	float2 g;
	g.x = dot(c8 + c3 -2*c4 + 2*c5, CoefLuma);
	float4 c7 = tex2D(s0, tex +float2(0,  py));		
	float4 c2 = tex2D(s0, tex +float2(0, -py));
	g.y = dot(c8 -c3 + 2*c7  -2*c2, CoefLuma); //c1
	float edge = length(g); 
	
	#if Mode == 0	//Sobel
		return (edge>T_Sobel) ? min(edge, WhiteLimit): 0;    
	#elif Mode == 1 //Inverted_Sobel: dark grey on white background 
		return (edge<T_Sobel) ? WhiteLimit: 1-1.4*max(edge, 0.25); // Inverted: 	
	#else //Cartoon Mode: Dark Edges + Saturated Color 
		float4 color = tex2D(s0, tex);
		float gray = dot(color, CoefLuma);//1/3. 
		color = (edge<T_Sobel) ? color: color*saturate(1-1.1*edge);
		return lerp(gray, color, SatFactor);		
	#endif
}

float4 main(float2 tex: TEXCOORD0): COLOR {
	// float4 c0 = tex2D(s0, tex);
	return Sobel_Edge(tex);
}
