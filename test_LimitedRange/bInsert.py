## bInsert.py Lossless Video Insertion Script for Avidemux
# https://github.com/butterw/bShaders/tree/master/test_LimitedRange
# 
# tested in Avidemux 2.7.7dev (run with File>Project Script or add to Custom menu)
# 
# Insert a video file into your file at the current position 
# If you have edited your file, save it and reload it before proceeding !
# for no re-encoding mode:
# - Insertion point must be on a Keyframe !
# - encoding parameters must match !  

adm=Avidemux(); ed=Editor(); gui=Gui()
sec = 1000*1000 #timestamps and duration are reported in us. to convert to seconds *1/sec.

nSegm = ed.nbSegments()
if nSegm!=1:
	if not nSegm: msg_str="No video loaded !"
	else: 
		msg_str="Multiple Segments detected !\n"
		msg_str="Please Save and Reload Your File"
	gui.displayError("bInsert", msg_str)
	return 

## Insert at current position I
I = ed.getCurrentPts() 
if I<0.3*sec: gui.displayError("bInsert", "Set Insertion Point I >0.3s"); return
end0 = ed.getVideoDuration()
try:
	title_str = "bInsert (I="+ str(round(I*1/sec)) +"s): Select File to Insert"
	fname_ins = gui.fileReadSelect(title_str) #None if Cancel
	if fname_ins is None: gui.displayError("bInsert", "No input file selected"); return
except:
	gui.displayError("bInsert", "No input file selected"); return
# fname_ins = "B:/Videos/ins.mp4" 
adm.seekKeyFrame(99999)
adm.markerA=0; adm.markerB=end0 #reset Markers
if not adm.appendVideo(fname_ins): raise("Cannot append " +str(fname_ins))
ff01 = ed.getNextKFramePts()
end = ed.getVideoDuration()
adm.clearSegments()
adm.addSegment(0, 0, I)
adm.addSegment(1, ff01-end0, end-end0) 
adm.addSegment(0, I, end0-I)
adm.seekKeyFrame(-1) #getting some crashes trying to preview without this ?
adm.markerA=0; adm.markerB=end #reset Markers
print("bInsert done:", I, ed.getCurrentPts(), end)
