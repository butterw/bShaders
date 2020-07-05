#define Mode 1
/* barMask Mode (default 1): 1 MaskCrop, 11 Maskcrop2 (symetrical: Bottom, Right), 12 Custom Borders, 2 MaskBox, 21 MaskBox (Dynamic Fill) 3 RatioLetterbox, 4 OffsetPillarbox, 5 Circular Left-Right Image Shift, 6 Shift_Mask, 7 Shift_NoMask,
-10 No Video, 0: Disable 

--- barMask.hlsl v1.2 by butterw (Border Mask + frame Shift, perf optimized) --- 
user configuration by modifying parameters in #define.
You can create multiple versions of this shader based on your prefered parameter values/use cases (ex: BarMask-yx_916.hlsl, BarMask-LR_0.2.hlsl) 

Changelog:
v1.2: performance is optimized. 
fixed MaskCrop for negative offset.
*/

#define Red   float4(1, 0, 0, 0)
#define Black float4(0, 0, 0, 0)
#define BorderColor Red // float4(255/255., 0, 0, 0)
/*Rgba Color and xy screen coordinates, float [0. to 1.]
Topleft of screen: float2(0., 0.)

  -##1 MaskCrop Parameters: custom mask the sides of Image and re-center 
Border width, [0. to 1.] */
#define Top		0.0
#define Bottom	0.05    //** 0.
#define Right	0.20   //**
#define Left	0.15   //0.14

sampler s0: register(s0);
float2  p0: register(c0);
#define W p0.x //Image Width, float
#define H p0.y //Image Height 

bool insideBox(float2 tex, float2 topLeft, float2 bottomRight){
	/* returns true if tex coordinates inside the box, returns false otherwise
	!insideBox: outsideBox  	
	optimal code for 2D: (1 texture, 5 arithmetic) ! dealing with multiple conditions can be quite inefficient.
	*/
    float2 s = step(topLeft, tex) - step(bottomRight, tex);
    return s.x * s.y;
}

/* -##2 MaskBox Parameters --- */ 
#define BoxTopLeft	float2(0.70, 0.82)
#define BoxDim		float2(0.3, 0.18)

float4 MaskCrop2(float2 tex){ //##11: MaskCrop with symetrical Right/Bottom borders (no shift needed)
	float2 offset = 0.5*float2(Right, Bottom); //offset>0
	// return all(tex>offset && tex<1-offset) ? tex2D(s0, tex): BorderColor; //(1 texture, 6 arithmetic)
	return (insideBox(tex, offset, 1-offset)) ? tex2D(s0, tex-offset): BorderColor; //(1 texture, 5 arithmetic)
}


float4 MaskCrop(float2 tex){ //##1  >> (1 texture, 6 arithmetic)
	float2 offset = 0.5*float2(Right-Left, Bottom-Top); //offset can be negative.
	return (insideBox(tex, float2(Left, Top)+offset, 1-float2(Right, Bottom)+offset)) ? tex2D(s0, tex-offset): BorderColor; 
}

/*-##3 RatioLetterbox, Ratio>1 --- */
#define Ratio 2.35 //2., 2.35, 3.6 (21/9=2.333, 32/9=3.556,)  

float4 RatioLetterbox(float2 tex){ //##3 (1 texture, 8 arithmetic)
	float wy = 0.5 -0.5*W/(H*Ratio);
	// return (tex.y>= wy && tex.y <=1.-wy) ? tex2D(s0, tex): BorderColor; //(1 texture, 10 arithmetic)
	bool within_border = saturate(-tex.y*tex.y + tex.y + wy*wy - wy); //becomes positive when inside the border and 0 when outside
	return (within_border) ? tex2D(s0, tex): BorderColor;
}



/* inspired by PSP_Pillarbox and SweetFx Borders and others.
tested in mpc-hc v1.9.3 (pre-resize shader).

Mode
- 1 MaskCrop: mask the sides of the screen and recenter image (Top, Bottom, Left, Right custom screen Border float widths), you could use this to mask a logo at the bottom of the screen for instance (mpc-hc doesn't have a built-in crop feature). 
- 2 MaskBox: define a rectangular box on Screen with insideBox and Mask it
- 3 RatioLetterbox. custom Aspect Ratio View. Simulate a 21./9 display on a standard monitor for instance.  
- 4 OffsetPillarbox: view video as a vertical (yx) aspect ratio on a standard landscape monitor with borders on the side (ex: 9./16, 1./1, etc.). You can offset the window to compensate for a non-centered video.

The borders are image zones, which means you can apply any effect on them (see bSide): here we just mask with BorderColor.


 -##4 OffsetPillarbox, yxRatio<=1 --- 
! use 0.5624 instead of 9./16: 0.5625 (float rounding issues) 
10./16: 0.625, 3./4: 0.75, 1. */ 
#define yxRatio 0.5624 
#define Xshift 0.2 //0. [-1. to 1.], >0: Right Shift, View to the left of frame 

float4 OffsetPillarbox(float2 tex) { //##4 (1 texture, 9 arithmetic)
	float wx = 0.5*(1 -H/W * yxRatio); // calculate border width
	if (tex.x <= wx)    return BorderColor;
	if (1.-wx <= tex.x) return BorderColor;
	return tex2D(s0, tex -float2(Xshift, 0));
	//	return (tex.x>=wx && tex.x<=1.-wx) ? tex2D(s0, tex -float2(Xshift, 0)): BorderColor; //(1 texture, 10 arithmetic)
}

/*-##5 Circular Left-Right Image Shift (1 texture, 3 arithmetic) */
float4 Circular_LR_Shift(float2 tex) {
	tex.x = frac(tex.x - Xshift);
	return tex2D(s0, tex);
}

/*-##6 Shift frame + Masking (1 texture, 2 arithmetic) */
float4 Shift_Mask(float2 tex) {
	float2 offset = {Xshift, 0.};
	return all(tex*sign(offset)>= offset) ? tex2D(s0, tex-offset): BorderColor; //
}

/*-##7 Shift frame with No Masking, (1 texture, 1 arithmetic) */
float4 Shift_NoMask(float2 tex) {
	float2 offset = {0.1, 0.2};
	return tex2D(s0, tex-offset); //Shift without masking: observe (Left, Top) last pixel fill for offset>0.
}


/* --- Main --- */
float4 main(float2 tex: TEXCOORD0): COLOR {	
#if Mode==-10 //No Video Output: (1 instruction)
	return 0; // black screen, you can still have subtitles.
	
#elif Mode==1  //Custom Borders and re-center:
	return MaskCrop(tex);
#elif Mode==11 //Symetrical Borders (params: Right, Bottom):
	return MaskCrop2(tex);
#elif Mode==12 // Custom Borders, no Shift:
	if (!insideBox(tex, float2(Left, Top), float2(1-Right, 1-Bottom))) return BorderColor; //(1 texture, 5 arithmetic)	
#elif Mode==2  //Mask box:
	if (insideBox(tex, BoxTopLeft, BoxTopLeft + BoxDim)) return BorderColor;
#elif Mode==21 //Dynamic Horiz fill by Left first pixel of box:  
/*(2 texture, 11 arithmetic). you could average with a vertical fill: hatch pattern */
	if (insideBox(tex, BoxTopLeft, BoxTopLeft + BoxDim)) return tex2D(s0, float2(BoxTopLeft.x, tex.y));
#elif Mode==3  //Borders Top and Bottom: 
	return RatioLetterbox(tex);
#elif Mode==4  //Borders Left and Right: 
	return OffsetPillarbox(tex);
#elif Mode==5	
	return Circular_LR_Shift(tex);
#elif Mode==6	
	return Shift_Mask(tex);
#elif Mode==7	
	return Shift_NoMask(tex);
#endif

	return tex2D(s0, tex); //No Effect (1 texture)
}
