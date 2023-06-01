


%% Sine wave test analysis - Sample #2
close all
clear all
pathStr = '\\labreadynas.poly.edu\media\Electrode Testing\2014-11-16 UIUC 224ch';
filename = 'test_006.mat';

sinewave_test(pathStr, filename);

%% Sine wave test analysis - Sample #1
close all
clear all
pathStr = '\\labreadynas.poly.edu\media\Electrode Testing\2014-11-16 UIUC 224ch';
filename = 'test_001.mat';

sinewave_test(pathStr, filename);

%% Sine wave test analysis 
close all
clear all
pathStr = 'E:\data\2014-11-24 224ch active capacitive arrays\done';
filename = 'test_007.mat';

sinewave_test(pathStr, filename);


%% Noise test analysis - Sample #1
close all
clear all
pathStr = '\\labreadynas.poly.edu\media\Electrode Testing\2014-11-16 UIUC 224ch';
filename = 'test_002.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 5;
BncChannel = 20; %sine wave channel
gain_working_threshold = 0.05;
noise_high = 2e-4; %volts
noise_low = 1e-12;

startSec =10;
endSec = 5;

temp = reshape( data, numRow , numChan , size(data,2) );
validCol = [1:3 5:12 14:numChan];
temp = temp(:,validCol,:);
numChan = numChan - 2;          % throw out two columns
numCol = numCol - 2;  % throw out two columns
temp = temp(1:2:size(temp,1),:,:);      % take every other row data
numRow = 16;
data = reshape(temp,numRow * numChan, size(data,2));


signal = calcSignal(data, 'NOISE', startSec, endSec, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high);




%% Sine wave test analysis
close all
clear all
pathStr = '\\labreadynas.poly.edu\media\Electrode Testing\2014-11-16 UIUC 224ch\Mux_v3_UIUC and EIT sine wave test';
filename = 'test_002.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 10;
BncChannel = 6; %sine wave channel
gain_working_threshold = 0.01;

startSec =10;
endSec = 5;

signal = calcSignal(data, 'SIGNAL', startSec, endSec, numRow, numCol, numChan, Fs, 'TRUE', pathStr, filename, headstage_gain, BncChannel, gain_working_threshold);
