# Configurable seek (Forward) 
# requires Avidemux>=v2.7.7
# this script can be installed to GUI menu (copy to settings/custom) 
# https://github.com/butterw/bShaders/blob/master/test_LimitedRange
#_ixxx.py v0.12

seek_s=120
## 3) keyframe-seek, using a approximate time (seek_s) in seconds 

adm=Avidemux(); ed=Editor()
sec = 1000*1000

if not ed.nbSegments(): return

c = ed.getCurrentPts()
adm.setCurrentPts(c +seek_s*sec)
if c<20*sec: adm.seekKeyFrame(1)
