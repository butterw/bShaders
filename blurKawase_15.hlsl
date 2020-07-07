/* Kawase blur - First of Five Passes (pre-resize shader)
tested-hc on mpc-hc v1.9.6, by butterw (4 texture, 7 arithmetic)

5-pass Kawase blur with kernel offsets {0.5, 1.5, 2.5, 2.5, 3.5} matches output of a 35x35 Gaussian kernel ?
https://software.intel.com/content/www/us/en/develop/blogs/an-investigation-of-fast-real-time-gpu-based-image-blur-algorithms.html
*/

#define i 0.5 //kernel offsets for 5-pass Kawase blur {0.5, 1.5, 2.5, 2.5, 3.5}


sampler s0: register(s0);
float2  p1: register(c1);

/* --- Main --- */
float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 col; 
    
    col = tex2D(s0, tex + p1*float2(i, i));
	col+= tex2D(s0, tex + p1*float2(i, -i));
	col+= tex2D(s0, tex + p1*float2(-i, i));
	col+= tex2D(s0, tex + p1*float2(-i, -i));

	return col/4.;
}