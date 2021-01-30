## dirLoad.py script for Avidemux: open all files with the selected extension in a folder   
# https://github.com/butterw/bShaders/tree/master/test_LimitedRange 
# 
# tested in Avidemux 2.7.7dev (run with File>Project Script or add to Custom menu)

ext="mp4"

adm=Avidemux(); ed=Editor(); gui=Gui()
header_str = "dirLoad"
nSegm = ed.nbSegments()
if nSegm>0: gui.displayError(header_str, "Please Close Open File!"); return

inputFolder = gui.dirSelect(header_str + "(" +ext+ "): Select folder")
flist = get_folder_content(inputFolder, ext)
if len(flist): 
	print(header_str, len(flist), ext)
	adm.loadVideo(flist[0])
	for fname in flist[1:]:   
		if not adm.appendVideo(fname): raise("! Cannot append " +str(fname))
	print(header_str + " done, Segments:", ed.nbSegments(), ed.getVideoDuration()) 
	
