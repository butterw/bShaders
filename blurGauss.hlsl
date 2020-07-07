/* blurGauss: Gaussian blur X (horiz. pass) 
tested in mpc-hc v1.9.6, by butterw  

Separable Gaussian Kernel with linear sampling (9-tap filter approx.) 
http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/

First pass of 2-pass shader (pre-resize shader)
	per pass: (5 texture, 8 arithmetic)
use: blurGauss (horiz. pass) >> blurGauss_Y (vert. pass)
you can run the the 2-pass shader multiple times to achieve a stronger blur (ex: 5 times)
*/

sampler s0: register(s0);
float2  p1: register(c1);
#define Offsets float3(0.0, 1.3846153846, 3.2307692308)
#define K		float3(0.2270270270f, 0.3162162162f, 0.0702702703f)

/* --- Main --- */
float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex) *K[0];
	for (int i=1; i<3; i++) {			
        c0+= tex2D(s0, tex + p1.x*float2(Offsets[i],0)) *K[i];
        c0+= tex2D(s0, tex - p1.x*float2(Offsets[i],0)) *K[i];
	}

	return c0;
}
