

%% Load data cell - filtered

close all
clear all
folder_str = 'I:\jv_electrode_data\2010-05-19 Cat Experiment\done';
file  = 'test_32_demux.mat';
[data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, file, 1, 50);
xAvg = mean(data(1:numCol*numRow,:),1);
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;

% Grab eps
[eps,count,x] = multiplexed_ep(data, 1, 1, numRow, numCol, numChan, Fs, 'ORIENT', ELECTRODE);

%% Plot raw VEPs for Supplemental material



close all

screen_size = get(0, 'ScreenSize');
disp(['screen size ' num2str(screen_size)]);
a = squeeze(eps(:,:,:,1:numRow*numCol,:));


a = reshape(a,size(a,1)*size(a,2),size(a,3),size(a,4));

%plots(a, numCol, numRow, 1, numChan, Fs)

lineXpos = 2.1;   % position of scale bar origin in seconds
lineXsize = 0.2;  % size of horizontal scale bar in seconds
lineYpos = -2.5e-4;    % position of scale bar origin in volts
lineYsize = 5e-4;   % size of vertical scale bar in volts

%a = squeeze(eps(1,1,1,:,:));
%a = squeeze(mean(a,1));
%plots(spindle, numCol, numRow, 1, numChan, Fs)
%plots(a(:,round(Fs * 2.5):round(Fs * 4.5)), numCol, numRow, 1, numChan, Fs, [], [], 'TRUE', lineXpos, lineXsize, lineYpos, lineYsize)
%plots(a, numCol, numRow, 1, numChan, Fs, [], [], 'FALSE', lineXpos, lineXsize, lineYpos, lineYsize)


resp_start = 3.04;
resp_stop = 3.16;
bkgd_start = 2.0;
bkgd_stop = 2.70;

[sorted idx] = sort(mean(std(a(:,:,round(Fs * resp_start):round(Fs * resp_stop)),0,3),2),'descend');

% % plot all the VEPs to find one... 
% figure
% for i = 1:size(a,1)
%     resp = std(a(idx(i),:,round(Fs * resp_start):round(Fs * resp_stop)),0,3);    
%       
%     
%     sorted = sort(resp(:));
%         minVal = sorted(round(size(sorted,1) * 0.02));
%         maxVal = sorted(round(size(sorted,1) * 0.98));
% subplot(10,8,i)
% imagesc(reshape(resp,numRow,numCol), [minVal maxVal])
% axis image
% axis off
% axis tight
% %title(num2str(i))
% end

% grab one of the VEPs and plot
which = 5;
toplot = squeeze(a(idx(which),:,:));
resp = std(toplot(:,round(Fs * resp_start):round(Fs * resp_stop)),0,2);
sorted = sort(resp(:));
minVal = sorted(round(size(sorted,1) * 0.02));
maxVal = sorted(round(size(sorted,1) * 0.98));
j = 1;
figure(j)
set(j, 'color', 'white');
imagesc(reshape(resp,numRow,numCol), [minVal maxVal])
colormap(jet(256))
set(gca,'XTick',[]);
set(gca,'YTick',[]);
axis image
colorbar


% reshape to 2d
toplot = reshape(toplot,numRow,numCol,size(toplot,2));

plot_start = 2.85;
plot_stop = 3.65;

t = 0:1/Fs:(size(toplot(1,1,round(Fs * plot_start):round(Fs * plot_stop)),3)-1)*1/Fs;
t = t + plot_start - 3;

numPlots = 49;
j = 2;
figure(2)
set(j, 'color', 'white');
set(j, 'Position', [0 0 screen_size(3) screen_size(4) ] );
where = 1;
for row = 12:18
    for col = 1:7
        subplot(7,7,where)
        plot(t,squeeze(toplot(row,col,round(Fs * plot_start):round(Fs * plot_stop))),'LineWidth',2)
        
        axis tight
        axis off
        ylim([-1.2e-3 0.5e-3])
        where = where + 1;
        %pause
        
    end
end

pause


plot(t,squeeze(toplot(row,col,round(Fs * plot_start):round(Fs * plot_stop))),'LineWidth',2, 'Color', 'white')
        axis tight
        axis off
        ylim([-1.2e-3 0.5e-3])


lineXpos = 0;   % position of scale bar origin in seconds
lineXsize = 0.25;  % size of horizontal scale bar in seconds
lineYpos = -1e-3;    % position of scale bar origin in volts
lineYsize = 1e-3;   % size of vertical scale bar in volts

scalebarColor = 'black';
line([lineXpos lineXpos+lineXsize], [lineYpos lineYpos], 'LineWidth',4, 'Color', scalebarColor)
line([lineXpos lineXpos]          , [lineYpos lineYpos+lineYsize], 'LineWidth',4, 'Color', scalebarColor)


% resp = std(a(:,round(Fs * resp_start):round(Fs * resp_stop)),0,2);
% bkgd = std(a(:,round(Fs * bkgd_start):round(Fs * bkgd_stop)),0,2);
% snr = resp ./ bkgd;
% 
% [sorted idx] = sort(snr(:),1,'descend');
% 
% 
% 
% x = 0:1/Fs:size(data,2)/Fs-1/Fs;
% 
% plots(a(idx(1:numRow*numCol),:), numCol, numRow, 1, numCol, Fs)
%colorbar


%% Plot

a = squeeze(mean(eps(:,:,:,1:numRow*numCol,:),3));

%plots(a, numCol, numRow, 1, numChan, Fs)

lineXpos = 2.1;   % position of scale bar origin in seconds
lineXsize = 0.2;  % size of horizontal scale bar in seconds
lineYpos = -2.5e-4;    % position of scale bar origin in volts
lineYsize = 5e-4;   % size of vertical scale bar in volts

%a = squeeze(eps(1,1,1,:,:));
%a = squeeze(mean(a,1));
%plots(spindle, numCol, numRow, 1, numChan, Fs)
%plots(a(:,round(Fs * 2.5):round(Fs * 4.5)), numCol, numRow, 1, numChan, Fs, [], [], 'TRUE', lineXpos, lineXsize, lineYpos, lineYsize)
%plots(a, numCol, numRow, 1, numChan, Fs, [], [], 'FALSE', lineXpos, lineXsize, lineYpos, lineYsize)


resp_start = 3.0;
resp_stop = 4.0;
bkgd_start = 2.0;
bkgd_stop = 2.99;

resp = std(a(:,:,round(Fs * resp_start):round(Fs * resp_stop)),0,3);
bkgd = std(a(:,:,round(Fs * bkgd_start):round(Fs * bkgd_stop)),0,3);
snr = resp ./ bkgd;

sorted = sort(snr(:));
        minVal = sorted(round(size(sorted,1) * 0.02));
        maxVal = sorted(round(size(sorted,1) * 0.98))

figure
for i = 1:size(resp,1)
subplot(3,3,i)
imagesc(reshape(squeeze(snr(i,:)),numRow,numCol), [minVal maxVal])
axis image
end
%colorbar

%% try something else

% all_eps = reshape(eps(:,:,:,1:numRow*numCol,:),size(eps,1)*size(eps,3)*numRow*numCol, size(eps,5));
% resp_start = 3.0;
% resp_stop = 3.2;
% bkgd_start = 2.5;
% bkgd_stop = 3.0;
% 
% resp = std(all_eps(:,round(Fs * resp_start):round(Fs * resp_stop)),0,2);
% bkgd = std(all_eps(:,round(Fs * bkgd_start):round(Fs * bkgd_stop)),0,2);
% snr = resp ./ bkgd;
% 
% [y i] = sort(snr,'descend');

%all_eps = all_eps(i,:);
%all_eps = all_eps(1:numRow*numCol,:);   % take top 360
%plots(all_eps(:,round(Fs * 2.5):round(Fs * 4.5)), numCol, numRow, 1, numChan, Fs, [], [], 'FALSE', lineXpos, lineXsize, lineYpos, lineYsize)

lineXpos = 2.1;   % position of scale bar origin in seconds
lineXsize = 0.2;  % size of horizontal scale bar in seconds
lineYpos = -2.5e-4;    % position of scale bar origin in volts
lineYsize = 5e-4;   % size of vertical scale bar in volts

meanEp = squeeze(mean(mean(eps(:,:,:,1:numRow*numCol,:),3),1));


%plots(squeeze(eps(4,1,3,:,:)), numCol, numRow, 1, numChan, Fs,  -2e-4, 2e-4, 'FALSE', lineXpos, lineXsize, lineYpos, lineYsize)
%plots(squeeze(a(:,round(Fs * 2.5):round(Fs * 4.5))), numCol, numRow, 1, numChan, Fs, [], [], 'FALSE', lineXpos, lineXsize, lineYpos, lineYsize)


%plots(squeeze(meanEp), numCol, numRow, 1, numChan, Fs, -2e-4, 2e-4, 'FALSE', lineXpos, lineXsize, lineYpos, lineYsize)


% Interpolate the data by this amount
interp_factor = 12;

% create average trace
xAvg = mean(meanEp,1);

corr_start = 3;
corr_stop = 4;

xAvg = xAvg(round(corr_start * Fs) : round(corr_stop * Fs));
meanEp = meanEp(:,round(corr_start * Fs) : round(corr_stop * Fs));
% upsample for better delay plots
xAvg = interp(xAvg, interp_factor);

signal = zeros(size(meanEp,1), size(meanEp,2) * interp_factor);

corr_val = zeros(1,size(meanEp,1));
for i = 1 : size(meanEp,1)
    signal(i,:) = interp(meanEp(i,:), interp_factor);
    [corr_amp(i) corr_val(i)] = max(xcov(signal(i,:),xAvg));
end


% convert to ms
corr_val = (corr_val ./ (Fs * interp_factor)) * 1000;

% remove min
corr_val = corr_val - min(corr_val(:));


figure
    imagesc(reshape(corr_val,numRow, numCol))
    title(strcat('unsaturated delay in ms start'))
    colorbar
    

%imagesc(corr_val)
% use 1% and 99% val
sorted = sort(corr_val(:));

% saturate min
minVal = sorted(round(size(sorted,1) * 0.02));
corr_val(corr_val < minVal) = minVal;

maxVal = sorted(round(size(sorted,1) * 0.85));
corr_val(corr_val > maxVal) = maxVal;




    % plot saturated data
    figure
    imagesc(reshape(corr_val,numRow, numCol))
    title(strcat('2% to 98% saturated delay in ms start   '))
    colorbar

    

%% movie

a = -squeeze(mean(mean(eps(1,:,:,1:numRow*numCol,:),3),1));
convert2Movie (a, filename, 3, 3.5 , 0, numRow, numCol, Fs, [], [], 'FALSE')


