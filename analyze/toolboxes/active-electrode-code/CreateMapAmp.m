function [g xAvg] = CreateMapAmp(data,start,stop,minVal,maxVal, q, minAmp, maxAmp, maxBPM)
 
close all;

% data - the data
% start - start index into the data (in samples)
% stop - stop index into the data (in samples)
% minVal - minimum time threshold value for the saturated images (in samples)
% maxVal - maximum time threshold value for the saturated images (in samples)
% q - array that indicates which columns to keep and which to discard
%       1 is keep, 0 discard
% minAmp - saturation value for the amplitude maps, in volts
% maxAmp - same as above
% maxBPM - maximum heart rate in beats per minute 

% generates figures as below
% Figure     Description
% 20 - Colormap of raw data - channels on y axis, time on x in samples
%     - Color is voltage
% 21  - Average of the data from all the electrodes, overlaid with peak detections
% 1 - number of columns - 1 figure for each column of data, raw data overlaid with peak detections
% 22 - plot of the delays for each electrode (x axis is channels, y axis is delay in ms)
% 23 - plot of peak amplitude for each electrode (x axis is channels, y axis is amplitude in volts)
% 24 - relative delays as an image, x axis is x dimension of the array, y is y, color is delay in ms (raw data, unsaturated)
% 25 - same as figure above but with saturated delay limits
% 26 - amplitude map, raw data - the voltage of the peaks
% 27 - skipped
% 28 - saturated amplitude map
% 31 - same as 24, but without text for publication (also includes color bar)
% 32 - same as 25, but without text for publication (also includes color bar)

% All frequency values are in Hz.
Fs = 625;  % Sampling Frequency
 
Fstop1 = 0.1;           % First Stopband Frequency
Fpass1 = 1;          % First Passband Frequency
Fpass2 = 200;         % Second Passband Frequency
Fstop2 = 300;         % Second Stopband Frequency
Astop1 = 50;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 50;          % Second Stopband Attenuation (dB)
match  = 'passband';  % Band to match exactly
 
% Construct an FDESIGN object and call its CHEBY1 method.
% h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
%     Astop2, Fs);

% Create a high pass filter
h  = fdesign.highpass(Fstop1, Fpass1, Astop1, Apass, Fs);
Hd = design(h, 'cheby1', 'MatchExactly', match);

% Get the transfer function values.
[b, a] = tf(Hd);


% The number of channels equals the size 
nChan = size(data,1);
 
% data upsampling ratio (upsamples from 625 hz to 20 * 625 Hz)
InterpFactor = 20;
 
dataf = data(:,start:stop);
g = zeros(nChan,size(dataf,2)*InterpFactor);
 
for i = 1:nChan
    dataf(i,:) = filtfilt(b,a,dataf(i,:));      % bandpass filter
    dataf(i,:) = smooth(dataf(i,:),5);          % smooth data
    %g = dataf;
    g(i,:) = interp(dataf(i,:),InterpFactor);             % interpolate up 20x
    g(i,:) = smooth(g(i,:),50);                % smooth again...
end
 
g = -g;     % invert data for sake of comparison with EEG viewer
 
g = g - repmat(mean(g,2),1,size(g,2));  % demean data
 
% normalize data
%g = g .* repmat(1 ./ (max(g,[],2) - min(g, [],2)),1,size(g,2));
 
% display data, one column at a time
g = g(1:floor(size(g,1)/16)*16,:);
 
% differentiate or not?
%g = diff(g,1,2);
 
% knock out dead columns
g = reshape(g,16,size(g,1)/16,size(g,2));
%q = [1 1 1 1 1 1 1 1 1 0 0 0 0 1 0 0 1 1];
%q = [0 1 1 1 1 1 1 1 1 1 0 0 0 1 0 0 1 1];
%q = [1 1 1 1 1 1 1 1 1 1 0 0 0 1 0 0 1 1];
%q = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%q = [1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0];
r = [];
for i = 1:size(g,2)
    if q(i)
        r = [r;reshape(g(:,i,:),16,size(g,3))];
    end
end
g = r;
 
% plot raw data
f=20;
figure(f)
imagesc(g)
 
%average
xAvg = sum(g,1) ./ size(g,1);
xAvg = smooth(xAvg,InterpFactor*15)';        % smooth the average more to remove the pacing spikes
f=f+1;
figure(f)
plot(xAvg)
 
% find peaks - assume 200 BPM max heart rate, so 0.3 seconds between beats
%maxBPM = 200;
%maxBPM = 100;
peakDistance = round(Fs * InterpFactor * (1/maxBPM)*60);
[PKS,LOCS]= findpeaks(xAvg,'minpeakdistance',peakDistance);
%[PKS,LOCS]= findpeaks(xAvg,'NPEAKS',1);
hold on;
scatter(LOCS,PKS)
 
 
 
 
% blanking  = ones(size(g));
% for i = 1:size(LOCS,2)
%     blanking(:,LOCS(i)-250:LOCS(i)+250) = 0;
% end
% blanking = logical(blanking);
% 
% xAvg(blanking(1,:)') = 0;
% g(blanking) = 0;
 
% shrunk = [];
% avgShr = [];
% for i = 1:size(LOCS,2)
%     beat = g(:,LOCS(i)-250:LOCS(i)+250);
%     avg = xAvg(:,LOCS(i)-250:LOCS(i)+250);
%     beat = beat - repmat(mean(beat,2),1,size(beat,2));  % demean data
%     avg = avg - repmat(mean(avg,2),1,size(avg,2));  % demean data
%     beat = beat .* repmat(1 ./ (max(beat,[],2) - min(beat, [],2)),1,size(beat,2));
%     avg = avg .* repmat(1 ./ (max(avg,[],2) - min(avg, [],2)),1,size(avg,2));
%     shrunk = [shrunk beat];
%     avgShr = [avgShr avg];
% end
% 
% g = shrunk;
% xAvg = avgShr;

% the number of samples to search +/- from the peaks found in the average
% trace

SearchRange = 10 * InterpFactor;
 
% check last peak to see if there is enough padding at the end
if (LOCS(end) + SearchRange) > size(g,2)
    LOCS = LOCS(1:end-1)
end
 
% check first peak to see if there is enough padding before it
if (LOCS(1) - SearchRange) < 0
    LOCS = LOCS(2:end)
end
 
 
PKS_g = zeros(size(g,1),size(LOCS,2));
LOCS_g = zeros(size(g,1),size(LOCS,2));
LOCS_norm = zeros(size(g,1),size(LOCS,2));
 
 
 
for i = 1:size(LOCS,2)  % num beats
    for j = 1:size(g,1) % num channels to search
        %[PKS_g(j,i),LOCS_g(j,i)]= findpeaks(g(j,LOCS(i)-250:LOCS(i)+250),'NPEAKS',1);
        
        % search within a narrow window around the average trace peaks for
        % the individual channel peaks
        [PKS_g(j,i),LOCS_g(j,i)]= max(g(j,LOCS(i)-SearchRange:LOCS(i)+SearchRange));
        
        % subtract the time of the average peak to get relative delay
        % subtract minimum value to center the relative delay times at 0
        % samples
        LOCS_norm(j,i) = LOCS_g(j,i) + LOCS(i)-SearchRange;
        LOCS_g(j,i) = LOCS_g(j,i) - SearchRange;
    end
end
 
% display data, one column at a time, all rows from that column
% plot the data and a scatter plot of the peak detections
g = g(1:floor(size(g,1)/16)*16,:);
for i = 1:size(g,1)/16
    figure(i)
    plot(g((i-1)*16+1:i*16,:)')
    hold on;
    for j = 1:16
        scatter(LOCS_norm((i-1)*16+j,:),PKS_g((i-1)*16+j,:))
    end
end
 
% % Correlate
% for i = 1:size(g,1)
%     z(i,:) = xcorr(g(i,:),xAvg);
% end
% 
% len = size(xAvg,2);
% 
% width = 600;
% 
% z1 = z(:,len-width:len+width);
% % if it is negative, it still might be valid data
% z1 = abs(z1);
% 
% f=f+1;
% figure(f)
% plot(z1')
   
 
% find peak
f=f+1;
figure(f)
%[a b] = max(z1,[],2);
b = sum(LOCS_g,2) ./ size(LOCS_g,2);    % calculate average peak time
plot(b);
title('Peak Time over all channels');

% find peak amplitude
f=f+1;
figure(f)
a = sum(PKS_g,2) ./ size(PKS_g,2);      % calculate average peak amplitude
plot(a);
title('Peak Amplitude over all channels');

% iso map
f=f+1;
figure(f)
iso = reshape(b,16,size(b,1)/16);
imagesc(iso)
title('Iso Peak Time Map - RAW');


f=f+1;
figure(f)
if minVal ~= 0
    iso(iso < minVal) = minVal;
end
if maxVal ~= 0;
    iso(iso > maxVal) = maxVal;
end
imagesc(iso)
title('Iso Peak Time Map - Saturated');
g = iso;        % return the time matrix

% iso amp map
f=f+1;
figure(f)
iso = reshape(a,16,size(b,1)/16);
imagesc(iso)
title('Iso Amplitude Map - RAW');

f=f+1;
figure(f)
if minAmp ~= 0
    iso(iso < minAmp) = minAmp;
end
if maxAmp ~= 0;
    iso(iso > maxAmp) = maxAmp;
end
f=f+1;
figure(f)

% generate custom color scheme
numc = 256;
colm = jet(numc);
imagesc(iso,[minAmp maxAmp]);
title('Iso Amplitude Map - Saturated')
colormap(colm);
colorbar


f = 30;


% invert the color scheme
colm = jet(numc);
colm = colm(numc:-1:1,:);
colormap(colm);

% mirror image left to right for view from pictures with active side of
% array down
g = g(:,size(g,2):-1:1);

% scale to ms
g = (g ./ InterpFactor) .* (1000 / Fs);

% smooth
smoothg = reshape(smooth(g),size(g,1),size(g,2));

% remove time offset
g = g - min(min(g));
smoothg = smoothg - min(min(smoothg));

f=f+1;
figure(f)
imagesc(g)
colormap(colm)
colorbar

f=f+1;
figure(f)
imagesc(smoothg)
colormap(colm)
colorbar



 
end
 
 


