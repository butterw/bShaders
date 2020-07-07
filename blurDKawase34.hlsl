/* Dual-Kawase blur - Passes 3 and 4 (resize-up blur)
tested-hc on mpc-hc v1.9.6, by butterw (8 texture, 18 arithmetic)

dual filtering kawase method described in GDC2015 by Marius Bjorge, also used by KDE

Dn: (5 texture, 9 arithmetic)*2
Up: (8 texture, 18 arithmetic)*2

*/

sampler s0: register(s0);
float2  p1: register(c1);
#define offset 3.

/* --- Main --- */
float4 main(float2 tex: TEXCOORD0): COLOR { // upsample pass-1 & pass-2
	float2 uv = 0.5*tex; //resize-up x2
	float2 halfpixel = 0.25*p1;

	float4 sum = tex2D(s0, uv + float2(-halfpixel.x *2, 0)   *offset);
    sum += tex2D(s0, uv + float2(-halfpixel.x, halfpixel.y)  *offset) *2.;
    sum += tex2D(s0, uv + float2(0, halfpixel.y *2)          *offset);
    sum += tex2D(s0, uv + halfpixel   *offset) *2.;
    sum += tex2D(s0, uv + float2(halfpixel.x *2, 0)          *offset);
    sum += tex2D(s0, uv + float2(halfpixel.x, -halfpixel.y)  *offset) *2.;
    sum += tex2D(s0, uv + float2(0, -halfpixel.y *2)         *offset);
	sum += tex2D(s0, uv + float2(-halfpixel.x, -halfpixel.y) *offset) *2.;
	
	return sum/12.;
}
