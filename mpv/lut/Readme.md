## Lut Shaders 

CLUTs (Color Look-Up-Tables) are widely used in for color-grading and applying color effects (ex: film emulation and many free luts are available on the internet.
Mpv video player can apply text-based lut transformations through ffmpeg --vf: 
! use a relative path with / for the lut file. Input is converted to rgb24.
mpv --vf=lut3d=clut.cube video.mp4
However, this is quite cpu intensive at higher resolutions/framerates, so a shader gpu-based approach is preferable.

Mpv allows embedded (1D or 3D) textures in shaders, which can be used for fast LUT transformations. 
For Color Luts, RGB 3D textures with 3D linear interpolation can be used.
! The texture format (FBO) must be supported by the gpu driver, which can be an issue cross-platform for floating point formats (vs lightweight rgba8 texture format which is simple to encode and widely supported).
The required conversion from the available Lut formats to .hook hex-texture can be done using a Python script.  
! As mentionned in https://developer.nvidia.com/gpugems/gpugems2/part-iii-high-quality-rendering/chapter-24-using-lookup-tables-accelerate-color, a lookup coordinate correction is required in the shader. To avoid oversaturation in the case of a cube-4 identity lut: 
return texture(CLUT, 0.75*color.rgb + 0.125); //lutSize: 4
correction applied: (lutSize - 1.0)/lutSize *oldCoord + 1.0/(2.0 *lutSize)

* hald-2-identity_8x8_cube4.png (8bit haldclut level-2 identity png image, 8x8 pixels, equivalent to a 4x4x4 rgb cube): 
<img src="https://github.com/butterw/bShaders/blob/master/mpv/lut/hald-2-identity_8x8_cube4.png?raw=true" width="100" height="100">
By using an identity image as input, the output corresponds to the transformation lut (which can then be saved as png image).
The output, when an identity lut transformation is applied, is the same as the input.

Main Clut formats:
* Haldclut square .png image (24 or 48bit rgb), ex: hald level 8, 512x512 image (equivalent to cube-64: 64*64*64 colors)
* Adobe .cube, text based format with floating point r g b values, typ in the [0, 1.0] range.
The cube corresponds to a flattened (line-by-line) haldclut image. 
Filesize for cube-64: 200KB for haldclut png, 1MB for uncompressed rgb32, 2MB for .hook and 7MB for .cube !
