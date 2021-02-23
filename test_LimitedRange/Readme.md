## Limited Range Tests

bHighL.hlsl: out of range Luma highlighting pixel shader

ffm4b.bat: ffmpeg lossless commands (Windows bat file), incl. changing video bitstream range tag

Avisynth scripts:
* gen_ColorBarsHD.avs 
* LumaHistogram.avs (dynamic display of a video file luma histogram) 
* Luma_stats.avs: generates a .csv of per frame Luma statistics of a video file (Y: min, 0.4%Low, med, mean,	0.4%High, max, mean_diff with previous frame)
* generate ColorBarsHD test pattern with Avisynth+

ColorBarsHD:

The difference between an expanded and a non expanded limited range is most visible on White.
* avs_rec709_720p-full.png:
![](https://github.com/butterw/bShaders/blob/master/test_LimitedRange/avs_rec709_720p-full.png?raw=true)
* avs_pc.709_720p-001.png:
![](https://github.com/butterw/bShaders/blob/master/test_LimitedRange/avs_pc.709_720p-001.png?raw=true)

The output can be encoded to x264 .mp4 with ffmpeg:
ffmpeg -i gen_ColorBarsHD.avs -an -t 60 -c:v libx264 -pix_fmt yuv420p -tune stillimage -preset veryslow -crf 12 ColorBarsHD.mp4
