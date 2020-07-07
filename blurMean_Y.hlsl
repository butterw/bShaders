#define k 5 // k>1 should be the same as during 1st Pass
/* Boxblur: 2nd Pass 
with Linear Sampling (separable Mean Filter) by butterw
*/

sampler s0: register(s0);
float2  p1: register(c1);
	
float4 boxblur_X(float2 tex){	
	float4 c0;
	for (int i=0; i<k; i++) {
		float offset = 2*i+0.5;
        c0+= tex2D(s0, tex + p1.x*float2(offset, 0));
		c0+= tex2D(s0, tex + p1.x*float2(-offset, 0));
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
	return boxblur_Y(tex);
}