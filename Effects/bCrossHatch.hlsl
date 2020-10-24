#define Hatch_mode 3. //default: 2 [0, 1, 2, 3] 
#define White float4(245, 245, 245, 255)/255. //Background Color

/*
CrossHatch (style Effect for video content)
quad-colors: Red + 2 grays + White background
 
bCrossHatch.hlsl by butterw  (1 texture, 31 arithmetic) 
adapted from https://github.com/pixijs/pixi-filters/blob/master/filters/cross-hatch/src/crosshatch.frag (MIT License)

*/



sampler s0: register(s0);
float2  p0: register(c0); // (Width, Height)
#define _hatch 1.25*pow(2, Hatch_mode)

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 color = White; 
    float lum = length(tex2D(s0, tex)); //Gray
	
	float2 coords = floor(p0 * tex); 
	float coords_sum  = coords.x + coords.y;
	float coords_diff = coords.x - coords.y;
	
    if (lum < 1 && fmod(coords_sum, _hatch)==0) // */*
		color = 0.25;

    if (lum < 0.75 && fmod(coords_diff, _hatch)==0) // *\*
        color = float4(1., 0, 0, 1); //Red

    // if (lum < 0.50 && fmod(coords_sum-5, _hatch)==0) color = float4(0,1,0,1);// */offset*

    if (lum < 0.3 && fmod(coords_diff-5, _hatch)==0)// *\offset* 
        color = 0.5;
	return color;
}
