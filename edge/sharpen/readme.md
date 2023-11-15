## Sharpen shaders

I plan to release modded versions of the classic sharpen shaders in the different shader formats (dx9 hlsl, dx11 hlsl, glsl.hook vo_gpu and libplacebo vo_gpu-next).

The sharpen pack will include:
- sharpen. The fastest kernel is Laplacian1(5 texture, 8 arithmetic).
- unsharp mask
- luma_sharpen (pattern 3)
- sharpen_complex
- edge_sharpen

Sharpen Strength will be easily adjustable.
It will be possible to toggle the output to edge detect/details image.

Available:
- Contrast Adaptive Sharpening dx9/dx11 hlsl shader (AMD CAS): https://gist.github.com/butterw/ceb89a68bc0aa3b0e317660fb4bacaa3
- sCurve.hlsl shader (dx9, dx11, mpv): https://github.com/butterw/bShaders/tree/master/A-pack


