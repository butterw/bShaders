#define k 5 // integer>1. textures: 2*k, kernel size: 2*(2*k-2)

/* Boxblur: 1st Pass (Pre-Resize shader)
separable Mean Filter + gpu Linear Sampling  
per pass: (2*k texture, 17 arithmetic)

With boxBlur, all Kernel coefs are 1.



3 successive passes of Box Blur approximate a Gaussian blur  (! k parameter you stay the same between X and Y pass).  
use:
1=BoxBlur(x3)
PreResize1=.\blurGauss.hlsl;.\blurGauss_Y.hlsl; blurMean.hlsl; blurMean_Y.hlsl; blurMean.hlsl; blurMean_Y.hlsl
*/

sampler s0: register(s0);
float2  p1: register(c1);

float4 boxblur_X(float2 tex){	
	float4 c0;
	for (int i=0; i<k; i++) {
		float offset = 2*i+0.5;
        c0+= tex2D(s0, tex + p1.x*float2(offset, 0));
		c0+= tex2D(s0, tex + p1.x*float2(-offset, 0));
		// if (i == 5) return 0;
	}
	return c0/(2.*k);
}	

float4 boxblur_Y(float2 tex){	
	float4 c0;
	for (int i=0; i<k; i++) {			
		float offset = 2*i+0.5;
        c0+= tex2D(s0, tex + p1.y*float2(0, offset));
		c0+= tex2D(s0, tex + p1.y*float2(0, -offset));
	}
	return c0/(2.*k);
}	
	
	
	
/* --- Main --- */
float4 main(float2 tex: TEXCOORD0): COLOR {
	return boxblur_X(tex);
}