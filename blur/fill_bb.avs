/* fill_bb.avs, a Realtime customizable Avisynth(+) script to remove/fill Black Bars 
fullscreen Black Bars are the consequence of the source video having a different Aspect ratio from the screen, they are also sometimes added to the source at encoding.
 
by butterw, tested in mpc-hc, mpc-be, mpv video players 
v0.1: added audio

All steps are optional:
- crop video to Aspect Ratio, or in pixels
- scale video (up to max_zoom)
- fullscreen pad with solid color
- OR background: fullscreen image
- OR background: live-blurred
- fullscreen overlay(background, vid)  

variable names:
- src: source video
- bg: background video
- vid: output video

## Requires external plugins: */
# LoadPlugin("c:\Program Files (x86)\AviSynth+\plugins64+\LSMASHSource.dll")
# blurred background also requires: FastBlur.dll, AddGrainC.dll (see FrostyBorders for a dedicated encoding script)

## Output Screen Resolution:
global Ws = 1920
global Hs = 1080


function scale(clip v, int "max_zoom"){
	/* scale clip to fullscreen or if specified to max_zoom. No crop-zoom */ 
	max_zoom = default(max_zoom, 1000)
	s_factor = min(min(Ws*1.0/v.Width, Hs*1.0/v.Height), max_zoom) 
	w = int(v.Width *s_factor)/2 *2
	h = int(v.Height*s_factor)/2 *2
	Spline36Resize(v, w, h)
}

function padc(clip v, int targetW, int targetH, int "bgColor"){ 
	/* center pad clip with bgColor */
	bgColor = default(bgColor, 0) #rgb $FF0000, named preset color_darkblue,
	wx = (targetW - v.Width)/4  *2
	wy = (targetH - v.Height)/4 *2
	AddBorders(v, wx, wy, wx, wy, bgColor) #all borders must be mod2
}


##--- Load the Source ---##
/* Load the source video (mp4/mov file) */
fname = "b:\Videos\monster-2_ed.mp4"
src = LSmashVideoSource(fname, prefer_hw=3)
audio = LSmashAudioSource(fname)


/* Crop the source to Aspect Ratio  
OR with mod-2 values in pixels src.Crop(left, top, -right, -bottom) 
*/
# cropAR = 1.31
# cropL = int(0.5*(src.Width -src.Height*cropAR))/2*2
# src = src.Crop(CropL, 0, -CropL, 0)

/* Scale Video to max_zoom (no crop-zoom) */
vid = scale(src, max_zoom=10)

##--- Process the Background ---##

/* Pad Video (centered) with solid color 
ex: $a0a0a0 (grey160), $7f6065
*/
vid = padc(vid, Ws, Hs, $a0a0a0)

/* OR Load an image to use as background:
image should have fullscreen resolution, you can resize it if required */
# fname = "b:\unfocus_dk_1080p.png"
# bg = ImageSource(fname, 0, src.FrameCount-1)

/*-- OR Live Blurred Background, requires plugins: FastBlur, AddGrainC
to improve performance downscale the source before bluring: either to 256x256 or to half-resolution  
recommended resizer bspline (smooth cubic): BicubicResize(w, h, b=1, c=0)
dither and noise are used to hide the resulting artifacts 
*/  
w = 256
h = w 

## Alternative Downscale resolution:
# k = 4
# w = src.Width/k  *2 
# h = src.Height/k *2

# bg = src.BicubicResize(w, h, b=1, c=0).ColorYUV(gain_y=-30).FastBlur(8, iterations=3, dither=yes).BicubicResize(Ws, Hs, b=1, c=0).AddGrain(var=2.0) 


/* Output: Centered Overlay (Video over background) */
# Last = vid
# vid = Overlay(bg, Last, x=(bg.Width-Width)/4 *2, y=(bg.Height-Height)/4 *2)
return AudioDub(vid, audio)
