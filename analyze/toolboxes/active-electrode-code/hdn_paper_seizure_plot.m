


%% Load data cell

close all
clear all
load('I:\jv_electrode_data\2010-05-19 Cat Experiment\done\test_41_demux.mat');
data(1:numRow*numCol,:) = -EEGbandpass(data(1:numRow*numCol,:), 1,floor(Fs / 2), Fs);
% folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
% file  = 'test_41_demux.mat';
% [data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 138);

%% load data filtered.

close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_41_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 50);
xAvg = mean(data(1:numCol*numRow,:),1);
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;

%% Grab seizure from data and plots

% seizure is from 268 to 274 seconds
start = 268;
stop = 276;

seizure = data(1:numRow*numCol,round(Fs*start):round(Fs*stop));

foregd = std(seizure(:,round(Fs * 0.5):round(Fs * 6)),0,2);
for i = 1:size(seizure,1)
    bkgd(i) = std(detrend(seizure(i,round(Fs * 6.1):round(Fs * 6.7))),0,2);
end
snr = foregd' ./ bkgd;

[y idx] = sort(snr,'descend');  % sort by SNR
%[y idx] = sort(foregd,'descend');  % sort by RMS

disp('Top Channels')
for i = 1:numRow
      disp(strcat(num2str(i), '. Col .', num2str(ceil(idx(i) / numRow)), ' Row .', num2str(mod(idx(i), numRow))        )); 
end

lineXpos = 5.5;   % position of scale bar origin in seconds
lineXsize = 0.5;  % size of horizontal scale bar in seconds
lineYpos = 1e-3;    % position of scale bar origin in volts
lineYsize = 2e-3;   % size of vertical scale bar in volts
seizure_start = 0.1; % seconds
seizure_stop = 6.1; % seconds

plots(seizure(idx,round(Fs * seizure_start):round(Fs * seizure_stop)), numCol, numRow, 1, numChan, Fs, [], [], 'TRUE', lineXpos, lineXsize, lineYpos, lineYsize)

%% create seizure movie from data above
convert2Movie (seizure(:,round(Fs * seizure_start):round(Fs * seizure_stop)), filename, [], [], 0, numRow, numCol, Fs, -3e-3, 3e-3, 'TRUE');


%% other seizure movie plot

convert2Movie (data, filename, 87, 123, 0, numRow, numCol, Fs, -3e-3, 3e-3, 'TRUE');


%% plot just one channel


close all
whichChan = 4;
disp(strcat('Plotting channel Col .', num2str(ceil(idx(whichChan) / numRow)), ' Row .', num2str(mod(idx(whichChan), numRow)) ))

j = 1;
figure(j)
clf
screen_size = get(0, 'ScreenSize');
set(j, 'Position', [0 100 screen_size(3) 500 ] );
set(j, 'color', 'white');

plotdata = seizure(idx(whichChan),round(Fs * seizure_start):round(Fs * seizure_stop));
t = 0:1/Fs:(size(plotdata,2)-1)*1/Fs;

plotW = 4;
lineW = 6;

% plot the black background
plot(t,plotdata,'LineWidth',plotW,'Color','black')
line([lineXpos lineXpos+lineXsize], [lineYpos lineYpos], 'LineWidth',lineW, 'Color', 'black')
line([lineXpos lineXpos]          , [lineYpos lineYpos+lineYsize], 'LineWidth',lineW, 'Color', 'black')
axis off

hold on
% highlight wave 1
startC = 0.40;  % seconds
stopC = .558;  % seconds
pColor = 'blue'; 
plot(t(round(Fs * startC):round(Fs * stopC)),plotdata(round(Fs * startC):round(Fs * stopC)),'LineWidth',plotW,'Color',pColor)

% highligh wave 2
startC = 0.702;  % seconds
stopC = 1.289;  % seconds
pColor = 'green'; 
plot(t(round(Fs * startC):round(Fs * stopC)),plotdata(round(Fs * startC):round(Fs * stopC)),'LineWidth',plotW,'Color',pColor)

% highligh wave 3
startC = 1.44;  % seconds
stopC = 4.928;  % seconds
pColor = 'red'; 
plot(t(round(Fs * startC):round(Fs * stopC)),plotdata(round(Fs * startC):round(Fs * stopC)),'LineWidth',plotW,'Color',pColor)

% highligh wave 4
startC = 4.91;  % seconds
stopC = 5.159;  % seconds
pColor = 'cyan'; 
plot(t(round(Fs * startC):round(Fs * stopC)),plotdata(round(Fs * startC):round(Fs * stopC)),'LineWidth',plotW,'Color',pColor)

% highligh wave 5 - part 1
startC = 1.289;  % seconds
stopC = 1.44;  % seconds
pColor = 'magenta'; 
plot(t(round(Fs * startC):round(Fs * stopC)),plotdata(round(Fs * startC):round(Fs * stopC)),'LineWidth',plotW,'Color',pColor)

% highligh wave 5 - part 2
startC = 5.159;  % seconds
stopC = 5.56;  % seconds
pColor = 'magenta'; 
plot(t(round(Fs * startC):round(Fs * stopC)),plotdata(round(Fs * startC):round(Fs * stopC)),'LineWidth',plotW,'Color',pColor)



%% PLot in order

bgColor = 'black';
lineColor = 'yellow';
scalebarColor = 'white';

plots(seizure(idx,round(Fs * seizure_start):round(Fs * seizure_stop)), numCol, numRow, 1, numChan, Fs, -3e-3, 5e-3, 'TRUE', lineXpos, lineXsize, lineYpos, lineYsize, bgColor, lineColor, scalebarColor )

%% plot noise

bgColor = 'black';
lineColor = 'yellow';
scalebarColor = 'white';

lineXpos = 1.1;   % position of scale bar origin in seconds
lineXsize = 0.1;  % size of horizontal scale bar in seconds
lineYpos = 0e-3;    % position of scale bar origin in volts
lineYsize = 1e-4;   % size of vertical scale bar in volts
noise_start = 6.1;
noise_stop = 6.7;

plots(seizure(idx,round(Fs * noise_start):round(Fs * noise_stop)), numCol, numRow, 1, numChan, Fs, -1e-4, 1e-4, 'TRUE', lineXpos, lineXsize, lineYpos, lineYsize, bgColor, lineColor, scalebarColor )


%% calculations for SNR discussion in text
amplitude = max(seizure(idx(whichChan),round(Fs * seizure_start):round(Fs * seizure_stop))) - min(seizure(idx(whichChan),round(Fs * seizure_start):round(Fs * seizure_stop)))
noise_rms = std(detrend(seizure(idx(whichChan),round(Fs * 5.7):round(Fs * 6.7))), 0, 2)
snr_ratio = amplitude / (noise_rms * 2 * sqrt(2)) % correct for amplitude being amplitude and RMS being RMS
snr_db = 20 * log10(snr_ratio)


%% calculation of average channel noise for spike detection

avg_noise_rms = std(detrend(mean(seizure(:,ceil(Fs * 5.7):floor(Fs * 6.7)),1)))

%% check all channels for SNR ratio

amplitude = max(seizure(:,round(Fs * seizure_start):round(Fs * seizure_stop)), [] , 2) - min(seizure(:,round(Fs * seizure_start):round(Fs * seizure_stop)), [] , 2);
noise_rms = [];
for i = 1:size(seizure,1)
noise_rms(i) = std(detrend(seizure(i,round(Fs * 6):round(Fs * 7))), 0, 2);
end
snr_ratio = amplitude ./ (noise_rms' * 2 * sqrt(2)); % correct for amplitude being amplitude and RMS being RMS
snr_db = 20 * log10(snr_ratio);

%%



figure
imagesc(reshape(foregd,numRow,numCol))
colorbar

figure
imagesc(reshape(bkgd,numRow,numCol))
colorbar

figure
imagesc(reshape(foregd ./ bkgd,numRow,numCol))
colorbar   sdf

%plot(signal,'LineWidth',3,'Color',[0 0 0])

%% plot just one spike, all channels for xcov demo - load data



figure(1)
clf
screen_size = get(0, 'ScreenSize');
set(1, 'Position', [0 100 screen_size(3) 500 ] );

load('I:\jv_electrode_data\test_40_41_spikes_justin.mat');
spikeDelays = spikeDelays(1194:end,:);
rmsVals = rmsVals(1194:end,:);
spikeTimes = spikeTimes(1194:end);
spikes = spikes(1194:end,:,:);

t2 = t2 + max(t1);

% just file 41 spikes
spikeTimes = spikeTimes(431:end);
spikeDelays = spikeDelays(431:end,:);

%plot(t,xAvg,'LineWidth',4,'Color','yellow')
plot(t,xAvg)
% yMin =  -2e-3;
% yMax = 5e-3;
% xMin = 2611;
% xMax = 2617;
% %axis([2400 3190 yMin yMax])
% axis([xMin xMax yMin yMax])
% axis off
 hold on

scale = ones(size(spikeTimes)) * 5e-4;
scatter(spikeTimes,scale, 120, 'red', 'filled')

%% plots
figure(2)
clf
screen_size = get(0, 'ScreenSize');
set(2, 'Position', [0 0 screen_size(3)/2 screen_size(4) ] );

for i = 394:size(spikeTimes,2)
    

clf
start = spikeTimes(i) - .06;
stop = spikeTimes(i) + .1;

subplot(2,2,1:2)

hold on

timeV = t(ceil(Fs*start):ceil(Fs*stop)) - spikeTimes(i);
dataV = data(1:numRow*numCol,ceil(Fs*start):ceil(Fs*stop));
xAvgV = xAvg(ceil(Fs*start):ceil(Fs*stop));

% upsample and interpolate by 18x
timeV = interp(timeV,18);
xAvgV = interp(xAvgV,18);
for j = 1:size(dataV,1)
    dataN(j,:) = interp(dataV(j,:),18);
end

% color raw voltage plot by time
rescaled_data = spikeDelays(i,:) - min(spikeDelays(i,:));
rescaled_data = rescaled_data * (255 / max(rescaled_data));
rescaled_data = rescaled_data + 1;
colors = jet(256);


%plot(timeV,dataN)
for j = 1:size(dataV,1)
plot(timeV,dataN(j,:), 'Color', colors(round(rescaled_data(j)),:))
end

plot(timeV,xAvgV, 'LineWidth', 4,'Color','black')
 scatter(0,5e-4, 120, 'red', 'filled')
axis off
 
 lineXpos = 0.06;   % position of scale bar origin in seconds
lineXsize = .025;  % size of horizontal scale bar in seconds
lineYpos = 2.0e-3;    % position of scale bar origin in volts
lineYsize = 2e-3;   % size of vertical scale bar in volts


line([lineXpos lineXpos+lineXsize], [lineYpos lineYpos], 'LineWidth',6, 'Color', 'white')
line([lineXpos lineXpos]          , [lineYpos lineYpos+lineYsize], 'LineWidth',6, 'Color', 'white')
 
 
 % delay plot
subplot(2,2,3)
 imagesc(reshape(spikeDelays(i,:),numRow,numCol))
 colormap(jet(256))
 colorbar
 axis image
 set(gca,'XTick',[]);
set(gca,'YTick',[]);

% rms plot
subplot(2,2,4)
imagesc(reshape(std(dataN,0,2),numRow,numCol))
colorbar
 axis image
 set(gca,'XTick',[]);
set(gca,'YTick',[]);
 

i 
 pause
 
end
 



