/**
 * SweetFx.FilmGrain.hlsl
 * Computes a noise pattern and blends it with the image to create a film grain look.
 *
 * ported to mpc video player .hlsl by butterw (tested on mpc-hc v1.9.3): 
 * 	Intensity, Variance set high so that the grain is visible, also wanted the grain to be less static and added Show_FilmGrain option. 
---
Original file: https://github.com/CeeJayDK/SweetFX/blob/master/Shaders/FilmGrain.fx
version 1.0 by Christian Cann Schuldt Jensen ~ CeeJay.dk under MIT License:
Copyright (c) 2014 CeeJayDK

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#define Intensity  1.  // 0.5 [0.0 to 1.0] How visible the grain is. Higher is more visible.
#define Variance  0.8 // 0.4 [0.0 to 1.0] Controls the variance of the Gaussian noise. Lower values look smoother.
#define Mean      0.5  // 0.5 [0.0 to 1.0] Affects the brightness of the noise.
#define SignalToNoiseRatio 6. // 6.[0.0 to 16] Higher Signal-to-Noise Ratio values give less grain to brighter pixels. 0 disables this feature.
#define Show_FilmGrain 0 //0: Off [0 or 1] Noise only output for testing.



sampler s0: register(s0);
float4 p0:  register(c0);
#define Clock (p0[3])
#define PI 3.1415927

/* --- FilmGrain v1.0 (1 texture, 46 arithmetic) --- */

// float3 FilmGrainPass(float4 vpos: SV_Position, float2 texcoord: TexCoord): SV_Target{
float4 FilmGrain(float4 color, float2 texcoord){	
	// float3 color = tex2D(s0, texcoord).rgb;
  
	//float inv_luma = dot(color, float3(-0.2126, -0.7152, -0.0722)) + 1.0;
	float inv_luma = dot(color, float4(-1/3., -1/3., -1/3., 0)) + 1.; //Calculate the inverted luma so it can be used later to control the variance of the grain
  
	/*---------------------.
	| :: Generate Grain :: |
	'---------------------*/

	float t = Clock; //*0.0022337; //butterw
	
	//PRNG 2D - create two uniform noise values and save one DP2ADD
	// float seed = dot(texcoord, float2(12.9898, 78.233));// +t; 
	float seed = dot(texcoord, float2(12.9898, 78.233))+t; //butterw
	
	float sine; float cosine; sincos(seed, sine, cosine);
	// float sine = sin(seed); float cosine = cos(seed);
	float uniform_noise1 = frac(sine*43758.5453   +t); //I just salt with t because I can
	float uniform_noise2 = frac(cosine*53758.5453 -t); // and it doesn't cost any extra ASM

	//Get settings
	float stn = SignalToNoiseRatio != 0 ? pow(abs(inv_luma), SignalToNoiseRatio): 1.0; // Signal to noise feature - Brighter pixels get less noise.
	float variance = (Variance*Variance) *stn;
	// float mean = Mean;

	//Box-Muller transform
	uniform_noise1 = (uniform_noise1 < 0.0001) ? 0.0001: uniform_noise1; //fix log(0)
		
	float r = sqrt(-log(uniform_noise1));
	r = (uniform_noise1 < 0.0001) ? PI: r; //fix log(0) - PI happened to be the right answer for uniform_noise == ~ 0.0000517.. Close enough and we can reuse a constant.
	float theta = 2*PI *uniform_noise2;
	
	float gauss_noise1 = variance* r*cos(theta) + Mean;
	//float gauss_noise2 = variance * r * sin(theta) + mean; //we can get two gaussians out of it :)

	//gauss_noise1 = (ddx(gauss_noise1) - ddy(gauss_noise1)) * 0.50  + gauss_noise2;
  

	//Calculate how big the shift should be
	//float grain = lerp(1.0 - Intensity,  1.0 + Intensity, gauss_noise1);
	float grain = lerp(1+Intensity, 1-Intensity, gauss_noise1);
  
	//float grain2 = (2*Intensity) *gauss_noise1 + (1-Intensity);
	 
	//Apply grain
	color = color * grain;

  
	//color = lerp(color,colorInput.rgb,sqrt(luma));

	/*-------------------------.
	| :: Debugging features :: |
	'-------------------------*/
#if Show_FilmGrain == 1	
	// color = (grain-1.)*2. + 0.35;
	color = frac(gauss_noise1) -0.35; //show the noise //butterw-0.35
#endif	
	
	//color.rgb = (gauss_noise1 > 0.999) ? float3(1.0,1.0,0.0) : 0.0 ; //does it reach 1.0?
	
	return color;
}

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex);

	return FilmGrain(c0, tex);
}