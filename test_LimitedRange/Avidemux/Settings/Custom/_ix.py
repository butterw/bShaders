# Configurable seek (Backward) 
# requires Avidemux>=v2.7.7
# this script can be installed to GUI menu (copy to settings/custom) 
# https://github.com/butterw/bShaders/blob/master/test_LimitedRange

seek_s=120 
## 3) keyframe-seek, using a approximate time (seek_s) in seconds 

header_str = "seek_backward" ##v0.1
adm=Avidemux(); ed=Editor(); gui=Gui() 
sec = 1000*1000

nSegm = ed.nbSegments()
if not nSegm:
	gui.displayError(header_str, "No video loaded !")
	return

c = ed.getCurrentPts()
adm.setCurrentPts(c -seek_s*sec)

## 2) keyframe-seek based on fixed number of keyframes (k)
# works fine, but keyframe duration can vary a lot (from 1 frame to 10s typ and up to 20s)   
# k=-10; adm.seekKeyFrame(k) 

## 1) time based seek (seek_s) in seconds
# seek_s=60
# c = ed.getCurrentPts()
# adm.setCurrentPts(c + seek_s*sec)

## 0) seek based on fixed time (pts)
# ! if the pts time value doesn't exactly match a frame, it will seek to the previous keyframe 
# pts=30*sec; adm.setCurrentPts(pts)

#Seek to first frame: adm.setCurrentPts(0)
