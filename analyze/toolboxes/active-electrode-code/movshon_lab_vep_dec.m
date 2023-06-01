
%% load data
close all
clear all

load('\\tneuro-think\Users\TNeuro\Desktop\Animal Experiment - 2012-12-04\done\test_050i.mat')

info.Note

if Fs == 15625
    disp('Fs == 15625, decimating by 5');
data2 = [];
for i = 1:32
data2(i,:) = decimate(data(i,:),5);
end
for i = 33:40
data2(i,:) = downsample(data(i,:),5);
end

Fs = Fs / 5;
data = data2;
end 

if Fs == 3125
    disp('Fs == 3125, decimating by 5');
data2 = [];
for i = 1:32
data2(i,:) = decimate(data(i,:),5);
end
for i = 33:40
data2(i,:) = downsample(data(i,:),5);
end
Fs = Fs / 5;
data = data2;
end

data(1:numCol*numRow,:) = EEGbandpass(data(1:numCol*numRow,:), 1, 50, Fs);



%% run averaging 

% orientation channel
x_chan = numCol + 2;
number_x_levels = 1;
invert_x = 'FALSE';

% dummy channel (used for 2-d stimuli
y_chan = x_chan; % dummy, not used for oriented stimuli
number_y_levels = 1;
invert_y = 'FALSE';

% trigger channel
ttl_chan = numCol + 1;
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
SecsPost = 1.5; % how many seconds after the trigger to average


[avg_eps,count,x] = vep_average(data, start_sec, stop_sec, SecsPre, SecsPost, numRow, Fs, data_type, x_chan, number_x_levels, invert_x, y_chan, number_y_levels, invert_y, ttl_chan, trigger_edge, ttl_threshold, level_set_delay);

squeeze(mean(avg_eps,3));