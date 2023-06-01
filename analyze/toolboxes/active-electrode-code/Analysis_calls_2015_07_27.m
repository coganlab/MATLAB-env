%% Noise test data - 71 Hz

close all
clear all
pathStr = 'C:\Users\jviventi\Dropbox';
filename = '#1_1noise_RS2V-2V_AS2V_CS-2V-1.25V_71Hz_copy.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 10; 
BncChannel = 21; %sine wave channel
save_fig = 'TRUE';

info.Note

high_pass = 1; %Hz
low_pass = 30;   % Hz

seconds_to_discard_from_start = 3;
seconds_to_discard_from_end = 3;

% Remove leak current measurement channels
temp = reshape( data, numRow , numChan , size(data,2) );
validCol = [1:4 6:14 16:numChan];
temp = temp(:,validCol,:);

numChan = numChan - 2;          % throw out two columns
numCol = numCol - 2;  % throw out two columns
BncChannel = BncChannel - 2;

data = reshape(temp,numRow * numChan, size(data,2));

% Correct for gain and filter
dataf = data ./ headstage_gain;
headstage_gain = 1;

dataf = EEGbandpass(dataf,high_pass,low_pass,Fs);
dataf = EEGbandstop(dataf, 10.5, 11.5, Fs);
dataf = EEGbandstop(dataf, 21.5, 22.5, Fs);
%dataf = EEGbandstop(dataf, 59, 61, Fs);
%dataf = EEGbandstop(dataf, 119, 121, Fs);
dataf = dataf(:,round(seconds_to_discard_from_start*Fs):end-round(seconds_to_discard_from_end*Fs));

BncChannel = 21; %sine wave channel
gain_working_threshold = 0.3;
noise_high = 200e-6;       % volts
noise_low = 0;

startSec = 10;
endSec = 5;


row = 5;
col = 5;

psd_plot(dataf, row, col, numRow, numCol, numChan, Fs, save_fig, pathStr, filename);

noise_val = calcSignal(dataf, 'NOISE', startSec, endSec, numRow, numCol, numChan, Fs, save_fig, pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high);

%% Noise test data - 568 Hz

close all
clear all
pathStr = 'C:\Users\jviventi\Dropbox';
filename = '#1_1noise_RS2V-2V_AS2V_CS-2V-1.25V_568Hz_copy.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 10; 
BncChannel = 21; %sine wave channel
save_fig = 'TRUE';

info.Note

high_pass = 1; %Hz
low_pass = 150;   % Hz

seconds_to_discard_from_start = 3;
seconds_to_discard_from_end = 3;

% Remove leak current measurement channels
temp = reshape( data, numRow , numChan , size(data,2) );
validCol = [1:4 6:14 16:numChan];
temp = temp(:,validCol,:);

numChan = numChan - 2;          % throw out two columns
numCol = numCol - 2;  % throw out two columns
BncChannel = BncChannel - 2;

data = reshape(temp,numRow * numChan, size(data,2));

% Correct for gain and filter
dataf = data ./ headstage_gain;
headstage_gain = 1;

dataf = EEGbandpass(dataf,high_pass,low_pass,Fs);
dataf = EEGbandstop(dataf, 59, 61, Fs);
dataf = EEGbandstop(dataf, 89, 91, Fs);
dataf = EEGbandstop(dataf, 119, 121, Fs);
dataf = dataf(:,round(seconds_to_discard_from_start*Fs):end-round(seconds_to_discard_from_end*Fs));

BncChannel = 21; %sine wave channel
gain_working_threshold = 0.3;
noise_high = 2000e-6;       % volts
noise_low = 0;

startSec = 110;
endSec = 5;


row = 5;
col = 5;

psd_plot(dataf, row, col, numRow, numCol, numChan, Fs, save_fig, pathStr, filename);

noise_val = calcSignal(dataf, 'NOISE', startSec, endSec, numRow, numCol, numChan, Fs, save_fig, pathStr, filename, headstage_gain, BncChannel, gain_working_threshold, noise_low, noise_high);


%% Load Cardiac Data
close all
clear all
pathStr = 'C:\Users\jviventi\Dropbox\20150725 Cardiac Rabit Test_2_568Hz_copy';
filename = '02 330ms.mat';
load(strcat(pathStr ,'\',filename));
headstage_gain = 10; 

high_pass = 1; %Hz
low_pass = 150;   % Hz

seconds_to_discard_from_start = 3;
seconds_to_discard_from_end = 3;

info.Note

data = data ./ headstage_gain;
dataf = EEGbandpass(data,high_pass,low_pass,Fs);
dataf = EEGbandstop(dataf, 59, 61, Fs);
dataf = EEGbandstop(dataf, 119, 121, Fs);

dataf = dataf(:,round(seconds_to_discard_from_start*Fs):end-round(seconds_to_discard_from_end*Fs));

% % plot filtered data
% plots(dataf, numCol, numRow, 1, numChan, Fs);  

%% Plot 

plot_start = 4; % seconds
plot_stop = 7; % seconds

lineXpos = plot_stop - plot_start + 0.2;   % position of scale bar origin in seconds
lineXsize = 0.5;  % size of horizontal scale bar in seconds
lineYpos = 1.0e-3;    % position of scale bar origin in volts
lineYsize = 2e-3;   % size of vertical scale bar in volts


% plot with scale bar, for publication
plots(dataf(:,round(Fs * plot_start):round(Fs * plot_stop)), numCol, numRow, 1, numChan, Fs, [], [], 'TRUE', lineXpos, lineXsize, lineYpos, lineYsize)

%% regular plots
plots(dataf, numCol, numRow, 1, numChan, Fs, [], [], 'FALSE', lineXpos, lineXsize, lineYpos, lineYsize)


%% Generate movie
close all
convert2Movie (dataf, strcat(pathStr ,'\',filename), plot_start, plot_stop, 0, numRow, numCol, Fs, -1e-3, 1e-3, 'TRUE');



%% PSD

 figure;
which_channel = 34;

disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);

nfft = 2^nextpow2(length(dataf(which_channel,:)));
Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);


figure;
which_channel = 47;
disp(['  Noise on channel ' num2str(which_channel) ' (fC RMS) :' num2str(std(dataf(which_channel,:)) * 1e15)     ]);


nfft = 2^nextpow2(length(dataf(which_channel,:)));
Pxx = abs(fft(dataf(which_channel,:), nfft)).^2/length(dataf(which_channel,:))/Fs;
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2), 'Fs', Fs);
plot(Hpsd);
 
