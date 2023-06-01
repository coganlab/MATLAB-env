

%% Sine test analysis - Mux v6
close all
clear all
%pathStr = 'C:\Users\TNeuro\Desktop\Electrode Testing\2015-08-04 Mux v6 Testing';
pathStr = 'C:\Users\TNeuro\Desktop\Electrode Testing\2015-08-07 Mux v3 Testing';
filename = 'test_015.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 20; 
disp(['Processing file: ', filename]);
disp(info.Note);

BncChannel = 5; %sine wave channel
gain_working_threshold = 0.9;
noise_high = 3;       % fC
noise_low = 3e-5;

startSec =10;
endSec = 5;


signal_val = calcSignal(data, 'SIGNAL', startSec, endSec, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high);



%% Noise test analysis - Mux v6
close all
clear all
%pathStr = 'C:\Users\TNeuro\Desktop\Electrode Testing\2015-08-04 Mux v6 Testing';
pathStr = 'C:\Users\TNeuro\Desktop\Electrode Testing\2015-08-07 Mux v3 Testing';
filename = 'test_020.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 20; 
save_fig = 'TRUE';
disp(['Processing file: ', filename]);
disp(info.Note);

BncChannel = 5; %sine wave channel
gain_working_threshold = 0.9;


high_pass = 3; %Hz
low_pass = 300;   % Hz

seconds_to_discard_from_start = 10;
seconds_to_discard_from_end = 20;

% Correct for gain and filter
dataf = data ./ headstage_gain;
headstage_gain = 1;

dataf = EEGbandpass(dataf,high_pass,low_pass,Fs);
dataf = EEGbandstop(dataf, 59, 61, Fs);
dataf = EEGbandstop(dataf, 119, 121, Fs);
dataf = EEGbandstop(dataf, 179, 181, Fs);
dataf = EEGbandstop(dataf, 239, 241, Fs);
dataf = EEGbandstop(dataf, 299, 301, Fs);
dataf = EEGbandstop(dataf, 419, 421, Fs);
dataf = dataf(:,round(seconds_to_discard_from_start*Fs):end-round(seconds_to_discard_from_end*Fs));

noise_high = 10e-6;       % volts
noise_low = 1.4e-6;

startSec = 10;
endSec = 5;


row = 8;
col = 2;

psd_plot(dataf, row, col, numRow, numCol, numChan, Fs, save_fig, pathStr, filename);

noise_val = calcSignal(dataf, 'NOISE', startSec, endSec, numRow, numCol, numChan, Fs, save_fig, pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high);


