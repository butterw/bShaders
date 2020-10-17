#define Strength 4. //ex: 16.0

sampler s0: register(s0);
float4  p0: register(c0);
#define Clock p0.w

/* 	bNoise.hlsl, cheap hlsl noise (1 texture, 12 arithmetic) 
tweaked by butterw from: https://www.shadertoy.com/view/4sXSWs posted by jcant0n (glsl)
*/

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 color = tex2D(s0, tex);
	float2 otex = 3*tex + 12; 
	float x = otex.x * otex.y * 10*Clock;

	float4 noise = Strength*fmod((fmod(x, 13.0) + 1.0) *(fmod(x, 123.0) + 1.0), 0.01); //-0.005
	// return 10 *noise; //Noise output
	return color + noise; //color + noise;
}
