

close all
clear all
filename = 'I:\jviventi\2010-10-14 cat experiment\done\2010_10_14_file_29_demux.mat';
%filename = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done\test_32_demux.mat';
load(filename);

%data = data(:,round(Fs*35):end);

lowpassF = 50;
highpassF = 1;

data(1:numRow*numCol,:) = EEGbandpass(data(1:numRow*numCol,:), highpassF,lowpassF, Fs);

[eps,count,x] = multiplexed_ep(data, 1, 1, numRow, numCol, numChan, Fs, 'ORIENT', ELECTRODE);

evoked = squeeze(mean(mean(eps,1),3));

