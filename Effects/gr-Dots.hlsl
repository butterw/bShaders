#define Scale 0.4 //[0.3, 0.6] default: 0.4. Higher for smaller dots

/*
gr-Dots.hlsl (mpc-hc dx9 pixel shader)
ported by butterw from https://github.com/pixijs/pixi-filters/blob/master/filters/dot/src/dot.frag (MIT License)

Output is grayscale, mostly black and white
Can be used Post-resize, can use 2instances.
v0.1: (1 texture, 18 arithmetic)
*/
sampler s0: register(s0);
float2  p0: register(c0); //W, H
#define CoefLuma float4(0.2126, 0.7152, 0.0722, 0) // BT.709 & sRBG luma coef (Monitors, HDTV)

float pattern(float2 tex){
    #define Angle 5.0 //0: flat
    float s = sin(Angle), c = cos(Angle);
    float2 coord = tex * p0;
    float2 pt = Scale *float2(c*coord.x - s*coord.y, s*coord.x + c*coord.y);
    // return 4 *sin(pt.x) *sin(pt.y);
    float2 sp = sin(pt);
    return 4 *sp.x *sp.y;
}

float4 main(float2 tex: TEXCOORD0): COLOR {
    // return pattern(tex); //Show dot pattern
    float4 color = tex2D(s0, tex);
    float  luma  = dot(color, CoefLuma);
	luma = 10*luma-5 + pattern(tex);
    // return clamp(luma, 16/255., 245/255.); //clamp gray output: +2arithmetic
	return luma;
}
