/* Dual-Kawase blur - First and Second Passes of 4 (pre-resize shader)

tested-hc on mpc-hc v1.9.6, by butterw (5 texture, 9 arithmetic)
use: 
1=Blur Dual-Kawase
PreResize1=.\blurDKawase14.hlsl;blurDKawase14.hlsl;blurDKawase34.hlsl;blurDKawase34.hlsl 

*/

sampler s0: register(s0);
float2  p1: register(c1);
#define offset 3.
/* --- Main --- */
float4 main(float2 tex: TEXCOORD0): COLOR { // downsample pass-1 & pass-2
	float2 uv = 2*tex; //downsize by 2

    float4 sum = 4.*tex2D(s0, uv);
    sum += tex2D(s0, uv - p1 *offset);
    sum += tex2D(s0, uv + p1 *offset);
    sum += tex2D(s0, uv + float2(p1.x, -p1.y) *offset);
    sum += tex2D(s0, uv - float2(p1.x, -p1.y) *offset);

	return 0.125*sum;
}