

%% Sine test analysis - UIUC double layer sample #5
close all
clear all
pathStr = 'E:\data\2014-12-03 Capacitive Electrode with AFE0064\done';
filename = 'test_013.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 1 / ((1 / 2.8) * 130);       % convert range 0 from volts to fC
info.Note

BncChannel = 9; %sine wave channel
gain_working_threshold = 0.05;
noise_high = 3;       % fC
noise_low = 3e-5;

startSec =10;
endSec = 5;

temp = reshape( data, numRow , numChan , size(data,2) );
temp = temp(5:68,:,:);
temp = reshape(temp,2,32,numChan,size(temp,3));    % split into two duplicate rows
temp = mean(temp, 1);           %average duplicate rows
temp = squeeze(temp);
numRow = 32;
data = reshape(temp,numRow * numChan, size(data,2));

numRow = 8;
numCol = 8;

 dataf = EEGbandstop(data, 59, 61, Fs);
 %dataf = EEGbandstop(dataf, 39, 41, Fs);
% dataf = EEGbandstop(dataf, 119, 121, Fs);
 dataf = EEGbandpass(dataf,2,100,Fs);

 figure;
which_channel = 3;

disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);

nfft = 2^nextpow2(length(dataf(which_channel,:)));
Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);


figure;
which_channel = 37;
disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);


nfft = 2^nextpow2(length(dataf(which_channel,:)));
Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);
 

signal_val = calcSignal(data, 'NOISE', startSec, endSec, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high);


%% Noise test analysis - UIUC double layer sample #5
close all
%clear all
pathStr = 'E:\data\2014-12-03 Capacitive Electrode with AFE0064\done';
filename = 'test_018.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 1 / ((1 / 2.8) * 130);       % convert range 0 from volts to fC
info.Note

BncChannel = 3; %sine wave channel
gain_working_threshold = 0.05;
noise_high = 0.8;       % fC
noise_low = 3e-5;

startSec =10;
endSec = 5;

temp = reshape( data, numRow , numChan , size(data,2) );
temp = temp(5:68,:,:);
temp = reshape(temp,2,32,numChan,size(temp,3));    % split into two duplicate rows
temp = mean(temp, 1);           %average duplicate rows
temp = squeeze(temp);
numRow = 32;
data = reshape(temp,numRow * numChan, size(data,2));

numRow = 8;
numCol = 8;

dataf = EEGbandstop(data, 59, 61, Fs);
 %dataf = EEGbandstop(dataf, 39, 41, Fs);
 %dataf = EEGbandstop(dataf, 119, 121, Fs);
 dataf = EEGbandpass(dataf,2,100,Fs);

 figure;
which_channel = 3;

disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);

nfft = 2^nextpow2(length(dataf(which_channel,:)));
Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);


figure;
which_channel = 37;
disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);


nfft = 2^nextpow2(length(dataf(which_channel,:)));
Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);
 


noise_val = calcSignal(data, 'NOISE', startSec, endSec, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high);

figure;
imagesc(signal_val ./ noise_val)
colorbar