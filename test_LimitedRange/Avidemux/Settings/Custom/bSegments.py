# List Segments (ref video file, duration, start time) and jump to the selected Segment.
# Segments are created by edit or append operations. Displays segments >1 and up to MaxSegments. 
# requires Avidemux>=v2.7.7
# this script can be installed to menu > custom  (copy to settings/custom) 
# https://github.com/butterw/bShaders/blob/master/test_LimitedRange
# bSegments.py v0.1

header_str = "listSegments"
MaxSegments = 10 #the max number of segments to display
adm=Avidemux(); ed=Editor(); gui=Gui() 
N = min(nSegm, MaxSegments)
sec = 1000*1000

try: splitext("test.abc") 
except: 
	gui.displayError(header_str, "Avidemux2.7.7 or later required !") 
	return
nSegm = ed.nbSegments()
if nSegm<2: print("Requires at least 2 Segments !"); return -1 #segments check!

def str3f(x):
# returns str(x rounded to 3 decimals)
# str3f(16/9): "1.778"
    out_str = str(int(x))
    if x==int(x): return out_str # ex:30
    x=abs(x)
    x=round((x-int(x))*1000)
    if x<10: pad = "00"
    elif x<100: pad = "0"
    else: pad = ""
    return out_str + "." + pad + str(x)

def strPts(pts, fmt=""):
# "00:02:31.865" or "Pts 00:02:31.865"
# fmt=0 "t: 151.865000"
    t = pts*1/sec
    if fmt==0: return "t: " + str(t)
    th = int(t/3600)
    tm = int((t-th)/60)
    ts = t-th*3600-tm*60
    ts_str = str3f(ts)
    if th<10: th_str = "0" + str(th)
    else: th_str = str(th)
    if tm<10: tm_str = "0" + str(tm)
    else: tm_str = str(tm)
    if ts<10: ts_str = "0" + ts_str
    return fmt + th_str +":"+ tm_str +":"+ ts_str

def toMinutesSeconds(pts, sep="m"):
# result is rounded, ex: "2min43" or "2m43"
	sec = 1000*1000
	seconds = pts*1/sec
	minutes = int(seconds*1/60)
	seconds = round(seconds -minutes*60)
	str0=""; if seconds<10: str0="0"
	return str(minutes) +sep+ str0+str(seconds)	

nVid = ed.nbVideos()
cPts = ed.getCurrentPts()
segments_pts = [] #segments start pts table
refVideos = []
lines = []
endI = 0 #endI: current segment end
cIdx = -1 #cIdx: the current segmentIdx
for idx in range(N):
	endP = endI #prev segment end
	dI = ed.getDurationForSegment(idx)
	refI = ed.getRefIdxForSegment(idx)
	endI+= dI
	if cIdx is -1 and cPts<endI: cIdx=idx
	if idx>0 and ed.getTimeOffsetForSegment(idx)==0: 
		kPts = ed.getNextKFramePts(endP-1)
	else: kPts=endP
	segments_pts.append(kPts)
	refVideos.append(refI)
	line = "#"+str(idx)
	if nVid>1: line+= "/v"+str(refI) 
	line+= " ("+ toMinutesSeconds(dI) +") "+ strPts(kPts)   
	lines.append(line)

## Display
title_str = header_str +": "+str(nSegm) 
if nVid>1: title_str+= "/v"+ str(nVid)
dlgWizard = DialogFactory(title_str)
label_str = "("+ str(cIdx) +") "+ strPts(cPts)
mnu = DFMenu(label_str) # "_" is discarded in the label !!!
for item in lines: mnu.addItem(item)
display_idx = min(cIdx+1, nSegm-1)
mnu.index = min(display_idx, N-1)
dlgWizard.addControl(mnu)
res = dlgWizard.show()

if res==1: adm.setCurrentPts(segments_pts[mnu.index])