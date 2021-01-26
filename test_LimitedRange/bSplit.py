## bSplit.py Lossless Video Split for Avidemux GUI
# https://github.com/butterw/bShaders/tree/master/test_LimitedRange
# 
# tested in Avidemux 2.7.7dev (run with File>Project Script or add to Custom menu by copying to ./settings/custom)
# 
# Split points are on manually selected with current position, 
# and with A,B markers if they are set (to unset them use Edit > Reset Markers). Meaning you can split the loaded video in 2 to 4 parts.
# Output files will be named p1,2,3,4_filename based on the filename you provide. Any file with the same name will be overwriten. 
# To avoid overlap between sections, split point should be on keyframes and B_is_not_included_save_mode should be set to 1
# By default, Avidemux saves the frame corresponding to marker B. This is necessary for open-gop videos, but will cause 1 duplicate frame if the split sections are recombined.
B_is_not_included_save_mode = 1 # [0 or 1]
header_str = "bSplit"
adm=Avidemux(); ed=Editor(); gui=Gui()
sec = 1000*1000 #timestamps and duration are reported in us. to convert to seconds *1/sec.

if not ed.nbSegments(): gui.displayError(header_str, "No video loaded !"); return

I = ed.getCurrentPts()
A = adm.markerA
B = adm.markerB
end = ed.getVideoDuration()

splits = [I, A, B]; splits.sort()
valid_splits=[]
for elt in splits:
	if elt>0.3*sec and elt<end-0.3 and elt not in valid_splits: valid_splits.append(elt)
n = len(valid_splits)+1 
if not(n): gui.displayError(header_str, "No split point (I, A, B)>0.3s !"); return

title_str = header_str + "(I, A, B): "
title_str+= str(n) + " output files will be named pX-filename"
try:
	fname = gui.fileWriteSelect(title_str)
	if fname is None: gui.displayError(header_str, "No Output file selected !"); return
except:
	gui.displayError(header_str, "No Output file selected"); return
print(header_str, fname)

valid_splits=[0]+valid_splits+[end]
for i in range(n):
	i+=1
	adm.markerA = valid_splits[i-1]
	if i<n: adm.markerB = valid_splits[i]-B_is_not_included_save_mode
	else: adm.markerB = valid_splits[i]
	print(i, adm.markerA, adm.markerB)
	save_name = dirname(fname) +"/p"+str(i)+"_"+ basename(fname) #output will be p1_filename.ext, etc.
	adm.save(save_name)
	print(header_str + " saved:", save_name) 
adm.markerA=0; adm.markerB=end #Reset Markers
