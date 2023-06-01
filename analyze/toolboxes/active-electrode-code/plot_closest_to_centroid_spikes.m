

%% data setup

numClusters = size(jonResults.centroidsTrans,1);
numPoints = size(jonResults.featDataTrans,1);
distances = zeros(numClusters,numPoints);

close all;

for i = 1:numClusters
    for j = 1:numPoints
        
        distances(i,j) = norm(jonResults.featDataTrans(j,:) - jonResults.centroidsTrans(i,:),1);
        
    end
end


[a b] = min(distances,[],1);

mkdir(strcat(pwd,'.\figures\',date));
screen_size = get(0, 'ScreenSize');

%save_fig = 'TRUE';
save_fig = 'FALSE';

%spike_movies = 'TRUE';
spike_movies = 'FALSE';

%save_mov = 'TRUE';
save_mov = 'FALSE';

numRowplot = 7;
numColplot = 10;
numSubplot = numRowplot*numColplot;   % how many per plot



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

%% Subplot of top 5 examples for each cluster %%%%%%%%%%%
f = figure('color','white');
set(f, 'Position', [0 0 screen_size(3) screen_size(4) ] );
clf
count = 0;

interict_clust = [1 5 17 8 18 20 ];
ictal_clust = [2 4 12 19];
clust_lut = [interict_clust ictal_clust];
%clust_lut = [ictal_clust];

for loopi = 1:6         % try with 4 clusters
    i = clust_lut(loopi);
    orig_idx = find(b == i);
    [y idx] = sort(a(b==i));
    
    for j = 1:5
        count = count + 1;
        % plot the source data
        %h = subplot(6,6,count);
        h = subplot(6,6,count);
        
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
    h = subplot(6,6,count);
    
    p = get(h, 'pos');
    p(3) = p(3) + 0.01;
    p(4) = p(4) + 0.025;
    set(h, 'pos', p);
    
    % saturate min
    plot(reshape(mean(mean(spikes(orig_idx,:,:),1),2),1,size(spikes,3)),'k','LineWidth',3)
    axis off
    %title(['cluster ' num2str(i)]);
    
end

if strcmp(save_fig, 'TRUE')
    [~,name] = fileparts(filename);
    fileString = strcat(pwd,'.\figures\',date,'\',name,'_clustered_data_all_clusters.png');
    set(gcf,'PaperPositionMode','auto')
    print(gcf, '-dpng', fileString, '-r 300')
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
