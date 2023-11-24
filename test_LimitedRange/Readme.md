## Limited Range Tests

- bHighL.hlsl: out of range Luma highlighting pixel shader
- ffm4b.bat: ffmpeg lossless commands (Windows bat file), incl. changing video bitstream range tag
- convert a test image to video with correct colors with ffmpeg

Avisynth scripts:
* gen_ColorBarsHD.avs 
* LumaHistogram.avs (dynamic display of a video file luma histogram) 
* Luma_stats.avs: generates a .csv of per frame Luma statistics of a video file (Y: min, 0.4%Low, med, mean,	0.4%High, max, mean_diff with previous frame)
* generate ColorBarsHD test pattern with Avisynth+

#### ColorBarsHD:
The difference between an expanded and a non expanded limited range is most visible on White.
* avs_rec709_720p-full.png:
![](https://github.com/butterw/bShaders/blob/master/test_LimitedRange/avs_rec709_720p-full.png?raw=true)
* avs_pc.709_720p-001.png:
![](https://github.com/butterw/bShaders/blob/master/test_LimitedRange/avs_pc.709_720p-001.png?raw=true)

The output can be encoded to x264 .mp4 with ffmpeg:
```
ffmpeg -i gen_ColorBarsHD.avs -an -t 60 -c:v libx264 -pix_fmt yuv420p -tune stillimage -preset veryslow -crf 12 ColorBarsHD.mp4
```

#### Convert a color card image to video with correct colors, ex: to test response of video player shaders or lut:
![](https://github.com/butterw/bShaders/blob/master/test_LimitedRange/graycard9_0-32-64-96-128-159-191-223-255.bmp?raw=true)
```
ffmpeg -loop 1 -framerate 1 -i graycard9_0-32-64-96-128-159-191-223-255.bmp -c:v libx264 -t 15 -r 30 -pix_fmt yuv420p -tune stillimage graycard9_1392x336p30-15s_0-32-64-96-128-159-191-223-255.mp4
```
- Crop the input image to get mod-4 or better resolution. Save as lossless format. 
- Generate mp4 output video compressed with x264, the specified framerate is 30fps and the duration is 15s. 
- You can check colors on screen using freeware color picker software (ex: Just Color Picker on Windows). When displayed in video player, color error will be at most a single RGB8 level.
