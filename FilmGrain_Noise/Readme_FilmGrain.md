## Noise/FilmGrain shaders

Filmgrain (on a low intensity setting) improves perceptual quality of most videos. In particular content with low or no noise, (ex: the source noise may have been removed to at encoding to improve compressibility). It may also help mask some artefacts.

Note: Noise/Filmgrain shaders should be run after any sharpening shader (to avoid sharpening the noise), meaning they may have to run post-resize. 
Known issue with mpc-hc/be: In fullscreen post-resize, the shader also gets applied to the black bars. Which is not desireable at all in this case ! 

Performance of available hlsl filmgrain and noise shaders.
- bNoise0.hlsl: (1 texture, 12 arithmetic)
- mpv Noise.glsl port: (1 texture, 27 arithmetic) 
- PS_Noise.hlsl mod: (1 texture, 29 arithmetic)
- mpv FilmGrain.glsl port: (1 texture, 30 arithmetic) << this file
- semi-random grayscale noise.hlsl by janwillem32 (NoiseStrength: 1/64.) i<4: (1 texture, 38 arithmetic)
- SweetFx.FilmGrain.hlsl v1.0 4 parameters: (1 texture, 46 arithmetic)

TODO: Quality evaluation of the different Noise/FilmGrain implementations by analysing the statistics of the noise function.
