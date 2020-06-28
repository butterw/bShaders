/* --- Parameters ---
Timings, float>=0 in seconds 
Color, rgba float4 [0, 1] 
*/
#define Tfirst 3. //10.	// Time of the first run
#define Tcycle 10. //4.	// Repetition period. 0: No repetition.
#define Td 2. 		    // Duration. 0: deactivates the effect.
#define ScreenColor float4(16., 16., 16., 0)/255 //rgba [0, 1.]
#define End -2//-2 //26.5  
/* 0: no End Condition (default)
>0: End time in seconds ex: 26.5 
<0: a max number of runs of the Effect, ex -2: the effect will run twice.

*/

/* --- bStrobe.hlsl --- v1.0 by butterw
Ready to use time-configurable color frame Effect.
Parameters: ScreenColor, Time of first run (Tfirst), Duration (Td), Repetition period (Tcycle), End (Number of runs, End time or No End).
timings specified in seconds, or in video frames if you replace Clock by Counter (untested).

Tested in mpc-hc v1.9.3: 
- Opening the player by double clicking a video starts Clock
- Note that Opening another video or doing Pause/Stop does not reset Clock 

Lightweight performance: (1 texture, 11 arithmetic).
*/



/* --- Global Constants --- */
sampler s0: register(s0);
float4  p0: register(c0);
// #define Counter p0.z //float frame counter, starting at 0.
#define Clock p0.w //in s, starting at 0., updated every frame


float4 Strobe(float4 inputColor) {
	/* returns the provided input color: Placeholder for any effect/glitch */	
	return inputColor;
}	

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex);
	
	int nRuns = (Tcycle>0) ? trunc(max((Clock - Tfirst), 0)/Tcycle): 0; //Run Counter >=0 (limitation: no persistent variables!)
	if ((End>0 && Clock>End) || (End<0 && nRuns+1>(-End))) return c0;   //End Condition
	
	float tstart = Tfirst + nRuns*Tcycle;	
	if (Clock>=tstart && Clock<tstart+Td) return ScreenColor;//return Strobe(ScreenColor);
	return c0;
}