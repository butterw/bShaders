//!HOOK CHROMA
//!BIND HOOKED
//!DESC NoChroma

vec4 hook() {return vec4(0.5);} //enforces grayscale on yuv source

/* luma Sobel_Edge(Threshold T_Sobel ex: 0.15-0.3)
v0.5 by butterw 

HOOK points:
- CHROMA:NoChroma
- if no resize: (LUMA:hw.gSmooth3) > LUMA:Sobel_Edge
- if upscaling: (LUMA:hw.gSmooth3) > OUTPUT:Sobel_Edge
Smoothing may not be necessary, especially if a smooth scaler is in use (Mitchell-Netravali(1/3., 1/3.), BSpline(1, 0)).

default output is Dark on White_limit background.
set the threshold to achieve good detection.
*/

//!HOOK LUMA
//!BIND HOOKED
//!DESC hw.gSmooth3

#define texo(uv) HOOKED_texOff(uv).r
vec4 hook(){ //hw.gSmooth3 (3x3 gaussian kernel) using hw linear sampling, tex:4
    #define po 0.5
    float blur;
    blur = texo(vec2(-po, -po));
    blur+= texo(vec2(-po,  po));
    blur+= texo(vec2( po, -po));
    blur+= texo(vec2( po,  po));
    return vec4(blur*0.25);
}

//!HOOK NONE LUMA
//!BIND HOOKED
//!DESC Sobel_Edge

#define T_Sobel 0.15 //Threshold: higher means less detection on screen

#define texo(uv) HOOKED_texOff(uv).r
vec4 hook(){ //8 tex
	float c8 = texo(1);
	      c8-= texo(-1);
	float c3 = texo(vec2( 1,-1));
		  c3-= texo(vec2(-1, 1));	
	float c5 = texo(vec2( 1, 0));
		  c5-= texo(vec2(-1, 0));
	vec2 g;
	g.x = c8 +c3 +2*c5;
	c8-= c3;
	float c7 = texo(vec2(0, 1));
	      c7-= texo(vec2(0,-1));
	g.y = c8 +2*c7;
	float edge = length(g);

	#define White_limit 180/255. // <1. to avoid bright white 
	// return (edge>T_Sobel) ? vec4(min(edge, White_limit)): vec4(0);
	return (edge<T_Sobel) ? vec4(White_limit): vec4(1-1.4*max(edge, 0.25)); // Inverted: dark grey on white background

}

//!HOOK OUTPUT
//!BIND HOOKED
//!DESC Sobel_Edge

#define T_Sobel 0.3 //Threshold: higher means less detection on screen

#define CoefLuma vec4(0.212656, 0.715158, 0.072186, 0) // BT.709 & sRBG luma coef (HDTV, SDR Monitors)
#define texo(uv) HOOKED_texOff(uv)
vec4 hook(){ 
	vec4 c8 = texo(1);
	     c8-= texo(-1);
	vec4 c3 = texo(vec2( 1,-1));
		 c3-= texo(vec2(-1, 1));	
	vec4 c5 = texo(vec2( 1, 0));
		 c5-= texo(vec2(-1, 0));
	vec2 g;
	g.x = dot(c8 +c3 +2*c5, CoefLuma);
	c8-= c3;
	vec4 c7 = texo(vec2(0, 1));
	     c7-= texo(vec2(0,-1));
	g.y = dot(c8 +2*c7, CoefLuma);
	float edge = length(g);

	#define White_limit 180/255. // <1. to avoid bright white 
	// return (edge>T_Sobel) ? vec4(edge): vec4(0);	
	// return (edge>T_Sobel) ? vec4(min(edge, White_limit)): vec4(0);
	return (edge<T_Sobel) ? vec4(White_limit): vec4(1-1.4*max(edge, 0.25)); // Inverted: dark grey on white background
}
