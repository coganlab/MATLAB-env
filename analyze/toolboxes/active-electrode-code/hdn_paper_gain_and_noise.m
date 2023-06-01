%% Load data cell

close all
clear all
load('I:\jv_electrode_data\2010-05-19 Cat Experiment\done\test_27_demux.mat');

signal = calcSignal(data, 'SIGNAL', 1, 1, numRow, numCol, numChan, Fs);


%% load noise data unfiltered

close all
clear all
load('I:\jv_electrode_data\2010-05-19 Cat Experiment\done\test_25_demux.mat');

signal = calcSignal(data, 'NOISE', 2, 2, numRow, numCol, numChan, Fs);


%% load data filtered.

close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_27_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 50);
xAvg = mean(data(1:numCol*numRow,:),1);
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;

signal = calcSignal(data, 'SIGNAL', 1, 1, numRow, numCol, numChan, Fs);



%% Load data cell

close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_26_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 50);
xAvg = mean(data(1:numCol*numRow,:),1);
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;

signal = calcSignal(data, 'NOISE', 1, 1, numRow, numCol, numChan, Fs);

