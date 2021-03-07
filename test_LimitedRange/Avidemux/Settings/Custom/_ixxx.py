# Configurable seek (Forward) 
# requires Avidemux>=v2.7.7
# this script can be installed to GUI menu (copy to settings/custom) 
# https://github.com/butterw/bShaders/blob/master/test_LimitedRange

seek_s=120
## 3) keyframe-seek, using a approximate time (seek_s) in seconds 

header_str = "seek Fwd" ##v0.1
adm=Avidemux(); ed=Editor(); gui=Gui() 

nSegm = ed.nbSegments()
if not nSegm:
	gui.displayError(header_str, "No video loaded !")
	return

c = ed.getCurrentPts()
adm.setCurrentPts(c +seek_s*sec)
if c<20*sec: adm.seekKeyFrame(1)
