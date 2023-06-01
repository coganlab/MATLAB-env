


%% Load data cell

close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_32_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 50);
xAvg = mean(data(1:numCol*numRow,:),1);
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;


%% Grab spindle from data

% file 32  - spindle #1
start = 77.25;
stop = 82;

% file 32  - spindle #2
%start = 17;
%stop = 23;

% file 32  - spindle #3
%start = 4;
%stop = 7;

% start = 76.3;
% stop = 83;

% file 37
% start = 20;
% stop = 40;

all_data = data(:,round(Fs*start):round(Fs*stop));
spindle = data(1:numRow*numCol,round(Fs*start):round(Fs*stop));

%plots(spindle, numCol, numRow, 1, numChan, Fs)

% plot_start = 1; % seconds
% plot_stop = 6; % seconds


foregd = std(spindle,0,2);


%% make plots of spindle, sorted by rms power during the spindle period

[y idx] = sort(foregd,'descend');

lineXpos = stop - start + .2;   % position of scale bar origin in seconds
lineXsize = 0.5;  % size of horizontal scale bar in seconds
lineYpos = -2.5e-4;    % position of scale bar origin in volts
lineYsize = 5e-4;   % size of vertical scale bar in volts

disp('Top Channels')
for i = 1:numRow
      disp(strcat('Col ', num2str(ceil(idx(i) / numRow)), ' Row ', num2str(mod(idx(i), numRow))        )); 
end


%plots(spindle, numCol, numRow, 1, numChan, Fs)
%plots(spindle, numCol, numRow, 8, numChan, Fs, [], [], 'TRUE', lineXpos, lineXsize, lineYpos, lineYsize)
plots(spindle(idx,:), numCol, numRow, 1, numChan, Fs, [], [], 'TRUE', lineXpos, lineXsize, lineYpos, lineYsize)


%% generate peaks

whichChan = 1;      % Which spindle channel to use for the peak detection

[pks,locs] = findpeaks(spindle(idx(whichChan),:), 'MINPEAKHEIGHT', 2e-4);

pre = 0.030;
post = 0.030;


for i = 1:size(locs,2)
    
    % time is locs / Fs - 1/ Fs
    
    peakTime = locs(i) / Fs - 1/ Fs;

%     grab = spindle(:,floor((peakTime - pre)*Fs)+1:floor((peakTime + post)*Fs));
%     
%     plot(grab');
%     
    [corr_val, rms_map] = SpikeCorr (spindle, peakTime - pre, peakTime + post, peakTime, numRow, numCol, Fs, 'FALSE');

j = 1;
figure(j)
clf
set(j, 'color', 'white');
t = 0:1/Fs:(size(spindle,2)-1)*1/Fs;
plot(t,spindle(idx(whichChan),:))
hold on
scatter(locs(i) / Fs - 1/Fs ,pks(i), 'r')    
    
% image map
j = 2;
figure(j)
clf
set(j, 'color', 'white');
sorted = sort(rms_map(:));
minVal = sorted(round(size(sorted,1) * 0.01));
maxVal = sorted(round(size(sorted,1) * 0.99));
imagesc(reshape(rms_map,numRow,numCol), [minVal maxVal] )

%imagesc(reshape(foregd,numRow,numCol))
colormap(jet(256))
colorbar
axis image
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    
% cut off low power channels
j = 3;
figure(j)
clf
set(j, 'color', 'white');
thresh = 0.65;
below_thresh = rms_map < (maxVal * thresh);
above_thresh = rms_map >= (maxVal * thresh);

rms_map(below_thresh) = minVal;
imagesc(reshape(rms_map,numRow,numCol), [minVal maxVal] )

%imagesc(reshape(foregd,numRow,numCol))
color_map = colormap(jet(256));
color_map(1,:) = [1 1 1];    % replace 1st entry with white value for NaN
colormap(color_map)
colorbar
axis image
set(gca,'XTick',[]);
set(gca,'YTick',[]);
    

% correlation value
j = 4;
figure(j)
clf
set(j, 'color', 'white');

sorted = sort(corr_val(above_thresh));
minValDelay = sorted(ceil(size(sorted,2) * 0.02));
maxValDelay = sorted(floor(size(sorted,2) * 0.98));

corr_val(below_thresh) = minValDelay;

corr_val(corr_val < minValDelay) = minValDelay;
corr_val(corr_val > maxValDelay) = maxValDelay;


corr_val = corr_val - minValDelay;

disp(minValDelay)
disp(maxValDelay)

imagesc(reshape(corr_val,numRow,numCol))
%imagesc(reshape(foregd,numRow,numCol))

color_map = colormap(jet(256));
color_map(1,:) = [1 1 1];    % replace 1st entry with white value for NaN
colormap(color_map)
colorbar
axis image
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);


    
j = 5;
figure(j)
clf

spike = spindle(above_thresh,floor((peakTime - pre)*Fs)+1:floor((peakTime + post)*Fs));
plot(spike')
    

    pause
  

    
    
end



%% fft plot

xAvg = mean(data(1:numCol*numRow,:),1);


L = size(xAvg,2);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(xAvg,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')




%%

figure
imagesc(reshape(foregd,numRow,numCol))
colorbar

%plot(signal,'LineWidth',3,'Color',[0 0 0])