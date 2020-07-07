# bShaders
Effects/Filters for video playback 
This project aims at providing shaders (DirectX .hlsl files), tools and comparison screenshots for realtime video Effects. The focus is on best implementation (and tuned parameter settings) of lightweight gpu shaders.
Shaders tested on MPC-HC video player (EVR-CP) on integrated graphics.  

Effects:
- Pixelate (Mosaic)
- Sobel Edge detection (in Luma)
- Blur, multi-pass (Gaussian 9-tap, Kawase, Dual-Kawase)


Tools:
- barMask (custom borders + frame shift)
- bStrobe (time based Effect)


---
basic intro about pixel shaders and feedback here:
https://forum.videohelp.com/threads/397797-Pixel-shaders-for-video-playback-%28-hlsl%29

Mpc-hc unofficial shaders guide: https://forum.doom9.org/showthread.php?t=181584

see also my shader gists: https://gist.github.com/butterw
