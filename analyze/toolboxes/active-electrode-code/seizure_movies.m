

%% load data filtered.

close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_41_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 50);
xAvg = mean(data(1:numCol*numRow,:),1);
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;

%% seizure 4 movie plot

convert2Movie (data, filename, 268.10, 274.10, 0, numRow, numCol, Fs, -3e-3, 3e-3, 'TRUE');

%% seizure 3 movie plot

convert2Movie (data, filename, 87, 123, 0, numRow, numCol, Fs, -3e-3, 3e-3, 'TRUE');


%% file 40 data

tic
close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_40_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 50);
xAvg = mean(data(1:numCol*numRow,:),1);
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;
toc


%% seizure 1 movie plot

tic
convert2Movie (data, filename, 1133, 1155, 0, numRow, numCol, Fs, [], [], 'TRUE');
toc

%% seizure 2 movie plot
tic
convert2Movie (data, filename, 2500, 2550, 0, numRow, numCol, Fs, -3e-3, 3e-3, 'TRUE');
toc