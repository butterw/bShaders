/* --- Configuration ---*/
fname = "b:\Videos\monster-1_ed.mp4" ## Set the source filename 
doAudio = true ## [true, false] currently used only for mp4 video
threads = 2 ## Number of threads to use by Prefetch. 0: deactivates Multi-threading 
igpu = 2 ## 3: gpu hw accelerated video decoding (2: intel igpu)
cachedLibav = true #false 
## true: LWLibav will create a filename.lwi cache file for each file opened, in video dir (filesize 30-50MB for an encoded movie)
## false: fixed cache file that gets overwritten for each new file (you can specify the path with cachefile parameter). 

/* LumaHistogram.avs 

by butterw v0.1
thanks to Videohelp members for their assistance: https://forum.videohelp.com/threads/398319-play-video-with-histogram-display-avisynth#post2591212 

tested on Avisynth+ x64 v3.6.1
	- requires LSMASHSource.dll x64 plugin 
.avs can be opened by mpc-hc/be video player.

default Input: standard mp4 video file (x264 8bit, yuv420)
	- loaded with LSMASHVideoSource / LSMASHAudioSource (mp4/mov splitter-decoder based on libavcodec)
	- also possible: a 8bit mkv clip, a 10bit mkv (by converting to 8bit), an image (png or jpg)  

Output: Input + LumaHistogram (from histogram("levels")
	- Luma levels out of limited range are highlighted
	- position of the Histogram is set based on the input AR 

Please Note: this is the histogram of the source video file, not the histogram of the video as played (PC video players typically expand range).
A player with a built-in histogram function is the way to go to visualize the histogram of the video as played.
The goal here was to analyse the luma ranges encountered in video files, and evaluate the processing done in the player (this script can also process screenshots).

If required Pixel Shaders can be applied on the avs output in the video player: bHighL.hlsl Highlights pixels outside of defined Luma Range (in solid colors).


After some testing in 16/9 fullscreen (1920x1080) the following positions for LumaHistogram work best:
- on the side for Aspect Ratio<=4/3
- at the bottom or top for AR=>1.85
- for 16/9, overlay on a corner of the video (or you could use CropBottom on the video).

- Limitations: 
- Avisynth+ overhead: as expected, cpu usage is higher than if you were just playing the video. 
- non-mp4 files with LWLibavVideoSource: Initial caching time of more than 10 seconds (with SSD) for 3GB mkv.
	- Takes longer if you load audio. Subsequently the file can be loaded in a few seconds if the cachefile exists.		
	- To avoid this, you can install and configure DSS2 instead (works better than DirectShowSource, but only handles video). 
		- System-wide install of DShow filter (LAVfilters) is required + set gpu hw acceleration in lav video decoder.
*/

LoadPlugin("c:\Program Files (x86)\AviSynth+\plugins64+\LSMASHSource.dll")
## set MT mode for dll plugins:
SetFilterMTMode("LSMASHVideoSource",   MT_SERIALIZED)
SetFilterMTMode("LSMASHAudioSource",   MT_SERIALIZED)
SetFilterMTMode("LWLibavVideoSource",  MT_SERIALIZED)
SetFilterMTMode("LWLibavAudioSource",  MT_SERIALIZED)
SetFilterMTMode("DSS2",                MT_SERIALIZED) ## DSS2mod avss_x64.dll  v2.0.0.13 (2014/11/10)

function LumaHistogram(clip v){ ## the Luma histogram is displayed on the right by default and has dimensions (256, 64).
    Histogram(v, "levels", keepsource=false)  
    Crop(0, 0, 256, 64)	## get rid of U/V histograms
}

function sideHistogram(clip v, clip h){ ## ## for AR<1.5 ex 4./3
	AddBorders(h, 0, 0, 0, v.height-64) 
	StackHorizontal(v, last)
}	

function bottomHistogram(clip v, clip h){ ## for AR >=1.85
    AddBorders(h, 0, 0, v.width-256, 0)
    StackVertical(v, last)
}	

function topHistogram(clip v, clip h){ 
    AddBorders(h, 0, 0, v.width-256, 0)
    StackVertical(last, v)
}	

function loadAudio(clip v, string fname){
	audio = LSMASHAudioSource(fname)
	AudioDub(v, audio)
}

isMp4 = FindStr(fname,".mp4")>0  

/* --- Input, ex: mp4+audio/mkv/jpg-png --- */
vid = isMp4 ? LSmashVideoSource(fname, prefer_hw=igpu): \
	  (FindStr(fname,".png")>0 || FindStr(fname,".jpg")>0) ? ImageSource(fname, end=20, fps=2).ConvertToYV12(matrix="pc.709"): \ 	
	  (FindStr(fname,"10bit")>0) ? LWLibavVideoSource(fname, prefer_hw=igpu, cache=cachedLibav, format="YUV420P10").ConvertBits(8, dither=0): \
LWLibavVideoSource(fname, prefer_hw=igpu, cache=cachedLibav)
# return vid

/* --- Manual Input, ex: mkv with audio, mkv video without indexing with DSS2 --- */
# vid = LSmashVideoSource(fname, prefer_hw=igpu) ## for mp4/mov video only !
# vid = DSS2(fname, pixel_type="YV12") ## doesn't require initial indexing, but video only and Req LavFilters system install !!!
# vid = LWLibavVideoSource(fname, cache=cachedLibav, prefer_hw=igpu)## requires initial indexing !!! cachefile="c:\Temp\temp.lwi"
# aud = LWLibavAudioSource(fname, cache=cachedLibav) #return aud
# vid = AudioDub(vid, aud)
# Prefetch(vid, threads) return vid


# vid = TurnRight(vid).Histogram().TurnLeft() ## top Waveform Monitor
vid = (isMp4 && doAudio) ? vid.loadAudio(fname): vid 

h = LumaHistogram(vid) # return h
# vid = vid.ColorYUV(analyze=true) ##Stats overlay (Min/Max/Avg, Loose(0.4%) Min/Max, quite cpu intensive with 1080p input

AR = vid.width/float(vid.height) ##Aspect Ratio

vid = (AR <= 1.4) ? sideHistogram(vid, h): \
(AR >= 1.85) ? bottomHistogram(vid, h): \
vid.overlay(h, opacity=0.7, use444 = false, x=vid.width-256, y=vid.height-64) ##bottom right corner overlay 
## vid = vid.overlay(h, opacity=0.7, use444 = false) ##top right corner overlay


/* --- Convert Output to RGB  --- Bypass the YUV-to-RGB conversion done by the video player, typ. with range expansion */ 
## vid = ConvertToRGB(vid, matrix="pc.709") ## without range expansion
## vid = ConvertToRGB(vid, matrix="rec709") ## expands range

/* --- debug OSD --- */ # blankclip().KillAudio
# vid  = vid.subtitle(fname, align=7)
# vid  = vid.subtitle(String(AR), align=5)
# vid = vid.subtitle(String(vid.Pixeltype), align=9)


## Enable multithreading. 
Prefetch(vid, threads) ##must be placed before return to be taken into account 
return vid
