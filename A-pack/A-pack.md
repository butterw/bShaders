## [A-Pack] Video Adjustments shaders Pack. 
Lightweight shaders for quick Adjustments of (web) video: brightness/contrast curves (tooDark, tooBright, bShadows, levels) and color adjustments (vibrance, dSat, Black&White, etc.) available for dx9 hlsl, dx11 hlsl and mpv glsl.hook.
Open-source: https://github.com/butterw/bShaders/tree/master/A-pack
v1.40 (2023/08): initial release by butterw.
v1.50 (2023/11): +sCurve contrast adjustment shader 


Shader Adjustments to quickly improve the video being viewed.

Why Shaders ?
- Shaders run directly on the integrated graphics (or discrete video card) and can process video pictures very fast. 
- Player integration. Shaders can be toggled On/Off from within the video player.

Why are the adjustments necessary ? 
- Input video may not have great capture/processing. This is particularly true for home and web videos.
- Display and display settings. Monitor may not be calibrated for color accuracy.
- Lighting conditions. They typically change during the day/night cycle and they significantly alter the viewing experience.
- Viewer preference, individual taste.

Simple to use Adjustments
- These shaders are not meant for permanent use. The adjustments should be applied selectively when a video requires it (via menu or keyboard shortcut). 
- A key benefit of shaders is that they can easily be turned ON or OFF. Once turned OFF, there are no hidden settings that could degrade your normal viewing experience.
- Shaders are applied directly to the video picture in the player.
- Lightweight gpu pixel shaders with a focus on performance.
- To install, simply copy the shader files to your players shader folder. To uninstall, delete the shader files from your players shader folder.
- Simple code allows for easy modification if required (ex: change parameter values, combine multiple shaders into one). Just edit the shader file with a text editor. 
- Tested on intel integrated graphics (intel hd graphics, intel uhd 730) on Win10. 

Use cases:
- The video is too dark
- The video is too bright
- The darks are not dark enough
- The video lacks contrast
- The colors are weak
- The colors are over-saturated
- I want to watch this video in black&white, with a color filter, etc.

----
[B]## Video Player and Renderer software[/B]

These shaders can be used in any software with user rgb pixel shader integration:
hlsl shaders are supported by Windows players such as mpc-hc, mpc-be, etc.
with the default renderer EVR-Custom Presenter and some other renderers such as mpc video renderer. 
- evr-cp (dx9,  /Shaders) 
- mpc-vr dx11 ( /Shaders11, post-resize only)

Glsl .hook shaders are used by the cross-platform player mpv (and video players built on top of it), 
with the renderers vo=gpu or the new libplacebo-based vo=gpu-next.

evr-cp is the default renderer in mpc-hc and mpc-be (dx9).
- It supports pre- and post-resize user shaders. There is typically no difference in the output unless the video is resized. 
- Adjustment shaders are typically used pre-resize, because there are less pixels to process when upscaling (ex: 720p video displayed fullscreen on a 1080p screen). 
- ! Post-resize shaders are applied to the black bars.

mpc-vr (requires an additional download/install)
- Only supports post-resize user shaders. They are not applied to the black bars.
- In the mpc-be and mpc-hc players, mpc-vr dx11 requires dx11 shaders.

MPC-HC 
- You can use shader presets to be able to switch between shaders rapidly (via right Click Menu > Shaders).
- Shader presets can also be set via command line (or a shortcut): mpc-hc.exe /shaderpreset "Blur" "video1.mp4"

MPC-BE
- Mpc-be v1.6.8 or later is recommended for mpc-vr dx11 on Win10: the shader selector now defaults to the Shaders11 folder.
- Shader changes via the shader selector are applied when the video is playing. In paused mode, you need to disable/enable shaders for the new shaders to be applied (tested with mpc-vr).
- Mpc-be doesn't have support for shader presets.

MPC-HC, MPC-BE
- require the .hlsl extension for shaders. Other players may use a .txt extension instead.
- shader folders: 
for dx9 shaders:  /Shaders  
for dx11 shaders: /Shaders11.  
Other players may use folders with different names.
Potplayer and KMPlayer use dx9 shaders.

MPV 
- vo=gpu-next is the new libplacebo-based renderer for mpv.
- Shaders which require new features only available in vo_gpu-next are typically postfixed with _next.
- There is no required extension for mpv glsl shaders, I typically use .hk as it is shorter than .hook.glsl.
- There is no default shader folder, shaders could be placed directly in the player folder or a subfolder (ex: /s). You will need to specify a relative path to the shaders to use them so it may be best to keep it short/simple.
- mpv needs to be configured (via input.conf) to be able to toggle shaders on/off via hotkey. Shaders can be toggled individually.

To try out this shader pack, you can use a standalone video player with portable config (.zip download rather than .exe installer):   
- Mpc-hc/be saves its configuration in Windows Registry by default, but an .ini file in the player folder can override this: For this you must put the player files in a folder where your windows user account has write access without admin elevation. So typically not in a protected Windows folders such as C:\Program Files.
- Mpv: inside the player folder create a subfolder named portable_config where you should put your mpv.conf and input.conf configuration files. These files don't exist by default, so you may need to create them.

[B]How to check whether the shaders are working ?[/B]
- Try the bw (black&white) shader on a color video.
- For adjustment shaders it may not be so obvious, as only small tweaks are typically required. First pause the video, then try toggling shaders On/Off to see the difference. 
- in mpv, the output screen is blue if there is a compilation error (likely caused by a syntax error) with an active shader.
- in mpc-hc, you can use `Menu > Shaders > Debug Shaders... > then select the desired shader` too see if the shader compiled (if not a compilation error will be reported). Shaders which failed to compile aren't loaded.

[B]mpc-hc shader presets [/B]
To get the Shaders menu featured in the A-pack screenshot, copy the following [Shaders\Presets] text block to your mpc .ini configuration file:
[Shaders\Presets]
0=A-Pack
1=bw
2=dSat
3=exposure
4=shadows
5=tooBright
6=tooDark
7=vibrance
8=x10-240
PostResize0=
PostResize1=
PostResize2=
PostResize3=
PostResize4=
PostResize5=
PostResize6=
PostResize7=
PostResize8=
PreResize0=
PreResize1=.\bw.hlsl
PreResize2=.\dSat.hlsl
PreResize3=.\exposure.08.hlsl
PreResize4=.\bShadows-08.hlsl
PreResize5=.\tooBright.hlsl
PreResize6=.\tooDark.24.hlsl
PreResize7=.\vibrance.35.hlsl
PreResize8=.\expand10_240.hlsl

[B]Shader Cache dir[/B]
- To improve startup performance, recent mpv builds (july 2023) enable caching of compiled shaders to disk by default (ex: portable_config\cache). With vo-gpu a unique cache file called libplacebo.cache is created. 
A custom path for the directory (! write access is required) can be set in mpv.conf with: --gpu-shader-cache-dir=/shader-cache-dir or --gpu-shader-cache-dir=C:\Temp
- mpc-be and mpc-vr do not cache compiled shaders to disk.
- mpc-hc with evr-cp. Options (O) > Playback > Output > EVR-CP settings: x Cache compiled shaders. 
In portable mode a shadercache subfolder will be created containing the persistent .cso files. The corresponding .ini setting is CacheShaders=1.
