
%% load data

close all
clear all
load('I:\jv_electrode_data\JonResults-bothNoFirst2400-01-Dec-2010055936.mat');
jonResults = results;
load('I:\jv_electrode_data\test_40_41_spikes_justin.mat');
spikeDelays = spikeDelays(1194:end,:);
rmsVals = rmsVals(1194:end,:);
spikeTimes = spikeTimes(1194:end);
spikes = spikes(1194:end,:,:);

t2 = t2 + max(t1);
spikeTimes(431:end) = spikeTimes(431:end) + max(t1);


numClusters = size(jonResults.centroidsTrans,1);
numPoints = size(jonResults.featDataTrans,1);
distances = zeros(numClusters,numPoints);

% find the l1 distances from each spike to all of the centroids
for i = 1:numClusters
    for j = 1:numPoints
        
        distances(i,j) = norm(jonResults.featDataTrans(j,:) - jonResults.centroidsTrans(i,:),1);
        
    end
end

% find closest centroid for each spike
[a b] = min(distances,[],1);

mkdir(strcat(pwd,'.\figures\',date));
screen_size = get(0, 'ScreenSize');

numRowplot = 7;
numColplot = 10;
numSubplot = numRowplot*numColplot;   % how many per plot

%save_fig = 'TRUE';
save_fig = 'FALSE';

%spike_movies = 'TRUE';
spike_movies = 'FALSE';

%save_mov = 'TRUE';
save_mov = 'FALSE';



%% Subplot of top example for each cluster
f3 = figure('color','white');
set(f3, 'Position', [0 0 screen_size(3) screen_size(4) ] );
clf

for i = 1:numClusters
    
    orig_idx = find(b == i);
    [y idx] = sort(a(b==i));
    
    % plot the source data
    h = subplot(5,6,i);
    
    p = get(h, 'pos');
    p(3) = p(3) + 0.01;
    p(4) = p(4) + 0.025;
    set(h, 'pos', p);
    
    % saturate min
    iso = spikeDelays(orig_idx(idx(1)),:);
    sorted = sort(iso(:));
    minVal = sorted(round(size(sorted,1) * 0.02));
    maxVal = sorted(round(size(sorted,1) * 0.98));
    
    imagesc(reshape(iso,numRow,numCol), [minVal maxVal] )
    colormap(jet(256))
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    title(['cluster ' num2str(i)]);
end

if strcmp(save_fig, 'TRUE')
    [~,name] = fileparts(filename);
    fileString = strcat(pwd,'.\figures\',date,'\',name,'_clustered_data_all_clusters.png');
    set(gcf,'PaperPositionMode','auto')
    print(gcf, '-dpng', fileString, '-r 300')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Subplot of top example for each cluster %%%%%%%%%%%%%
f3 = figure('color','white');
set(f3, 'Position', [0 0 screen_size(3) screen_size(4) ] );
clf

for i = 1:numClusters
    
    orig_idx = find(b == i);
    [y idx] = sort(a(b==i));
    
    % plot the source data
    h = subplot(5,6,i);
    
    p = get(h, 'pos');
    p(3) = p(3) + 0.01;
    p(4) = p(4) + 0.025;
    set(h, 'pos', p);
    
    % plot average spike for each cluster
    plot(reshape(mean(mean(spikes(orig_idx,:,:),1),2),1,size(spikes,3)),'k','LineWidth',3)
    axis off
    title(['cluster ' num2str(i)]);
end

if strcmp(save_fig, 'TRUE')
    [~,name] = fileparts(filename);
    fileString = strcat(pwd,'.\figures\',date,'\',name,'_clustered_data_all_clusters.png');
    set(gcf,'PaperPositionMode','auto')
    print(gcf, '-dpng', fileString, '-r 300')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Seperate plots of top example from each cluster and the corresponding spike waveform %%%%%%%%%%%


interict_clust = [1 5 17 8 18 20 ];
ictal_clust = [2 4 12 19];
clust_lut = [interict_clust ictal_clust];
%clust_lut = [ictal_clust];

for loopi = 1:size(clust_lut,2)        % try with 4 clusters

    i = clust_lut(loopi);       % which cluster
    orig_idx = find(b == i);    % find members of this cluster
    [y idx] = sort(a(b==i));    % sort to the find closest spikes to centroid
    
    % take first example from each cluster
    iso = spikeDelays(orig_idx(idx(1)),:);
    
    save_fig = 'FALSE';
    numRowplot = 1;
    numColplot = 1;
    satMode = 'FRAME';
    satMin = 0.01;
    satMax = 0.99;
    colorscale_label = 'ms';
    aspect_corr = 'TRUE';
    normalizeMinScale = 'TRUE';
    plotTitles = 'FALSE';
    titleStr = ['cluster_prototype_delay_map cluster ' num2str(clust_lut(loopi))];
    
    % plot colormap for first spike
    M = ImagemapSubplot(iso', numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles);
    
    % plot the waveform for the average of all the channels and spikes
    f = figure;
    set(f,'color','white');
    set(f, 'Position', [0 0 screen_size(3) screen_size(4) ] );

    % scale bars
    lineXpos = 45;   % position of scale bar origin in seconds
    lineXsize = .04 * Fs;  % size of horizontal scale bar in seconds
    lineYpos = 0;    % position of scale bar origin in volts
    lineYsize = 2e-3;   % size of vertical scale bar in volts
    
    % plot average of all spikes in this cluster
    plot(reshape(mean(mean(spikes(orig_idx,:,:),1),2),1,size(spikes,3)),'red','LineWidth',20)
    
    % plot average of only one spike from this cluster
    %plot(reshape(mean(mean(spikes(orig_idx(idx(1)),:,:),1),2),1,size(spikes,3)),'y','LineWidth',3)
    
    % plot scale bars
    line([lineXpos lineXpos+lineXsize], [lineYpos lineYpos], 'LineWidth',25, 'Color', 'black')
    line([lineXpos lineXpos]          , [lineYpos lineYpos+lineYsize], 'LineWidth',25, 'Color', 'black')
    axis off
  
    % filename for writeout
    titleStr = ['cluster_prototype_delay_map spike waveform cluster ' num2str(clust_lut(loopi))];
    
    if strcmp(save_fig, 'TRUE')
        [~,name] = fileparts(filename);
        mkdir(strcat(pwd,'.\figures\',date));
        fileString = strcat(pwd,'.\figures\',date,'\',name,'_',titleStr,'.fig');
        saveas(gcf, fileString, 'fig')
    end
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Subplot of top 8 examples for each cluster %%%%%%%%%%%
f = figure('color','white');
set(f, 'Position', [0 0 screen_size(3) screen_size(4) ] );
clf
loc_lut = [1 2 3 7 8 9 13 14 15 4 5 6 10 11 12 16 17 18 19 20 21 25 26 27 31 32 33 22 23 24 28 29 30 34 35 36];
count = 0;
for loopi = 1:4         % try with 4 clusters
    i = clust_lut(loopi);
    orig_idx = find(b == i);
    [y idx] = sort(a(b==i));
    
    for j = 1:4
        count = count + 1;
        % plot the source data
        %h = subplot(6,6,count);
        h = subplot(6,6,loc_lut(count));
        
        p = get(h, 'pos');
        p(3) = p(3) + 0.01;
        p(4) = p(4) + 0.025;
        set(h, 'pos', p);
        
        % saturate min
        % take first example from each cluster
        iso = spikeDelays(orig_idx(idx(j)),:);
        sorted = sort(iso(:));
        minVal = sorted(round(size(sorted,1) * 0.02));
        maxVal = sorted(round(size(sorted,1) * 0.98));
        
        imagesc(reshape(iso,numRow,numCol), [minVal maxVal] )
        colormap(jet(256))
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        %title(['cluster ' num2str(i)]);
    end
    
    count = count + 1;
    % plot the source data
    h = subplot(6,6,loc_lut(count));
    
    p = get(h, 'pos');
    p(3) = p(3) + 0.01;
    p(4) = p(4) + 0.025;
    set(h, 'pos', p);
    
    % saturate min
    plot(reshape(mean(mean(spikes(orig_idx,:,:),1),2),1,size(spikes,3)),'k','LineWidth',3)
    axis off
    %title(['cluster ' num2str(i)]);
    
    for j = 5:8
        count = count + 1;
        % plot the source data
        %h = subplot(6,6,count);
        h = subplot(6,6,loc_lut(count));
        
        p = get(h, 'pos');
        p(3) = p(3) + 0.01;
        p(4) = p(4) + 0.025;
        set(h, 'pos', p);
        
        % saturate min
        % take first example from each cluster
        iso = spikeDelays(orig_idx(idx(j)),:);
        sorted = sort(iso(:));
        minVal = sorted(round(size(sorted,1) * 0.02));
        maxVal = sorted(round(size(sorted,1) * 0.98));
        
        imagesc(reshape(iso,numRow,numCol), [minVal maxVal] )
        colormap(jet(256))
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        %title(['cluster ' num2str(i)]);
    end
    
    
end

if strcmp(save_fig, 'TRUE')
    [~,name] = fileparts(filename);
    fileString = strcat(pwd,'.\figures\',date,'\',name,'_clustered_data_all_clusters.png');
    set(gcf,'PaperPositionMode','auto')
    print(gcf, '-dpng', fileString, '-r 300')
end


%% Generate spike scatter plot





close all
figure(1)
t = [t1 t2];
xAvg = [xAvg1 xAvg2];


numClusters = max(jonResults.clusterLabels);

if exist('spikeRates', 'var') == 0
    spikeRates = zeros(numClusters,size(xAvg,2));
    for i = 1:numClusters
        spikeRates(i,round(spikeTimes(jonResults.clusterLabels == i)* Fs)) = 1;
        
        spikeRates(i,:) = smooth(spikeRates(i,:), round(Fs * 5));
        
    end
end


%for j = 1:numClusters
clf
plot(t,xAvg)
yMin =  -2e-3;
yMax = 13e-3;
axis([2400 3190 yMin yMax])
hold on
%scatter(spikeTimes,ones(size(spikeTimes))*5e-4, [],jonResults.clusterLabels', 'filled')

which_chan = [2 4 12 14 19];
%which_chan = 12;

scale = (jonResults.clusterLabels') * 2e-4 + 8e-3;
scatter(spikeTimes,scale, 5,jonResults.clusterLabels', 'filled')

plot(t,spikeRates(which_chan,:)' * 2e-1 + 5e-3)
title(['cluster ' num2str(j)])

%          for i = 2350 : 40: round(size(xAvg,2) / Fs)
%      figure(1)
%      axis([i i + 100 yMin yMax])
%     pause
%          end


%end

%% plot of average signal and spike detections

%close all
t = [t1 t2];
xAvg = [xAvg1 xAvg2];

figure(2)
clf
screen_size = get(0, 'ScreenSize');
set(2, 'Position', [0 100 screen_size(3) 500 ] );

plot(t,xAvg,'LineWidth',4,'Color','yellow')
yMin =  -2e-3;
yMax = 5e-3;
xMin = 2611;
xMax = 2617;
%axis([2400 3190 yMin yMax])
axis([xMin xMax yMin yMax])
axis off
hold on

scale = ones(size(spikeTimes)) * 5e-4;
scatter(spikeTimes,scale, 120, 'red', 'filled')

lineXpos = 2616.2;   % position of scale bar origin in seconds
lineXsize = .5;  % size of horizontal scale bar in seconds
lineYpos = 1.0e-3;    % position of scale bar origin in volts
lineYsize = 2e-3;   % size of vertical scale bar in volts


line([lineXpos lineXpos+lineXsize], [lineYpos lineYpos], 'LineWidth',6, 'Color', 'white')
line([lineXpos lineXpos]          , [lineYpos lineYpos+lineYsize], 'LineWidth',6, 'Color', 'white')

save_fig = 'TRUE';

if strcmp(save_fig, 'TRUE')
    % Make folder for figure output based on today's date
    [PATHSTR,NAME,EXT] = fileparts(filename);
    pathstr = strcat(pwd,'.\figures\',datestr(now, 'yyyy-mm-dd'));
    mkdir(pathstr);

    % write out figure
    title_str = strcat(NAME,'_average_signal_and_spike_detections_start',num2str(xMin),'_stop',num2str(xMax));
    fileString = strcat(pathstr,'\',title_str,'.fig');
    disp(['Writing out figure ' fileString])
    saveas(gcf, fileString, 'fig')
end

%%
%%%%%%%%%%%%%%% Code below not needed, moved into hdn_paper .m files

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% for i = 1:numClusters
%
%
%     orig_idx = find(b == i);
%     [y idx] = sort(a(b==i));
%
%     %     figure(5)
%     %     plot(y)
%
%     numMembers = size(orig_idx,2);
%
%     f = figure(4);
%     set(f, 'Position', [0 0 screen_size(3) screen_size(4) ] );
%     clf
%
%
%     f = figure(5);
%     set(f, 'Position', [0 0 screen_size(3) screen_size(4) ] );
%     clf
%
%
%     figure(4)
%     for j = 1:numMembers
%
%         % if we haven't filled up the plot, add one more
%         if j <= numSubplot
%             % 1 figure per cluster
%
%             % plot the source data
%
%             h = subplot(numRowplot,numColplot,j);
%             p = get(h, 'pos');
%             p(3) = p(3) + 0.012;
%             p(4) = p(4) + 0.024;
%             set(h, 'pos', p);
%
%             imagesc(reshape(spikeDelays(orig_idx(idx(j)),:),numRow,numCol))
%             colormap(jet(256))
%             set(gca,'XTick',[]);
%             set(gca,'YTick',[]);
%             %title(['dist ' num2str(y(j))]);
%             title(['spike number ' num2str(orig_idx(idx(j)))]);
%         end
%     end
%
%     figure(5)
%     for j = 1:numMembers
%
%         % if we haven't filled up the plot, add one more
%         if j <= numSubplot
%             % 1 figure per cluster
%
%             % plot the source data
%             h = subplot(numRowplot,numColplot,j);
%
%             p = get(h, 'pos');
%             p(3) = p(3) + 0.012;
%             p(4) = p(4) + 0.024;
%             set(h, 'pos', p);
%
%             % saturate min
%             iso = spikeDelays(orig_idx(idx(j)),:);
%             sorted = sort(iso(:));
%             minVal(j) = sorted(round(size(sorted,1) * 0.02));
%             maxVal(j) = sorted(round(size(sorted,1) * 0.98));
%
%             imagesc(reshape(iso,numRow,numCol), [minVal(j) maxVal(j)] )
%             colormap(jet(256))
%             set(gca,'XTick',[]);
%             set(gca,'YTick',[]);
%             %title(['dist ' num2str(y(j))]);
%         end
%     end
%
%     h = axes('Position', [0.05 0.31 0.91 0.45], 'Visible', 'off');
%     caxis([0 mean(maxVal)- mean(minVal)])
%     c=colorbar ('FontSize',16);
%     ylabel(c,'delay in milliseconds')
%
%
%     if strcmp(spike_movies, 'TRUE')
%         M = [];
%         for spikenum = 1:10
%             M = [M convert2Movie(reshape(spikes(orig_idx(idx(spikenum)),:,:),size(spikes,2),size(spikes,3)), filename, [], [], 0, numRow, numCol, Fs)];
%         end
%
%         if strcmp(save_mov, 'TRUE')
%             [PATHSTR,NAME,EXT,VERSN] = fileparts(filename);
%
%             mkdir(strcat(PATHSTR, '\movies'));
%
%             title_str = strcat(NAME,'_clustered_data_spikes_cluster_',num2str(i));
%             %title(title_str);
%
%             fileString = strcat(strcat(PATHSTR, '\movies\'),title_str,'.avi');
%
%             disp(['Writing out movie ' fileString])
%
%             movie2avi(M,fileString, 'COMPRESSION', 'none');
%
%         end
%
%
%     end
%
%
%     if strcmp(save_fig, 'TRUE')
%         [~,name] = fileparts(filename);
%         fileString = strcat(pwd,'.\figures\',date,'\',name,'_clustered_data_cluster_',num2str(i),'.png');
%         set(gcf,'PaperPositionMode','auto')
%         print(gcf, '-dpng', fileString, '-r 300')
%     else
%         pause
%     end
%
%
% end
%
