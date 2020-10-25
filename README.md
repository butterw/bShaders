# bShaders
Effects/Filters for video playback 
This project aims at providing shaders (DirectX .hlsl files), tools and comparison screenshots for realtime video Effects. The focus is on best implementation (and tuned parameter settings) of lightweight gpu shaders.

Shaders tested on MPC-HC video player (EVR-CP Dx9) on integrated graphics. https://www.videohelp.com/software/Media-Player-Classic-Home-Cinema
MPC-HC enables hardware-accelerated playback of local and internet videos without requiring the installation of additional codecs.


Effects:
- Pixelate (Mosaic)
- Gaussian Blur, multi-pass (Gaussian 9-tap, Kawase, Dual-Kawase, BoxBlur(3x) with adjustable size)
- Edge detection: Sobel (in Luma)

Art/Style Effect for Video content (vs Film):
- Dots
- CrossHatch

Tools:
- barMask (Custom Border Masks + frame shift)
- bStrobe (Time-based Effect)
- test_linearSampling (test whether Hardware Linear Sampling is working on gpu/driver)
- test_LimitedRange (limited range tools using Avisynth and ffmpeg)
   - bHighL.hlsl (out-of-range pixel highlighting)



See also my shader gists: https://gist.github.com/butterw
including .hook glsl-shaders for mpv: NoChroma, Frei-Chen Edge Detection (in Luma)
Mpv is an open-source cross-platform video player: https://mpv.io/installation/
 

---
basic intro about hlsl/glsl pixel shaders here:
https://forum.videohelp.com/threads/397797-Pixel-shaders-for-video-playback-%28-hlsl%29

Unofficial video player shaders guide: https://forum.doom9.org/showthread.php?t=181584
