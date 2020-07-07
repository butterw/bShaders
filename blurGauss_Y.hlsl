/* blurGauss_Y (Vertical Pass)

Separable Gaussian Kernel with linear sampling (9-tap filter approx.) Sigma?
http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/

Second pass of 2-pass filter (pre-resize shader)
per pass: (5 texture, 8 arithmetic)
use: blurGauss_X (horiz. pass) >> blurGauss_Y (vert. pass)
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
        c0+= tex2D(s0, tex + p1.y*float2(0, Offsets[i])) *K[i];
        c0+= tex2D(s0, tex - p1.y*float2(0, Offsets[i])) *K[i];
	}

	return c0;
}
