/* bStipple, comic-book style effect
use pre-resize
can also handle low-res input

Mod and .hook/hlsl port by butterw 
based on BlueNoiseStippling2 https://www.shadertoy.com/view/ldyXDd by FabriceNeyret2 
- perf: (5 texture, 45 arithmetic), without stipple: (5 texture, 13 arithmetic) !!!
*/

#define stepnoise0(pos, size) rnd( floor(pos/size)*size ) //float2 pos
#define rnd(U) frac(sin(mul(U, 1e3*float2x2(1, -7.131, 12.9898, 1.233))) *43758.5453)

// --- Stippling mask to cover up artifacts based on blue noise
float stipple_mask(float2 pos) {
	#define SEED1 1.705
	#define DMUL  8.12235325
    pos+= stepnoise0(pos, 5.5)*DMUL -0.5*DMUL;
    float f = frac(pos.x*SEED1 +pos.y/(SEED1+0.15555));
    f*= 1.002; 
    return  (pow(f, 150.) +1.3*f) *0.7/2.3; 
}

sampler s0: register(s0);
float2  p0: register(c0); //W, H
float2  p1: register(c1); //px, py

#define S 0.7 //default: 0.7, 0: bw output
#define CoefLuma float4(.3, .6, .1, 0)
#define get(uv) tex2D(s0, tex + p1*uv)

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex);  

	float4 blur; //smooth kernel: (+)4(1)
	blur = get(float2(0, -1));
	blur+= get(float2(-1, 0));
	blur+= get(float2(1,  0));
	blur+= get(float2(0,  1));
	float f = dot(26*c0-50*0.125*blur, CoefLuma); 
 	// return f; //Luma unsharp mask x50 (massively overshapened)

    /*-- Stippling --*/	
	float mask = stipple_mask(floor(p0 *tex));//0.25;
	f = step(mask, f);
	return lerp(f, c0, S);	
}
