

%% Sine test analysis - UIUC double layer sample #5
close all
clear all
pathStr = 'C:\Users\TNeuro\Desktop\Electrode Testing\2014-12-15 Capacitive Eletrode with Voltage Sensing';
filename = 'test_015.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 5; 
info.Note

BncChannel = 19; %sine wave channel
gain_working_threshold = 0.01;
noise_high = 3;       % fC
noise_low = 3e-5;

startSec =10;
endSec = 5;

% temp = reshape( data, numRow , numChan , size(data,2) );
% data = squeeze(mean(temp,1));
% numRow = 1;
% temp = temp(5:68,:,:);
% temp = reshape(temp,2,32,numChan,size(temp,3));    % split into two duplicate rows
% temp = mean(temp, 1);           %average duplicate rows
% temp = squeeze(temp);
% numRow = 32;
% data = reshape(temp,numRow * numChan, size(data,2));
% 
% numRow = 8;
% numCol = 8;

temp = reshape( data, numRow , numChan , size(data,2) );
validCol = [1:3 5:12 14:numChan];
temp = temp(:,validCol,:);
numChan = numChan - 2;          % throw out two columns
numCol = numCol - 2;  % throw out two columns
BncChannel = BncChannel - 2;
temp = temp(1:2:size(temp,1),:,:);      % take every other row data
numRow = 16;
data = reshape(temp,numRow * numChan, size(data,2));



% dataf = EEGbandstop(data, 59, 61, Fs);
 %dataf = EEGbandstop(dataf, 39, 41, Fs);
% dataf = EEGbandstop(dataf, 119, 121, Fs);

% figure;
% which_channel = 3;
% 
% disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);
% 
% nfft = 2^nextpow2(length(dataf(which_channel,:)));
% Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
% Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
% plot(Hpsd);
% 
% 
% figure;
% which_channel = 37;
% disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);
% 
% 
% nfft = 2^nextpow2(length(dataf(which_channel,:)));
% Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
% Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
% plot(Hpsd);
 

signal_val = calcSignal(data, 'SIGNAL', startSec, endSec, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high);


%% Noise test analysis - UIUC double layer sample #5
close all
%clear all
pathStr = 'C:\Users\TNeuro\Desktop\Electrode Testing\2014-12-15 Capacitive Eletrode with Voltage Sensing';
filename = 'test_010.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 5; 
info.Note

BncChannel = 19; %sine wave channel
gain_working_threshold = 0.1;
noise_high = 60e-5;       % volts
noise_low = 3e-6;

startSec =10;
endSec = 5;

temp = reshape( data, numRow , numChan , size(data,2) );
data = squeeze(mean(temp,1));
numRow = 1;
% 
% 
dataf = EEGbandstop(data, 59, 61, Fs);
 %dataf = EEGbandstop(dataf, 39, 41, Fs);
 %dataf = EEGbandstop(dataf, 119, 121, Fs);

 figure;
which_channel = 3;

disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);

nfft = 2^nextpow2(length(dataf(which_channel,:)));
Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);


figure;
which_channel = 7;
disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);


nfft = 2^nextpow2(length(dataf(which_channel,:)));
Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);
 


noise_val = calcSignal(data, 'NOISE', startSec, endSec, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high);

% figure;
% imagesc(signal_val ./ noise_val)
% colorbar