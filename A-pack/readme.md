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

Contrast adjustment:
- contrast.10
- contrastBW (12, 235) new black and white point

to brighten/darken:
- bLift
- bExposure (bDim-35, brighten-10, brighten 20)
- bShadows-10

black & White (Grayscale):
- Luma
- custom b&w film emulation 
