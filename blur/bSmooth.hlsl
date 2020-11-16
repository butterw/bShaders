#define Mode 1 
/* Mode [0, 1] default:0 full (9 texture, 15 arithmetic), 
// 1: uses hw linear sampling (4 texture, 7 arithmetic)

Gaussian Smoothing Filter
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


#if Mode==1 //hw.gSmooth3(4 texture, 7 arithmetic)
    #define po 0.499 //default: 0.5, 0.499: no blur if hw linear sampling isn't supported. 
    blur = tex2D(s0, tex + p1*float2(-po, -po));
    blur+= tex2D(s0, tex + p1*float2( po, -po));
    blur+= tex2D(s0, tex + p1*float2(-po, po));
    blur+= tex2D(s0, tex + p1*float2( po, po));
    blur*= 0.25;
    return 10*abs(orig-blur); //debug output with po 0.499, if hw linear sampling isn't supported: 100% black screen 
    return blur;
#endif

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
	return blur; 
}
