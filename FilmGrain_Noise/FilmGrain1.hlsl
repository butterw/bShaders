// $MinimumShaderProfile: ps_2_0
#define INTENSITY 0.05

/* --- mpv FilmGrain v1 (dx9) --- */
/* v0.2 (2023-11) ported to mpc-hc by butterw, License: GPL v3
(1 texture, 30 arithmetic)

Additive Grayscale Noise.
Analysis (from test screenshot): truncated gaussian/binomial. When used pre-resize with upscaling produces a clean gaussian histogram.

parameter INTENSITY
noise intensity, ex: 0.05, typ: [0 to 0.10].

original file: https://github.com/haasn/gentoo-conf/blob/xor/home/nand/.mpv/shaders/filmgrain.glsl
Copyright (c) 2015 Niklas Haas
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
---

Performance of available hlsl filmgrain and noise shaders.
- bNoise0.hlsl: (1 texture, 12 arithmetic)
- PS_Noise.hlsl mod: (1 texture, 29 arithmetic)
- mpv FilmGrain.glsl port: (1 texture, 30 arithmetic) << this file
- semi-random grayscale noise.hlsl by janwillem32 (NoiseStrength: 1/64.) i<4: (1 texture, 38 arithmetic)
- SweetFx.FilmGrain.hlsl v1.0 4 parameters: (1 texture, 46 arithmetic)
*/
sampler s0: register(s0);
float4  p0: register(c0);
#define random frac(p0.w) //uses clock instead of random, mpv PRNG [0, 1.0]


float permute(float x) {
    x*= (34*x + 1);
    return 289 *frac(x *1.0/289);
}

float rand(inout float state) {
    state = permute(state);
    return frac(state *1.0/41);
}

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 color = tex2D(s0, tex);

    float3 m = float3(tex, random) +1.;
    float state = permute(permute(m.x) + m.y) + m.z;

    float p = 0.95*rand(state) +0.025;
    float q = p - 0.5;
    float r = q * q;

    #define a0 0.151015505647689
    #define a1 -0.5303572634357367
    #define a2 1.365020122861334
    #define b0 0.132089632343748
    #define b1 -0.7607324991323768

    float grain = q* (a2 + (a1*r +a0)/(r*r + b1*r +b0));
    grain*= 0.255121822830526; // normalize to [-1,1]

    // return 0.5 +5*INTENSITY*grain; //Show_Grain
    color.rgb+= INTENSITY*grain;
    return color;
}
