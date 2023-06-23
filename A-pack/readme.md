## Color Adjustment pixel shader pack (A-pack, dx9, dx11 and mpv.hook)
https://github.com/butterw/bShaders/tree/master/A-pack
code released under GPL v3 by butterw

For video players+renderers which support user pixel shader integration:

A-pack:
- Shaders (mpc-hc, mpc-be, etc.)
	dx9 hlsl shaders. Can be used with evr-cp or mpc-vr 
- Shaders11 (mpc-hc, mpc-be, etc.)
	dx11 hlsl shaders. Can be used in mpc-vr (post-resize only). 
- mpv 
	glsl .hook shaders.


The shaders are lightweight and typically only have one (user tunable) parameter.
They are designed to allow easy color adjustments. These can typically be useful when watching (web) videos.


### Shaders

Contrast adjustments:
- contrast.10, symmetrical rgb expansion around midpoint 0.5.
- contrastBW (12, 235) new black and white point

to brighten/darken:
- bLift, doesn't affect white point
- bExposure (bDim-35, brighten-10, brighten 20), doesn't affect black point
- bShadows-10

black & White:
- Luma
- custom b&w film emulation (rgb to Grayscale)

### Curve Comparison Plots
- https://github.com/butterw/bShaders/blob/master/img/Contrast.14_vs_ContrastBW.png?raw=true
- https://raw.githubusercontent.com/butterw/bShaders/master/img/Lift_vs_Brightness_0.1-0.1.png
- https://github.com/butterw/bShaders/blob/master/img/Exposure_vs_Brightness10-10.png?raw=true
- https://github.com/butterw/bShaders/blob/master/img/Shadows-15_vs_Lift_Brightness-10.png?raw=true
