load sample_stm_paper_data.mat
start = 1;
stop = size(data,2);
minVal = 	-100
maxVal = 	100
minAmp =	0.000
maxAmp =	0.015
q =	[1 1 1 1 1 0 1 0 0 1 1 1 1 1 1 0 0 0];
maxBPM = 	100
[g xAvg] = CreateMapAmp(data,start,stop,minVal,maxVal, q, minAmp, maxAmp, maxBPM);