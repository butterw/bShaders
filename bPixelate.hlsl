/*--- User Settings ---*/
#define PixelateMode 2 // methods [1, 2, 3] use Npixels, [11, 12, 13] use TargetSize, def: 2  
#define Npixels 100.	// >=1 Number of output "Pixels" in the largest dimension, def: 100 
#define TargetSize 50	// >=2 Output Pixel target size 


/*--- bPixelate.hlsl, v1.0 by butterw 2020-06-23 ---
Pre-Resize shader, tested in Mpc-hc video player v1.9.3 (renderer: EVR-CP) 

Pixelation is the effect observed when you aggressively downscale resolution (to TargetSize) then resize back up the rounded Npixels.
Works for different source resolutions, aspect ratios. The effect achieved depends on the zoom of the scene. 
Can be used as an intro/transition effect (DePixelation or Pixelation/depixelation). Has a retro low-res appeal. 
Square pixels can be more appealing vs rectangular pixels, especially for low npixels values, but require more arithmetic operations. 
*/

sampler s0: register(s0); 
float2  p0: register(c0); 
#define W p0.x // Image Width
#define H p0.y // Height
#define Green float4(0, 1, 0, 0)

/* --- Pixelate(tex, npixels) ---
npixels>1.: the number of pixels in the largest dimension
a wide range of values is possible, ex: Npixels: [1, 400], TargetSize: [2, 100] 

- to achieve a fixed TargetSize vs input resolution: Pixelate(tex, max(W, H)/TargetSize)
*/ 
float4 Pixelate1(float2 tex, float npixels){
	/* rectangular pixels.
	simplest/fastest version (1texture, 4arithmetic)
	*/
	return tex2D(s0, floor(tex*npixels)/npixels); 
}

float4 Pixelate2(float2 tex, float npixels){
	/* with square pixels, (1texture, 11arithmetic)	*/ 
	float pixelSize = max(W, H)/npixels;
	return tex2D(s0, floor(tex*p0/pixelSize)*pixelSize/p0);
}

float4 Pixelate3(float2 tex, int npixels){
	/* with square pixels and offset, int npixels>1 
	(1texture, 22arithmetic), test: 1280x720, n=7, n=45 
	*/ 
	int pixelSize = max(W, H)/npixels;
	float2 dpixel = pixelSize-(p0 %pixelSize)/2.;	
	return tex2D(s0, floor((p0*tex+dpixel)/pixelSize) *pixelSize/p0);
}

  
float4 main(float2 tex: TEXCOORD0): COLOR {
	#if PixelateMode == 1
		return Pixelate1(tex, Npixels);
	#elif PixelateMode == 2	
		return Pixelate2(tex, Npixels);
	#elif PixelateMode == 3		
		return Pixelate3(tex, Npixels);
	#endif
	
	float npixels = max(W, H)/TargetSize;			
	#if PixelateMode == 11
		return Pixelate1(tex, npixels);
	#elif PixelateMode == 12
		return Pixelate2(tex, npixels);
	#elif PixelateMode == 13
		return Pixelate3(tex, npixels);
	#endif
	
	return Green;
}