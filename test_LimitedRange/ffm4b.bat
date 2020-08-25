@echo off

REM https://forum.videohelp.com/threads/398507-Top10-Commands-for-Lossless-Video-manipulation-using-ffmpeg-(Guide) by butterw
REM FFmpeg.exe must be available on the path !
echo FFmpeg Lossless Commands (ffm4b.bat) 
echo.


REM percent sign must be doubled in .bat file (vs cmd command-line ) 
REM if you double-click the .bat, output dir will be the script dir 
REM # Prompt for fname, can contain spaces
set /p fname="Please Paste/Enter full path filename: "


for %%f in ("%fname%") do (
	REM %%f full path filename, "%%~nf" filename only, "%%~xf" .extension only, "%%~dpnf" path + filename only 
	echo REM Uncomment the command line you want to run !
	echo fname: %%f
	echo.
	
	REM # Demux Audio as .m4a (input must have aac Audio for this operation to be lossless!) 
	REM ffmpeg -hide_banner -i %%f -vn -c:a copy "%%~nf.m4a"

	REM # Convert fake stereo to mono (FR, Front Right channel to f_mono.m4a) 
	REM # ffmpeg -hide_banner -i %%f -vn -af "pan=mono|FC=FR" "%%~nf_mono.m4a"

	REM # Output Video with muted Audio: filename_muted.ext
	REM ffmpeg -hide_banner -an -i %%f -c copy "%%~nf_muted%%~xf"

	REM # Convert/Remux to .mp4
	REM ffmpeg -hide_banner -i %%f -c copy "%%~nf.mp4"

	REM # Mux Video (f.mp4) and Audio (f.m4a) to f_mux.mp4
	REM ffmpeg -hide_banner -i %%f -i "%%~dpnf.m4a" -c copy -map 0:v -map 1:a "%%~nf_mux.mp4"

	REM Split a video into multiple parts based on duration (ex: 10min segments: f-000.mp4 f-001.mp4 f-002.mp4, cut on keyframes)
	REM ffmpeg -hide_banner -i %%f -c copy -segment_time 00:10:00 -f segment "%%~nf-%03d.mp4"	

	REM # Optimize mp4 for the web, moves the moov atom to the start of the file 
	REM ffmpeg -hide_banner -i %%f -c copy -movflags faststart "%%~nf_web.mp4" 
	
	REM # Clockwise 90° Rotate (Flip) a mp4 video (.mp4 metadata)[/B]
	REM # Flip Right:
	REM ffmpeg -hide_banner -i %%f -c copy -metadata:s:v:0 rotate=90  "%%~nf_r90.mp4"

	REM # Flip Left:
	REM ffmpeg -hide_banner -i %%f -c copy -metadata:s:v:0 rotate=270 "%%~nf_r270.mp4"

	REM # Set the Display Aspect Ratio to the specified value (container DAR supported in .mp4, .mkv, ...)
	REM ffmpeg -hide_banner -i %%f -aspect 4:3 -c copy "%%~nf_DAR.mp4"

	REM # Cropping without Re-encoding (in video bitstream: h264, hevc, ...) 
	REM ffmpeg -hide_banner -i %%f -c copy -bsf:v h264_metadata=crop_bottom=128:crop_top=0:crop_left=0:crop_right=0 "%%~nf_crop.mp4"
	REM ffmpeg -hide_banner -i %%f -c copy -bsf:v hevc_metadata=crop_bottom=128:crop_top=0:crop_left=0:crop_right=0 "%%~nf_crop.mp4"
	
	REM # Change color range to Full (in video bitstream: h264, hevc, ...)
	REM ffmpeg -hide_banner -i %%f -c copy -bsf:v h264_metadata=video_full_range_flag=1 "%%~nf_fullrange%%~xf"
	
			
	REM # Trim based on Duration -t OR Stop -to
	REM # if required you can specify a Start time -ss from the start OR from the end -sseof with negative time value
	REM # seconds format: 20 or 00:00:20.000
	REM # .m4a audio output example: 
	REM ffmpeg -hide_banner -i %%f -t 45 -vn -c:a copy 			"%%~nf_cut.m4a"
	REM ffmpeg -hide_banner -i %%f -ss 15 -t 30 -vn -c:a copy 	"%%~nf_cut.m4a"
	REM ffmpeg -hide_banner -i %%f -ss 00:03:43 -vn -c:a copy   "%%~nf_cut.m4a"	
	REM ffmpeg -hide_banner -i %%f -to 00:03:00 -vn -c:a copy   "%%~nf_cut.m4a"	
)

REM # Press any key to continue . . .
pause
