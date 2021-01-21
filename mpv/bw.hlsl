#define Mode 25 //[1, 2, 3, 4]

/* bGray.hlsl: "Black&White" shader by butterw v0.1, RGB to grayscale conversion 
Mode 1: CoefLuma, sRGB grayscale 
Mode 2: CoefMonochrome, custom grayscale effect
Mode 25: CoefMonochrome, with increased contrast
Mode 3: Equal Weight 
Mode 4: BrightnessMap Visualization with 4 levels.
*/ 

/* --- Grayscale Conversion Coefs --- 
 
float4(1/3., 1/3., 1/3., 0) //Equal weight
float4(0.299, 0.587, 0.114, 0) ## mpc-hc Grayscale

Some values for black&white film from SweetFx.Monochrome by CeeJay.dk: 
float4(0.18, 0.41, 0.41, 0) //Agfa 200X (default for Mode 2)
float4(0.25, 0.39, 0.36, 0) //Agfapan 25
float4(0.21, 0.40, 0.39, 0) //Agfapan 100
float4(0.20, 0.41, 0.39, 0) //Agfapan 400 
float4(0.21, 0.42, 0.37, 0) //Ilford Delta 100
float4(0.22, 0.42, 0.36, 0) //Ilford Delta 400
float4(0.31, 0.36, 0.33, 0) //Ilford Delta 400 Pro & 3200
float4(0.28, 0.41, 0.31, 0) //Ilford FP4
float4(0.23, 0.37, 0.40, 0) //Ilford HP5
float4(0.33, 0.36, 0.31, 0) //Ilford Pan F
float4(0.36, 0.31, 0.33, 0) //Ilford SFX
float4(0.21, 0.42, 0.37, 0) //Ilford XP2 Super
float4(0.24, 0.37, 0.39, 0) //Kodak Tmax 100
float4(0.27, 0.36, 0.37, 0) //Kodak Tmax 400
float4(0.25, 0.35, 0.40, 0) //Kodak Tri-X


Function FlimsYlevels(clip clp, float amp)
       { wicked="x x 16 - 34.85493 / sin "+string(amp)+" * -"
         return( clp.mt_lut(Yexpr = wicked) )  
         }

    FlimsYlevels(clip, amp) 

    amp - sets the strenght, or amplitude, of the effect. 

*/
#define CoefMonochrome float4(0.18, 0.41, 0.41, 0) //Agfa 200X
#define CoefLuma float4(0.2126, 0.7152, 0.0722, 0) //sRGB, HDTV

sampler s0: register(s0);

float brightnessMap(float4 colorInput){
	float lum = dot(colorInput, float4(0.299, 0.587, 0.114, 0)); // map function calculated from (R, G, B)	
	/* Output colors: C0 is the darkest color, C3 is the lightest */
	#define C3 0.95
	#define C2 0.7
	#define C1 0.45 
	#define C0 0.1
	lum = (lum>0.8) ? C3: (lum>0.6) ? C2: (lum>0.2) ? C1: C0;
	return lum;
}

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex); //Color
	
#if Mode==1	//sRGB Luma
	return dot(c0, CoefLuma);
#elif Mode==2
	// return dot(c0, float4(0.2, 0.25, 0.25, 0));
	return dot(c0, CoefMonochrome);
#elif Mode==25	
	return dot(c0, 1.35*CoefMonochrome); //with increased Contrast, ex: *1.35
#elif Mode==3  
	return dot(c0.rgb, 1/3.);
#else // Mode==4: brightnessMap
	return brightnessMap(c0);
#endif
}
