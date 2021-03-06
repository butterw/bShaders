# adds filter (black) based on marker A and B positions.

adm=Avidemux(); ed=Editor(); gui=Gui() 
if not ed.nbSegments():
	gui.displayError("black_A[B", "No video loaded !")
	return
adm.addVideoFilter("black", "startBlack="+str(adm.markerA/1000), "endBlack="+str(adm.markerB/1000))
