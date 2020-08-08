/* luma_stats.avs
analyse mp4 video file: for each frame calculate Luma stats (similar to ColorYUV(analyze=true))
output: luma.csv

by butterw, tested on Avisynth+ v3.6.1 x64 
Run with: path_to\AVSMeter64.exe luma_stats.avs 

perf: 107fps on 1080p video
*/ 
fname_video = "b:\Videos\monster-1_ed.mp4" 
LSmashVideoSource(fname_video, prefer_hw=2)
fname_stats = "luma.csv"
sep = "; "
header = "frame" +sep+ "Ymin" +sep+ "Ymin(0.4)" +sep+ "Ymed" +sep+ "Yavg" +sep+ "Ymax(0.4)" +sep+ "Ymax"
WriteFileStart(fname_stats, "header", append=false)
WriteFile(fname_stats, "current_frame", "sep", "YPlaneMin", "sep", "YPlaneMin(0.4)", "sep", "YPlaneMedian", "sep", "AverageLuma", "sep", "YPlaneMax(0.4)", "sep", "YPlaneMax", flush=false, append=true)
