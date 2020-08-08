H=720
W=1280
colormatrix = "rec709"# #default: "rec709" Limited range vs Full: "pc.709" 

/* gen_ColorBarsHD.avs
by butterw

Generates ColorBarsHD video with full or Limited Range , rgb32 output
*/

ColorBarsHD(width=W, height=H).ConvertToRGB(matrix=colormatrix)  
Subtitle(String(PixelType) +" "+ colormatrix +" "+ string(Width) +"x"+ string(Height))
#~ fmt_str = "avs" + String(Height) + "p-" 
#~ ImageWriter(fmt_str, 1, 1, type = "png", info = true) ##Save a png image in the script directory 