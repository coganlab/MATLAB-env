%% Load and prepare data

close all;
clear all;

folder_str = 'C:\shared\AcuteExperiment_20120723\electrode2 - pt\done';
filename = 'test_007.mat';

% if not empty, make complete path
filename = strcat(folder_str,'/',filename);

% load the data file
disp(['Loading: ' filename]);
load(filename)

highpassF = 1;
lowpassF = 50;

% band pass filter
disp(['Bandpass filtering data from : ' num2str(highpassF) ' Hz to ' num2str(lowpassF) ' Hz']);
data(1:numRow*numCol,:) = EEGbandpass(data(1:numRow*numCol,:), highpassF,lowpassF, Fs);

bit0_chan = 33;
bit1_chan = 34;
bit2_chan = 35;
stim_channel = 36;

% combine bits into multi-level analog signal
level_data = (data(bit2_chan,:) * 4 + data(bit1_chan,:) * 2 + data(bit0_chan,:));

% move Ep trigger to last channel
trigger_data = data(stim_channel,:);
data = data(1:numCol,:);    % shrink
data = [data; level_data; trigger_data]; % recombine

numChan = size(data,1); % correct for new size

%% run averaging 

% orientation channel
x_chan = numCol + 1;
number_x_levels = 8;
invert_x = 'FALSE';

% dummy channel (used for 2-d stimuli
y_chan = x_chan; % dummy, not used for oriented stimuli
number_y_levels = 1;
invert_y = 'FALSE';

% trigger channel
ttl_chan = numCol + 2;
trigger_edge = 'RISING';
ttl_threshold = 2.5;    % volts
level_set_delay = 0.1;    % how many seconds offset from the trigger should we look for the voltage level corresponding to this orientation or location

start_sec = 1; % how many seconds into the file to start
stop_sec = 1; % how many seconds to discard from the end of the file
% numRow - number of electrode rows
% numCol - number of electrode columns
% numChan - number of analog channels
% Fs - sampling rate of the data
data_type = 'ORIENT'; % string describing the experiment

SecsPre = 0.5;  % how many seconds prior to the trigger to average
SecsPost = 2; % how many seconds after the trigger to average


[avg_eps,count,x] = vep_average(data, start_sec, stop_sec, SecsPre, SecsPost, numRow, Fs, data_type, x_chan, number_x_levels, invert_x, y_chan, number_y_levels, invert_y, ttl_chan, trigger_edge, ttl_threshold, level_set_delay);
