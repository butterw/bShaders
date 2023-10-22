Classic sharpen shaders (mods)

I plan to release modded versions of the classic sharpen shaders in the different shader formats (dx9 hlsl, dx11 hlsl, glsl.hook vo_gpu and libplacebo vo_gpu-next).

The sharpen pack will include:
- sharpen. The fastest kernel is Laplacian1(5 texture, 8 arithmetic).
- unsharp mask
- luma_sharpen (pattern 3)
- sharpen_complex
- edge_sharpen

Sharpen Strength will be easily adjustable.
It will be possible to toggle the output to edge detect/details image.
