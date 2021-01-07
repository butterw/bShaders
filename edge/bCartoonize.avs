* bCartoonize.avs
v0.1 https://github.com/butterw/bShaders
https://forum.doom9.org/showthread.php?t=182043&page=2

Realtime Cartoonize effect for Avisynth+.
Edge detection (Sobel operator) is inverted (dark edges). 
Canny.bw produces single pixel width black edges on white background.

input: YUV (8bit planar), not RGB32!
Recommended: clean well-lit mp4 video with resolution: 720p or more.

# LoadPlugin("c:\Program Files\AviSynth+\plugins64+\)
External plugins required: 
- TCannyMod.dll (Sobel 3x3 edge detection, pre: gaussian blur(sigma), post: Canny)  
- Masktools2.dll (for edge mask + merge)
- LSMASHSource.dll to load video/audio  

Mode:
10: edge + Chroma (stronger detection means darker color)
1 (Default): edge + Chroma (with a small uv offset)
20: edge.gray
21: Edges.bw, Threshold: T_Sobel (default: 0.25) 
2: Saturated Color + Edges.bw, Sat (default: 1.8)
3: Canny.bw

---------------------------------------------------------*/
global Mode = 1

global T_Sobel = 0.25 ##[0, 1.0]
global Sat = 1.8      ##[0, 5.0] 0:grayscale, 1.0: normal, >1:over-saturated 

fname = "b:\Video.mp4"
src = LSmashVideoSource(fname, prefer_hw=3)
/*-------------------------------------------------------*/


if (Mode==3){ ## Canny.bw 
	vid = src.TCannyMod(mode=0, sigma=1.0, sobel=true, t_l=60, t_h=60, chroma=3) ## 3. Canny(Y)
}
else if (Mode==1 || Mode==10){    
	vid = src.TCannyMod(mode=1, sigma=0.5, sobel=true, chroma=2) ##10. Sobel(Y) + UV
	if (Mode==1){ vid = vid.ColorYUV(off_u=5, off_v=12.8) } ##1. offset_uv tint
}
else if (Mode==20 || Mode==21){ 
	vid = src.TCannyMod(mode=1, sigma=0.5, sobel=true, chroma=3)    ##20. Sobel(Y).gray
	if (Mode==21){ vid = vid.mt_binarize(threshold=T_Sobel*255.0) } ##21. Sobel(Y).bw  
	}
else { ## (Mode==2)
	vid = src.TCannyMod(mode=1, sigma=0.5, sobel=true, chroma=3)    ##20. Sobel(Y).gray
	src = src.Tweak(sat=Sat)  
	ms = vid.mt_binarize(threshold=T_Sobel*255.0) 
	vid = src.mt_merge(ms.Invert("Y"), ms, luma=true) ##black edges
	# vid = src.mt_merge(vid.tweak(bright=-192), ms, luma=true) ##dark edges
	return vid
}
vid = vid.Invert("Y")
return vid 
