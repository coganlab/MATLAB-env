
%% load the data

close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_41_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 50);
xAvg = mean(data(1:numCol*numRow,:),1);
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;

save_fig = 'TRUE';

%% Figure 4b, WAve I - start of seizure

close all

start = 268.5;
stop = 269;

seizure = data(1:numRow*numCol,round(Fs*start):round(Fs*stop));

frame_start = 12;
frame_step = 3;
frame_stop = 33;
frames = seizure(:,frame_start:frame_step:frame_stop);
numRowplot = 5;
numColplot = 8;
satMode = 'FRAME';
satMin = 0.01;
satMax = 0.99;
%save_fig = 'TRUE';
colorscale_label = 'Volts';
aspect_corr = 'TRUE';
frame_interval = (frame_step / Fs) * 1000;
titleStr = ['Figure 4b - WAve I - start of seizure ' num2str(frame_interval) ' ms frame saturated'];

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename);

satMode = 'FIXED';
satMin = -3e-3;
satMax = 3e-3;
titleStr = ['igure 4b - WAve I - start of seizure ' num2str(frame_interval) ' ms fixed colorscale'];

M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename);

%% Spiral Wave - Counter Clockwise

close all

start = 270;
stop = 271;

seizure = data(1:numRow*numCol,round(Fs*start):round(Fs*stop));

frame_start = 1;
frame_step = 7;
frame_stop = 50;
frames = seizure(:,frame_start:frame_step:frame_stop);
numRowplot = 5;
numColplot = 8;
satMode = 'FRAME';
satMin = 0.01;
satMax = 0.99;
%save_fig = 'TRUE';
colorscale_label = 'Volts';
aspect_corr = 'TRUE';
frame_interval = (frame_step / Fs) * 1000;
titleStr = ['Spiral Wave - Counter Clockwise ' num2str(frame_interval) ' ms frame saturated'];

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename);

satMode = 'FIXED';
satMin = -3e-3;
satMax = 3e-3;
titleStr = ['Spiral Wave - Counter Clockwise ' num2str(frame_interval) ' ms fixed colorscale'];

M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename);

%% Spiral Wave - Clockwise

close all

start = 268;
stop = 274;

seizure = data(1:numRow*numCol,round(Fs*start):round(Fs*stop));

frame_start = 337;
frame_step = 4;
frame_stop = frame_start + 28;
frames = seizure(:,frame_start:frame_step:frame_stop);
numRowplot = 5;
numColplot = 8;
satMode = 'FRAME';
satMin = 0.01;
satMax = 0.99;
%save_fig = 'FALSE';
colorscale_label = 'Volts';
aspect_corr = 'TRUE';
frame_interval = (frame_step / Fs) * 1000;
titleStr = ['Spiral Wave - Clockwise ' num2str(frame_interval) ' ms frame saturated'];

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename);

satMode = 'FIXED';
satMin = -3e-3;
satMax = 3e-3;
titleStr = ['Spiral Wave - Clockwise ' num2str(frame_interval) ' ms fixed colorscale'];

M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename);


