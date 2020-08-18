H=720
W=1280
colormatrix = "rec709"# #default: "rec709" Limited range vs Full: "pc.709" 

/* gen_ColorBarsHD.avs
by butterw, v0.1 Avisynth script

Generates ColorBarsHD video of the desired resolution with Full "pc.709" or Limited "rec709" Range
	- Full Range pc.709 keeps the range unchanged 
	- rec709 expands 16-235 YUV to 0-255 RGB
- set W x H resolution
- you can offset YUV values with ColorYUV()
- RGB32 or YV12 output, .avs can be opened by mpc-hc/be
	- Rgb32 output allows you to bypass default yuv-to-rgb conversion performed at the input of the video player (with range expansion in mpc-hc/be for a video stream not tagged as full range).

Typical PC Display Pipeline: 
Compressed video file (yuv420p8, Limited Range, untagged) >>mpc-hc Video player (rgb32, range expanded to Full Range) >> graphics driver (rbg32 Output, Full Range) >> Hdmi >> Monitor (Full Range) 
- Historically TV/HDTV have used limited range input and PC monitor full RGB range.
- Most current displays should allow you to set the desired input range (if you change this value, you probably also need to adjust brightness, contrast, gamma for good results). 
For accurate representation of grey levels and colors your monitor/HDTV and graphics settings should match: Full-PC or Limited-Low.

Script was used to generate and save (rename was required !):
- avs_pc.709_720p-001.png
- avs_rec709_720p-002.png

The ColorBarsHD test pattern contains colors in the YUV(Y'CbCr) format used by typical media files (ex: mp4\x264, x265): 
- Black: 16,  128, 128
- White: 235, 128, 128

Corresponding RGB values:
- Black, Limited Range: 16, 16, 16    vs Full Range: 0, 0, 0
- White, Limited Range: 235, 235, 235 vs Full Range: 255, 255, 255

You can check these values using the YUV pixel picker tool of the AvsPmod editor output display or with any on-screen RGB pixel picker.
Checking the colors as displayed by the monitor is more difficult (Calibration probe req. ?), but at minimum you must be able to control the input, which these test patterns allow you to do.
*/
ColorBarsHD(width=W, height=H)
ConvertToYV12(matrix=colormatrix) 
## ColorYUV(off_y=-16)
#~ ConvertToRGB(matrix=colormatrix)   
Subtitle(String(PixelType) +" "+ colormatrix +" "+ string(Width) +"x"+ string(Height))
#~ fmt_str = "avs" + String(Height) + "p-" 
#~ ImageWriter(fmt_str, 1, 1, type = "png", info = true) ##Save a png image in the script directory 
