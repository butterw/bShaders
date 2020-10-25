## Noise/FilmGrain shaders

Filmgrain (on a low intensity setting) improves perceptual quality of most compressed videos. In particular content with low or no noise, ex: the source noise may have been removed at encoding to improve compressibility. It may also help mask artifacts.

The main reason not to use Filmgrain in mpc-hc/be was the performance hit on lower end systems. These new shaders offer a major speed improvement over previously available shaders without creating a visible noise pattern.

Note: The Noise/Filmgrain shader should be run after any sharpening shader (to avoid sharpening the noise). 
Issue with mpc-hc/be EVR-CP: In fullscreen post-resize, the shader also gets applied to the black bars. This is not noticeable with normal noise intensities, however. 
These shaders use the Clock parameter available in mpc-hc/be (time in seconds since the program was launched) as randomization.

### Performance of available hlsl Noise & Filmgrain shaders.
- <B> bNoise.hlsl: (1 texture, 12 arithmetic)</B> << new lightweight Shader. histogram is fairly clean for typical noise Strengths. Centering the histogram costs one extra operation. 
- PS_Noise.hlsl mod/optim: (1 texture, 18 arithmetic), non symetrical distribution
- mpv Noise.glsl port: (1 texture, 27 arithmetic), quite noisy histogram
- <B> FilmGrain1.hlsl:</B> port from mpv FilmGrain.glsl: (1 texture, 30 arithmetic), truncated gaussian lobe with a width of approx 4sigma. 
- semi-random grayscale noise.hlsl by janwillem32, i<4: (1 texture, 38 arithmetic). Clean gaussian histogram. Patterning present with less iterations !
- SweetFx.FilmGrain.hlsl v1.0: (1 texture, 46 arithmetic), 4 parameters, noise is multiplicative not additive, histogram not tested. 

Some limited quality testing was done based on the output noise histogram, but more feedback would be welcome.
The noise histograms were obtained through screenshots (at 1080p), this doesn't allow for precise analysis of the time-dependant behaviour, especially around launch.





