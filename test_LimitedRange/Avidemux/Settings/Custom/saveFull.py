# Save the full video not just the selection without resetting markers
# also displays some extra info in the title of the save dialog (ex: 1min20 2/1 0a)
# duration in minutes+seconds, if more than one: nbSegments / nbVideos, the number of audio tracks 
# this script can be installed to settings/custom GUI menu
# https://github.com/butterw/bShaders/blob/master/test_LimitedRange

header_str = "saveFull" ##v0.2
adm=Avidemux(); ed=Editor(); gui=Gui() 

def fileWriteSelect(title="Please Select output file", ext=None):
	# by default uses the GUI output extension in the WriteSelect Dialog 	
	#ex: fileWriteSelect(); fileWriteSelect("Title"); fileWriteSelect(ext="mp4"); fileWriteSelect("Title", "mp4") 
	if ext is None: ext=adm.getOutputExtension()
	return gui.fileWriteSelectEx(title, ext) #Req Avidemux>=2.7.7	

def toMinutesSeconds(pts):
	# ex result: "2min43"
	sec = 1000*1000
	seconds = pts*1/sec
	minutes = int(seconds*1/60)
	seconds = round(seconds - minutes*60)
	str0=""; if seconds<10: str0="0"
	return str(minutes) +"min" +str0+str(seconds)

nSegm = ed.nbSegments()
if not nSegm:
	gui.displayError(header_str, "No video loaded !")
	return

nAudio = adm.audioTracksCount()
audio_str=""
if nAudio==0 or nAudio>1: 
	audio_str= " " + str(nAudio) +"a"
end = ed.getVideoDuration()
title = toMinutesSeconds(end) + " " 
segm_str = str(nSegm) +"/"+ str(ed.nbVideos())
if segm_str != "1/1": title+= segm_str 
title+= audio_str
title+= ": Select file to save(Full)"
 
fpath = fileWriteSelect(title)
if fpath is None: gui.displayError(header_str, "No Output file selected !"); return
# Full Save without losing Markers:
A = adm.markerA
B = adm.markerB
adm.markerA = 0
adm.markerB = end
adm.save(fpath)
adm.markerA = A
adm.markerB = B
