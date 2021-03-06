# Save the full video not just the selection without resetting markers
# also displays some extra info in the title of the save dialog
# duration in minutes, nbSegments / nbVideos, the number of audio tracks if it is not one, ex: 1m 2/1 0a
# https://github.com/butterw/bShaders/blob/master/test_LimitedRange  

header_str = "saveFull" # v0.1 #tested in Avidemux2.8

adm=Avidemux(); ed=Editor(); gui=Gui() 
sec = 1000*1000

def fileWriteSelect(title="Please Select output file", ext=None):
	# by default uses the GUI output extension in the WriteSelect Dialog 	
	#ex: fileWriteSelect(); fileWriteSelect("Title"); fileWriteSelect(ext="mp4"); fileWriteSelect("Title", "mp4") 
	if ext is None: ext=adm.getOutputExtension()
	return gui.fileWriteSelectEx(title, ext) #Req Avidemux>=2.7.7

nSegm = ed.nbSegments()
if not nSegm:
	gui.displayError(header_str, "No video loaded !")
	return
nAudio = adm.audioTracksCount()
audio_str=""
if nAudio==0 or nAudio>1: 
	audio_str= " " + str(nAudio) +"a"
end = ed.getVideoDuration()
title = str(round(end*1/sec *1/60)) +"m "
title+= str(nSegm) +"/"+ str(ed.nbVideos())
title+= audio_str
title+= ": Select file to save(FULL)"
fpath = fileWriteSelect(title)
if fpath is None: gui.displayError(header_str, "No Output file selected !"); return
A = adm.markerA
B = adm.markerB
adm.markerA = 0
adm.markerB = end
adm.save(fpath)
adm.markerA = A
adm.markerB = B





	
