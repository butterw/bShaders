#define Mode 10 
/* Mode [0, 1, 10] default:0 full (9 texture, 15 arithmetic), 
// 1: hw, uses hw linear sampling (4 texture, 7 arithmetic) faster but may not be supported
//10: tests whether hw linear sampling is supported. Orange screen: not supported.

Gaussian Smoothing Filter
bSmooth_test.hlsl v0.1
by butterw, License: GPL v3
for maximum effect use pre-upscaling.

// Gaussian filter 3x3, sigma=0.85, in multi-pass sigma=sigma*sqrt(2)
// [ 1, 2, 1 ]
// [ 2, 4, 2 ]
// [ 1, 2, 1 ]
*/

sampler s0: register(s0);
float2  p1: register(c1); 
#define px p1.x // pixel width
#define py p1.y

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 orig = tex2D(s0, tex); // get original pixel
	float4 blur;

#if Mode==0
	//Gaussian filter 3x3 gSmooth3(9 texture, 15 arithmetic)
	blur =   tex2D(s0, tex - p1);
	blur+=   tex2D(s0, tex + float2( px, -py));
	blur+= 2*tex2D(s0, tex + float2(  0, -py));
	blur+= 2*tex2D(s0, tex + float2(-px,   0));
	blur+= 4*orig;
	blur+= 2*tex2D(s0, tex + float2( px,   0));
	blur+= 2*tex2D(s0, tex + float2(  0,  py));
	blur+= 	 tex2D(s0, tex + float2(-px,  py));
	blur+=   tex2D(s0, tex + p1);
	blur*= 0.0625; //div by 16
	
#elif Mode==1 //hw.gSmooth3(4 texture, 7 arithmetic)
	#define po 0.5 //default: 0.5, 0.499: doesn't blur if hw linear sampling isn't supported. 
    blur = tex2D(s0, tex + p1*float2(-po, -po));
    blur+= tex2D(s0, tex + p1*float2( po, -po));
    blur+= tex2D(s0, tex + p1*float2(-po, po));
    blur+= tex2D(s0, tex + p1*float2( po, po));
    blur*= 0.25;
	
#elif Mode==10 //hw linear sampling test: Orange screen means not supported
	#define po 0.499 
	#define Orange float4(1, 0.5, 0, 1)
    blur = tex2D(s0, tex + p1*float2(-po, -po));
    blur+= tex2D(s0, tex + p1*float2( po, -po));
    blur+= tex2D(s0, tex + p1*float2(-po, po));
    blur+= tex2D(s0, tex + p1*float2( po, po));
    blur*= 0.25;
	if (all(abs(orig-blur)<0.001)) return Orange;
	
#elif Mode==2 // smooth(3+ [1 4 1]) kernel (5texture, 8 arithmetic)  
	blur = tex2D(s0, tex + float2(  0, -py));
	blur+= tex2D(s0, tex + float2(-px,   0));
	blur+= 4*orig;
	blur+= tex2D(s0, tex + float2( px,   0));
	blur+= tex2D(s0, tex + float2(  0,  py));
	blur*= 0.125;
#endif
    // return 5*abs(orig-blur); //debug-output
	return blur; 
}