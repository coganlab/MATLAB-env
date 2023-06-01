%% Load data cell - filtered 4 to 8 hz

close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_41_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 4, 8);
xAvg = mean(data(1:numCol*numRow,:),1);
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;

save_fig = 'TRUE';

%% play filtered counter-clockwise spiral movie

convert2Movie (data, filename, 270, 271, 0, numRow, numCol, Fs);

%% generate data for counter-clockwise spiral

%SpikeCorr (data, 270, 271, numRow, numCol, Fs);
startSec = 270;
stopSec = 271;
plotEn = 'TRUE';
triggerTime = [];
[corr_val, rms_map] = SpikeCorr (data, startSec, stopSec, triggerTime, numRow, numCol, Fs, plotEn);

%% generate plot

%close all

frames = [corr_val;corr_val]';
frames = corr_val';
numRowplot = 1;
numColplot = 2;
satMode = 'FRAME';
satMin = 0.02;
satMax = 0.98;
%save_fig = 'TRUE';
colorscale_label = 'Delay in ms';
aspect_corr = 'TRUE';
titleStr = ['Counter-clockwise Spiral Filtered 4-8Hz'];
normalizeMinScale = 'TRUE';
plotTitles = [];

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles);


%% play filtered clockwise spiral movie

convert2Movie (data, filename, 268.75, 269.55, 0, numRow, numCol, Fs);

%% generate data for clockwise spiral

close all

%SpikeCorr (data, 270, 271, numRow, numCol, Fs);
startSec = 268.90;
stopSec = 269.10;
%stopSec = 269.10;
%stopSec = 269.30;

frames = data(1:numRow*numCol,round(Fs*startSec):round(Fs*stopSec));

plotEn = 'TRUE';
triggerTime = [];
[corr_val, rms_map] = SpikeCorr (frames, [], [], triggerTime, numRow, numCol, Fs, plotEn);

%% generate plot

%close all

frames = corr_val';
numRowplot = 1;
numColplot = 2;
satMode = 'FRAME';
satMin = 0.02;
satMax = 0.98;
%save_fig = 'TRUE';
colorscale_label = 'Delay in ms';
aspect_corr = 'TRUE';
titleStr = ['Clockwise Spiral Filtered 4-8Hz'];
normalizeMinScale = 'TRUE';
plotTitles = [];

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles);
