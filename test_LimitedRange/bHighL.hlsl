#define Red     float4(1, 0, 0, 0)
#define Yellow  float4(1, 1, 0, 0)
#define Green   float4(0, 1, 0, 0)
#define Blue    float4(0, 0, 1, 0)

/*--- User Configuration ---*/
#define HighColor Yellow //Red
#define LowColor  Green

#define HighLimit 235/255.
#define LowLimit   14/255. 


/*--- bHighL.hlsl by butterw v0.1
Highlights pixels outside of defined Luma Range (in solid colors)
Limited Range Luma: 16-235 (vs Full Range Luma: 0-255)


(1 texture, 5 arithmetic)
*/ 
#define CoefLuma float4(0.212656, 0.715158, 0.072186, 0) // BT.709 & sRBG luma coef (HDTV, SDR Monitors)
sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex);
	float4 luma = dot(c0, CoefLuma);
	
	return (luma>HighLimit) ? HighColor:
			(luma<LowLimit) ? LowColor: c0;
}
