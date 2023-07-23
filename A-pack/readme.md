## Color Adjustment pixel shader pack (A-pack, dx9, dx11 hlsl and mpv glsl .hook)
Performance optimized shaders designed to allow easy color adjustments, typically useful when watching (web) videos. Runs on integrated graphics.
https://github.com/butterw/bShaders/tree/master/A-pack
code released under GPL v3 by butterw

For applications such as video players+renderers with support for rgb pixel shader integration:

A-pack custom user shaders:
- Shaders (mpc-hc, mpc-be, etc.)
	dx9 hlsl shaders. Can be used with evr-cp or mpc-vr renderers.
- Shaders11 (mpc-hc, mpc-be, etc.)
	dx11 hlsl shaders. Can be used in mpc-vr (post-resize only). 
- mpv 
	glsl .hook shaders (for default vo=gpu, and vo=gpu_next)

The shaders are lightweight and typically only have one or no (user tunable) parameters. In general, parameter values are in [-1, 1.0] interval, with 0 corresponding to no effect.


### Shaders

to brighten/darken:
Using a legacy Brightness (rgb shift) adjustment is not recommended, there are better solutions.
- bLift, doesn't affect white point 
- bExposure (brighten.10, brighten-10, bDim-35), doesn't affect black point
- bShadows-10
- tooDark-30 (Photoshop Screen Blend curve)

Contrast adjustments:
- contrast.10, symmetrical rgb expansion around midpoint 0.5.
- contrastBW (12, 235) new black and white point

Black & White:
- Luma (HDTV rec709 Coef)
- Custom b&w film emulation (rgb to Grayscale)

### Curve Comparison Plots 
- https://github.com/butterw/bShaders/tree/master/img
![](https://raw.githubusercontent.com/butterw/bShaders/master/img/Curves_basics.png)
- https://github.com/butterw/bShaders/blob/master/img/Curves_basics.png?raw=true
- https://www.desmos.com/calculator/eibkoj8sgp (interactive plot for tooDark-30 curve, comparison with bGamma-15 and bExposure.10)
- https://github.com/butterw/bShaders/blob/master/img/Contrast.14_vs_ContrastBW.png?raw=true
- https://raw.githubusercontent.com/butterw/bShaders/master/img/Lift_vs_Brightness_0.1-0.1.png
- https://github.com/butterw/bShaders/blob/master/img/Exposure_vs_Brightness10-10.png?raw=true
- https://github.com/butterw/bShaders/blob/master/img/Shadows-15_vs_Lift_Brightness-10.png?raw=true
