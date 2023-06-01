

%% HDN paper - crosstalk test - load data 1

close all
clear all
load('G:\public\jviventi\active electrode testing 02-26-10\demux\ground_test_02_26_10_25_demux.mat')

numRow = 18;
numCol = 20;
numChan = 20;

OSR = 2;
Fs = 50000 / (numRow * OSR);


ch1 = (15-1)*numRow+3;
ch2 = (15-1)*numRow+5;

data = EEGbandpass(data(:,round(2*Fs):end-round(2*Fs)),1,50,Fs);

plot([data(ch1,:);data(ch2,:)]')


%% process


clc

% 1st tone
dataf = EEGbandpass(data(:,round(2*Fs):end-round(2*Fs)),4.5,5.5,Fs);
  
% discard edge effects
dataf = dataf(:,round(5*Fs):end-round(5*Fs));
figure(2)
t = 0:1/Fs:(size(dataf,2)-1)*1/Fs;
plot(t,[dataf(ch1,:);dataf(ch2,:)]')

rms1 = std(dataf(ch1,:))
rms2 = std(dataf(ch2,:))
ratio1 = rms1 / rms2
crosstalk1 = 20*log10(ratio1)

% 2nd tone
dataf = EEGbandpass(data(:,round(2*Fs):end-round(2*Fs)),9,10,Fs);
  
  
% discard edge effects
dataf = dataf(:,round(5*Fs):end-round(5*Fs));
figure(3)
t = 0:1/Fs:(size(dataf,2)-1)*1/Fs;
plot(t,[dataf(ch1,:);dataf(ch2,:)]')

rms1 = std(dataf(ch1,:))
rms2 = std(dataf(ch2,:))
ratio1 = rms1 / rms2
crosstalk1 = 20*log10(ratio1)


