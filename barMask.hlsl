#define Mode 1 
/* barMask Mode (default 1): 1 MaskCrop (custom borders + re-center), 11 Maskcrop2 (symmetrical: Bottom, Right), 12 Custom Borders (no re-center)
111 Symmetrical Borders defined in pixels (BorderPixels), 112 Custom Borders defined in pixels 
2 MaskBox, 21 MaskBox (Dynamic Fill) 
3 RatioLetterbox, 4 OffsetPillarbox, 
5 Circular Left-Right Image Shift, 6 Shift_Mask, 7 Shift_NoMask,
8 Downsample 2x fastest (output in top-left Quarter frame )
0: Disable, -10 No Video.  

--- barMask.hlsl v1.35 by butterw (Border Mask + frame Shift, perf optimized) --- 
user configuration by modifying parameters in #define.
You can create multiple versions of this shader based on your prefered parameter values/use cases (ex: BarMask-yx_916.hlsl, BarMask-LR_0.2.hlsl)
tested in mpc-hc v1.9.6 (as pre-resize shader, also works fullscreen post-resize).
The borders are image zones, which means you can apply any effect on them (see bSide): here we just mask with BorderColor. 

--- Changelog:
v1.2: performance is optimized. fixed MaskCrop for negative offset.
v1.3 (08/07/2020): Added border modes in pixels, Downsample 2x. Code cleanup.
v1.35 correction Mode 8: Fastest downsample 2x resize (1 texture, 1 arithmetic): more aliasing than with full bilinear resize.  
*/

#define Red   float4(1, 0, 0, 0) //float4(255/255., 0, 0, 0)
#define Black float4(0, 0, 0, 0)
#define BorderColor Red 
/*Rgba Color and xy screen coordinates, float [0. to 1.]


##1 MaskCrop Parameters: custom mask the sides of Image and re-center 
Border width, [0. to 1.] */
#define Top		0.0
#define Left	0.15   //0.14
#define Bottom	0.1    //** 0.
#define Right	0.   //**


bool insideBox(float2 tex, float2 topLeft, float2 bottomRight){
	/* returns true if tex coordinates inside the box, returns false otherwise
	!insideBox: outsideBox  	
	optimal code for 2D: (1 texture, 5 arithmetic) ! dealing with multiple conditions can be quite inefficient.
	*/
    float2 s = step(topLeft, tex) - step(bottomRight, tex);
    return s.x * s.y;
}
sampler s0: register(s0);
float2  p0: register(c0);
float2  p1: register(c1);
#define W p0.x //Image Width, float
#define H p0.y //Image Height 


/* -##2 MaskBox Parameters --- 
Topleft of screen: float2(0., 0.)
*/ 
#define BoxTopLeft	float2(0.70, 0.82)
#define BoxSize		float2(0.3, 0.18)

float4 MaskCrop2(float2 tex){ //##11: MaskCrop with symmetrical Right/Bottom borders (no shift needed)
	float2 offset = 0.5*float2(Right, Bottom); //offset>0
	// return all(tex>offset && tex<1-offset) ? tex2D(s0, tex): BorderColor; //(1 texture, 6 arithmetic)
	return (insideBox(tex, offset, 1-offset)) ? tex2D(s0, tex-offset): BorderColor; //(1 texture, 5 arithmetic)
}

#define BorderPixels float2(10, 20)
float4 MaskCrop2_pixels(float2 tex){ //##111: MaskCrop with symmetrical borders in pixels (1 texture, 7 arithmetic)
	float2 w = p1*BorderPixels; 
	// return all(tex>w && tex<1-w) ? tex2D(s0, tex): BorderColor; //(1 texture, 8 arithmetic)
	float2 within_border = saturate(-tex*tex + tex + w*w - w);
	return (all(within_border)) ? tex2D(s0, tex): BorderColor; //(1 texture, 7 arithmetic)
}

float4 MaskCrop(float2 tex){ //##1  >> (1 texture, 6 arithmetic)
	float2 offset = 0.5*float2(Right-Left, Bottom-Top); //offset can be negative.
	return (insideBox(tex, float2(Left, Top)+offset, 1-float2(Right, Bottom)+offset)) ? tex2D(s0, tex-offset): BorderColor; 
}

/* -##3 RatioLetterbox, Ratio>1 --- */
#define Ratio 2.35 //2., 2.35, 3.6 (21/9=2.333, 32/9=3.556,)  

float4 RatioLetterbox(float2 tex){ //##3 (1 texture, 8 arithmetic)
	float wy = 0.5 -0.5*W/(H*Ratio);
	// return (tex.y>= wy && tex.y <=1.-wy) ? tex2D(s0, tex): BorderColor; //(1 texture, 10 arithmetic)
	bool within_border = saturate(-tex.y*tex.y + tex.y + wy*wy - wy); // positive when inside the border and 0 when outside 
	return (within_border) ? tex2D(s0, tex): BorderColor; // Optimization from Sweetfx Borders
}

/* -##4 OffsetPillarbox, yxRatio<=1 --- 
! use 0.5624 instead of 9./16: 0.5625 (float rounding issues) 
10./16: 0.625, 3./4: 0.75, 1. */ 
#define yxRatio 0.5624 
#define Xshift 0.2 //0. [-1. to 1.], >0: Right Shift, View to the left of frame 

float4 OffsetPillarbox(float2 tex){ //##4 (1 texture, 9 arithmetic)
	float wx = 0.5*(1 -H/W * yxRatio);  // calculate border width
	if (tex.x <= wx)    return BorderColor;
	if (1-wx  <= tex.x) return BorderColor;
	return tex2D(s0, tex -float2(Xshift, 0));
	//	return (tex.x>=wx && tex.x<=1.-wx) ? tex2D(s0, tex -float2(Xshift, 0)): BorderColor; //(1 texture, 10 arithmetic)
	// bool within_border = saturate(-tex.x*tex.x + tex.x + wx*wx - wx);
	// return (within_border) ? tex2D(s0, tex -float2(Xshift, 0)): BorderColor; //(1 texture, 9 arithmetic)
}

/* -##5 Circular Left-Right Image Shift (1 texture, 3 arithmetic) */
float4 Circular_LR_Shift(float2 tex){
	tex.x = frac(tex.x - Xshift);
	return tex2D(s0, tex);
}

/* -##6 Shift frame + Masking (1 texture, 2 arithmetic) */
float4 Shift_Mask(float2 tex){
	float2 offset = {Xshift, 0.};
	return all(tex*sign(offset)>= offset) ? tex2D(s0, tex-offset): BorderColor;
}

/* -##7 Shift frame with No Masking, (1 texture, 1 arithmetic) */
float4 Shift_NoMask(float2 tex){
	float2 offset = {0.1, 0.2};
	return tex2D(s0, tex-offset); //Shift without masking: observe (Left, Top) last pixel fill for offset>0.
}

/* --- Main --- */
float4 main(float2 tex: TEXCOORD0): COLOR {	
	// float4 c0 = tex2D(s0, tex); //! the compiler sometimes performs worse without this. 
#if Mode==-10 //No Video Output: (1 instruction)
	return 0; // black screen, but you can still have subtitles.
	
#elif Mode==1  //Custom Borders and re-center:
	return MaskCrop(tex);
#elif Mode==11 //Symmetrical Borders (Bottom, Right):
	return MaskCrop2(tex);
#elif Mode==111 //Symmetrical Borders defined in pixels:
	return MaskCrop2_pixels(tex);
#elif Mode==112 //custom Borders defined in pixels:	
	if (!insideBox(tex, p1*float2(Left, Top), 1-p1*float2(Right, Bottom))) return BorderColor; //(1 texture, 10 arithmetic)
#elif Mode==12 // Custom Borders, no Shift:
	if (!insideBox(tex, float2(Left, Top), float2(1-Right, 1-Bottom))) return BorderColor; //(1 texture, 5 arithmetic)	
#elif Mode==2  //Mask box:
	if (insideBox(tex, BoxTopLeft, BoxTopLeft + BoxSize)) return BorderColor;
#elif Mode==21 //Dynamic Horiz fill by Left first pixel of box:  
	if (insideBox(tex, BoxTopLeft, BoxTopLeft + BoxSize)) return tex2D(s0, float2(BoxTopLeft.x, tex.y));
	/*(2 texture, 11 arithmetic). you could average with a vertical fill to get a 2D pattern */
#elif Mode==3  //Borders Top and Bottom: 
	return RatioLetterbox(tex);
#elif Mode==4  //Borders Left and Right + Offset: 
	return OffsetPillarbox(tex);
#elif Mode==5	
	return Circular_LR_Shift(tex); //(1 texture, 3 arithmetic)
#elif Mode==6	
	return Shift_Mask(tex); 	//(1 texture, 2 arithmetic)
#elif Mode==7	
	return Shift_NoMask(tex); //(1 texture, 1 arithmetic)
#elif Mode==8	//Downsample 2x, Output in top-left quarter frame.   
	return tex2D(s0, 2*tex); //(1 texture, 1 arithmetic) Fastest resize. More aliasing than with full bilinear resize.	 
#endif

	return tex2D(s0, tex); //c0; //No Effect (1 texture)
}



/* inspired by PSP_Pillarbox and SweetFx Borders and others.

Mode
- 1 MaskCrop: mask the sides of the screen and recenter image (Top, Bottom, Left, Right custom screen Border float widths), you could use this to mask a logo at the bottom of the screen for instance (mpc-hc doesn't have a built-in crop feature). 
- 2 MaskBox: define a rectangular box on Screen with insideBox and Mask it
- 3 RatioLetterbox. custom Aspect Ratio View. Simulate a 21./9 display on a standard monitor for instance.  
- 4 OffsetPillarbox: view video as a vertical (yx) aspect ratio on a standard landscape monitor with borders on the side (ex: 9./16, 1./1, etc.). You can offset the window to compensate for a non-centered video.
*/
