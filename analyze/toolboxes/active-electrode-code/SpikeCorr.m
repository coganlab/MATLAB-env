function [corr_val, rms_map] = SpikeCorr (data, startSec, stopSec, triggerTime, numRow, numCol, Fs, plotEn)

% data - provide the data here
% startSec - (OPTIONAL) the start time of the spike, in seconds
%              * If not provided, pass [] instead - will process all data
% stopSec - (OPTIONAL) the stop time of the spike, in seconds
%              * If not provided, pass [] instead - will process all data
% triggerTime - (OPTIONAL) if startSec and stopSec are not used, you can
%               supply this value to offset the time display to the real
%               time
% numRow - number of electrode rows
% numCol - number of electrode columns
% Fs - sampling rate of the data
% plotEn - enable or disable the plots
%
% Returns:
%   corr_val - a 2d matrix of correlation derived delays, in ms
%

% Interpolate the data by this amount
interp_factor = 18;


%%% Do a correlation / delay analysis %%%%%%%%%


% pull electrode data out  (no negate, already done elsewhere)
data = data(1:numRow*numCol,:);

% if start / stop provided, grab data
if (~isempty(startSec)) && (~isempty(stopSec))
    data = data(:,floor(startSec*Fs)+1:floor(stopSec*Fs));
else
    if (~isempty(triggerTime))
        startSec = triggerTime;
        stopSec = startSec + size(data,2) / Fs;
    end
end


% create average trace
xAvg = mean(data,1);

% upsample for better delay plots
xAvg = interp(xAvg, interp_factor);

signal = zeros(size(data,1), size(data,2) * interp_factor);

% loop over all channels
corr_val = zeros(1,size(data,1));
for i = 1 : size(data,1)
    signal(i,:) = interp(data(i,:), interp_factor);
    [corr_amp(i) corr_val(i)] = max(xcov(signal(i,:),xAvg));
end

% reshape the correlation to 2d
%corr_val = reshape(corr_val,numRow, numCol);

% subtract the size of the original data to get the +/- delay
%corr_val = corr_val - size(xAvg,2);

%  subtract the minimum delay to get delays starting at 0
% corr_val = corr_val - min(corr_val(:));

% convert to ms
corr_val = (corr_val ./ (Fs * interp_factor)) * 1000;

% remove min
corr_val = corr_val - min(corr_val(:));

if strcmp(plotEn, 'TRUE')
    f1 = figure('color','white');
    
    if (exist('plotTitles', 'var') == 1) && (size(plotTitles,1) > 0)
        title(plotTitles(i,:))
    end
    imagesc(reshape(corr_val,numRow, numCol))
    axis image
    colormap(jet(256))
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    
    title(strcat('unsaturated delay in ms start   ',' ',num2str(startSec),' stop  ', ' ',num2str(stopSec)))
    colorbar
end

%imagesc(corr_val)
% use 1% and 99% val
sorted = sort(corr_val(:));

% saturate min
minVal = sorted(round(size(sorted,1) * 0.02));
%corr_val(corr_val < minVal) = minVal;

maxVal = sorted(round(size(sorted,1) * 0.98));
%corr_val(corr_val > maxVal) = maxVal;



if strcmp(plotEn, 'TRUE')
    % plot saturated data
    f1 = figure('color','white');
    imagesc(reshape(corr_val,numRow, numCol), [minVal maxVal])
    axis image
    colormap(jet(256))
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    title(strcat('2% to 98% saturated delay in ms start   ',' ',num2str(startSec),' stop  ', ' ',num2str(stopSec)))
    colorbar
end


% abs_spike_threshold = 5e-4;     % threshold to detect a spike in the average trace
%
% %spike_threshold = max(xAvg(:)) / 2;
%
% maxvals = max(signal,[],2);
% spike_threshold = repmat((maxvals ./2 ), 1, size(signal,2));
%
% spike_threshold ( spike_threshold < abs_spike_threshold) = abs_spike_threshold;
%
% ttl_data = signal > spike_threshold;    % threshold to binary
% ttl_data = diff(ttl_data,1,2);      % diff digital signal
% [y, thresh_map] = max((ttl_data == 1),[],2);
%
% % replace 0s with the minimum value if there were no zeros
% thresh_map(thresh_map == 0) = min(min(thresh_map(thresh_map ~= 0)));
% thresh_map(thresh_map == 1) = min(min(thresh_map(thresh_map ~= 1)));
% %[y thresh_map] = max(signal,[],2);
%
%
% % convert to ms
% thresh_map = (thresh_map ./ (Fs * interp_factor)) * 1000;
%
% % remove min
% thresh_map = thresh_map - min(thresh_map(:));
%
%
%
% % convert to 2d
% thresh_map = reshape(thresh_map,numRow,numCol);
%
% if strcmp(plotEn, 'TRUE')
%     figure(11);
%     imagesc(thresh_map);
%     %title(['threshold ' num2str(spike_threshold)]);
%     colorbar
% end




%%%%%%%%%%%%%%% RMS map %%%%%%%%%%%%%%%%%%%%
rms_map = std(data,0,2);
%rms_map = ;

%imagesc(corr_val)
% use 1% and 99% val
% sorted = sort(rms_map(:));
%
% % saturate min
% minVal = sorted(round(size(sorted,1) * 0.02));
% rms_map(rms_map < minVal) = minVal;
%
% maxVal = sorted(round(size(sorted,1) * 0.98));
% rms_map(rms_map > maxVal) = maxVal;

if strcmp(plotEn, 'TRUE')
    
    % plot saturated data
    f1 = figure('color','white');
    imagesc(reshape(rms_map,numRow,numCol))
    axis image
    colormap(jet(256))
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);    
    title(strcat('unsaturated RMS value start   ',' ',num2str(startSec),' stop  ', ' ',num2str(stopSec)))
    colorbar
end


% if strcmp(plotEn, 'TRUE')
%     figure(7)
%
%     % try scaling the rms_map between 0 and 1 and multiplying the delay
%     % values by that...
%
%     %    max(rms_map(:)
%
%
%     hist(rms_map(:),50)
%
%     title(strcat('rms value histogram start   ',' ',num2str(startSec),' stop  ', ' ',num2str(stopSec)))
%
% end


% try cutting off at 20% of max val
%rms_map(rms_map < (0.2 * max(rms_map(:))) ) = (0.2 * max(rms_map(:)));

% if strcmp(plotEn, 'TRUE')
%
%     % plot saturated data
%     figure(5)
%     imagesc(rms_map)
%     title(strcat('spike thresholded RMS value start   ',' ',num2str(startSec),' stop  ', ' ',num2str(stopSec)))
%     colorbar
% end

% set correlation values that don't have significant RMS values to NaN
% corr_val(rms_map == min(rms_map(:))) = NaN;
% corr_val = corr_val - min(corr_val(:));     % reset minimum delay to 0
% corr_val(isnan(corr_val)) = 0;

% if strcmp(plotEn, 'TRUE')
%     figure(6)
%     imagesc(corr_val)
%     colorbar
%     title(strcat('2% to 98% saturated delay in ms start   ',' ',num2str(startSec),' stop  ', ' ',num2str(stopSec)))
%
% end




%%%%%%%%%%%%%%

% figure(4)
% % plot the average data
% plot(xAvg)
% title(strcat('start   ',' ',num2str(startSec),' stop  ', ' ',num2str(stopSec)))
%
% figure(5)
% plot(data')
