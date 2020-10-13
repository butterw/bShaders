#define Scale 0.4 //[0.3, 0.6] default: 0.4. Higher for smaller dots

/*
Dots-bi.hlsl (dx9 pixel shader tested in mpc-hc)
ported by butterw 
originally from https://github.com/pixijs/pixi-filters/blob/master/filters/dot/src/dot.frag (MIT License)

Video effect with 2 color output. Can be used Post-resize
*/
sampler s0: register(s0);
float2  p0: register(c0); //W, H
#define CoefLuma float4(0.2126, 0.7152, 0.0722, 0) // BT.709 & sRBG luma coef (Monitors, HDTV)

float pattern(float2 tex){
	#define Angle 5.
	float s = sin(Angle), c = cos(Angle);
    float2 coord = tex * p0;
    float2 pt = Scale* float2(c*coord.x - s*coord.y,
		                      s*coord.x + c*coord.y );
    return 4 *sin(pt.x) *sin(pt.y);
}

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 color = tex2D(s0, tex);
	float  luma  = dot(color, CoefLuma);
	return clamp(10*luma-5 + pattern(tex), 16/255., 245/255.); //clamp bi-output
}
