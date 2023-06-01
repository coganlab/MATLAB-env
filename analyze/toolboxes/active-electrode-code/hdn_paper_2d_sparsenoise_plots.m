%% load the data from the two files and combine

close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_37_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 50);
[eps2,count,x] = multiplexed_ep(data, 1, 1, numRow, numCol, numChan, Fs, '2DSPARSE', ELECTRODE);
save('temp.mat','eps2');

close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_35_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 50);
[eps1,count,x] = multiplexed_ep(data, 1, 1, numRow, numCol, numChan, Fs, '2DSPARSE', ELECTRODE);
load('temp.mat');
eps = cat(3,eps1,eps2);

filename = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done/test_35_37_comb_demux.mat';
[rmsVals, delay_map] = plot_sparse_noise_ep(eps, filename, numRow, numCol, Fs, 0.04, 0.16, 'TRUE', 'TRUE');

save_fig = 'TRUE';

%% replot using new tools

close all

% grab the data for this cluster
frames = reshape(rmsVals,size(rmsVals,1) * size(rmsVals,2), size(rmsVals, 3))';

% setup the plots
numRowplot = 8;
numColplot = 8;
satMode = 'FIXED';
satMin = min(frames(:));
satMax = max(frames(:));
%save_fig = 'FALSE';
colorscale_label = 'RMS Voltage';
aspect_corr = 'TRUE';
titleStr = ['2d sparse noise RMS map'];
normalizeMinScale = 'FALSE';
plotTitles = [];
ySpace = 0.01;

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);

%% replot using new tools

close all

% grab the data for this cluster
frames = reshape(delay_map,size(delay_map,1) * size(delay_map,2), size(delay_map, 3))';

% setup the plots
numRowplot = 8;
numColplot = 8;
satMode = 'FIXED';
satMin = min(frames(:));
satMax = max(frames(:));
%save_fig = 'FALSE';
colorscale_label = 'Delay in milliseconds';
aspect_corr = 'TRUE';
titleStr = ['2d sparse noise delay map'];
normalizeMinScale = 'FALSE';
plotTitles = [];
ySpace = 0.01;
color_map = colormap(jet(256));
color_map(1,:) = [1 1 1];    % replace 1st entry with black value for NaN

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace, color_map);

 %           cmap = colormap(jet(256));
%            

