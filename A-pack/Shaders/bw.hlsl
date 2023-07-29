// $MinimumShaderProfile: ps_2_0
#define CoefMonochrome float4(0.18, 0.41, 0.41, 0) //Agfa 200X

/* --- bw (dx9) --- black&white */
/* v1.40 (2023-07), released by butterw under GPLv3
(1 texture, 1 arithmetic)

Transforms a video to black&white using a custom rgba to grayscale conversion coef (CoefMonochrome).
The latter can be changed to achieve a different look.

-- Grayscale Conversion Coefs --
float4(1/3., 1/3., 1/3., 0) //Equal weight
float4(0.299, 0.587, 0.114, 0) // mpc-hc Grayscale
float4(0.2126, 0.7152, 0.0722, 0) //sRGB, HDTV: CoefLuma used by bw_luma shader

Some values for black&white film from SweetFx.Monochrome by CeeJay.dk:
float4(0.18, 0.41, 0.41, 0) //Agfa 200X (default)
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
*/

sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex);

	return dot(c0, CoefMonochrome);
}