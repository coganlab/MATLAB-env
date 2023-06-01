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

save_fig = 'TRUE';

%% calculations of spike amplitude and standard deviation from text
mean(max(mean(spikes,2),[],3)) 
std(max(mean(spikes,2),[],3),0,1)


%% supplemental figures - up to 70 examples from each cluster

% for all the clusters, generate one figure
for i = 1:numClusters
    
    close all
    
    orig_idx = find(b == i);        % find spikes in this cluster
    [y idx] = sort(a(b==i));        % sort the spikes by their distance from the centroid
    
    numMembers = size(orig_idx,2);
    
    % grab the data for this cluster
    frames = spikeDelays(orig_idx(idx),:)';
    
    % setup the plots
    numRowplot = 7;
    numColplot = 10;
    satMode = 'FRAME';
    satMin = 0.02;
    satMax = 0.98;
    %save_fig = 'FALSE';
    colorscale_label = 'Spike Delay in Milliseconds';
    aspect_corr = 'TRUE';
    titleStr = ['Spike Cluster ' num2str(i) ' frame saturated'];
    normalizeMinScale = 'TRUE';
    plotTitles = [];
    ySpace = 0.008;
    
    % plot first with all frames saturated individually
    M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);
    
    titleStr = ['Spike Cluster ' num2str(i) ' with labels'];
    %save_fig = 'TRUE';
    for j = 1:numMembers
        plotTitles = strvcat(plotTitles, ['spike number ' num2str(orig_idx(idx(j)))]);
    end
    
    % plot first with spike numbers
    M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);
    
end


%% supplemental figure - top example from each cluster

close all

frames = zeros(numRow*numCol, numClusters);

plotTitles = [];

for i = 1:numClusters
    
    orig_idx = find(b == i);        % find spikes in this cluster
    [y idx] = sort(a(b==i));        % sort the spikes by their distance from the centroid
    frames(:,i) = spikeDelays(orig_idx(idx(1)),:)';
    plotTitles = strvcat(plotTitles, ['Cluster ' num2str(i)]);
end

% setup the plots
numRowplot = 4;
numColplot = 6;
satMode = 'FRAME';
satMin = 0.02;
satMax = 0.98;
%save_fig = 'FALSE';
colorscale_label = 'Spike Delay in Milliseconds';
aspect_corr = 'TRUE';
titleStr = ['All Spike Clusters frame saturated'];
normalizeMinScale = 'TRUE';
ySpace = 0.008;

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);


%% supplemental spike example movies

for i = 1:numClusters
    
    close all
    
    orig_idx = find(b == i);        % find spikes in this cluster
    [y idx] = sort(a(b==i));        % sort the spikes by their distance from the centroid
    
    % make a movie of the top 10 spikes from each cluster
    M = [];
    for spikenum = 1:3
        M = [M convert2Movie(reshape(spikes(orig_idx(idx(spikenum)),:,:),size(spikes,2),size(spikes,3)), filename, [], [], 0, numRow, numCol, Fs, -3e-3, 3e-3, 'FALSE')];
    end
    
    save_mov = 'FALSE';
    if strcmp(save_mov, 'TRUE')
        [PATHSTR,NAME,EXT] = fileparts(filename);
        pathstr = strcat(pwd,'.\figures\',datestr(now, 'yyyy-mm-dd'));
        mkdir(pathstr);
        title_str = strcat(NAME,'_clustered_data_spikes_cluster_',num2str(i));
        fileString = strcat(pathstr,'\',title_str,'.avi');
        disp(['Writing out movie ' fileString])
        movie2avi(M,fileString, 'COMPRESSION', 'none');
    end
    
    
end

%% supplemental spike example movie - cluster 13 - clockwise spirals

i = 13;

close all

orig_idx = find(b == i);        % find spikes in this cluster
[y idx] = sort(a(b==i));        % sort the spikes by their distance from the centroid

%clockwiseSpirals = [ 514 500 502 864 442 790 748 749];
clockwiseSpirals = [864 442 790];

% make a movie of the top 10 spikes from each cluster
M = [];
for spikenum = 1:size(clockwiseSpirals,2)
    M = [M convert2Movie(reshape(spikes(clockwiseSpirals(spikenum),:,:),size(spikes,2),size(spikes,3)), filename, [], [], 0, numRow, numCol, Fs, -3e-3, 3e-3, 'FALSE')];
end

save_mov = 'TRUE';
if strcmp(save_mov, 'TRUE')
    [PATHSTR,NAME,EXT] = fileparts(filename);
    pathstr = strcat(pwd,'.\figures\',datestr(now, 'yyyy-mm-dd'));
    mkdir(pathstr);
    title_str = strcat(NAME,'_clustered_data_spikes_cluster_',num2str(i));
    fileString = strcat(pathstr,'\',title_str,'.avi');
    disp(['Writing out movie ' fileString])
    movie2avi(M,fileString, 'COMPRESSION', 'none');
end


%% planar wave r->L #1 from cluster 17 

close all

frame_start = 13;
frame_step = 3;
frame_stop = frame_start + 23;
frames = squeeze(spikes(764,:,frame_start:frame_step:frame_stop));
numRowplot = 5;
numColplot = 8;
satMode = 'FRAME';
satMin = 0.01;
satMax = 0.99;
%save_fig = 'FALSE';
colorscale_label = 'Volts';
aspect_corr = 'TRUE';
frame_interval = (frame_step / Fs) * 1000;
titleStr = ['Cluster 17 - Planar Wave - Right to Left ' num2str(frame_interval) ' ms frame saturated'];
normalizeMinScale = 'FALSE';
plotTitles = [];
ySpace = 0.008;

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);

satMode = 'FIXED';
satMin = -2.4e-3;
satMax = 3.4e-3;
titleStr = ['Cluster 17 - Planar Wave - Right to Left ' num2str(frame_interval) ' ms fixed colorscale'];

M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);

%% Spiral Wave Clockwise #1 from cluster 12 

close all

frames_interp = [];
interp_factor = 2;
frames = squeeze(spikes(122,:,:));
for i = 1:size(frames,1)
    frames_interp(i,:) = interp(frames(i,:),interp_factor);
end

    

frame_start = 30;
frame_step = 5;
frame_stop = frame_start + 35;
frames = frames_interp(:,frame_start:frame_step:frame_stop);

% frame_start = 15;
% frame_step = 1;
% frame_stop = frame_start + 20;
% frames = squeeze(spikes(122,:,frame_start:frame_step:frame_stop));

numRowplot = 5;
numColplot = 8;
satMode = 'FRAME';
satMin = 0.01;
satMax = 0.99;
%save_fig = 'FALSE';
colorscale_label = 'Volts';
aspect_corr = 'TRUE';
frame_interval = (frame_step / (Fs * interp_factor)) * 1000;
titleStr = ['Cluster 12 - Spiral Wave Clockwise ' num2str(frame_interval) ' ms frame saturated'];
normalizeMinScale = 'FALSE';
plotTitles = [];
ySpace = 0.008;

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);


satMode = 'FIXED';
satMin = -3e-3;
satMax = 3e-3;
titleStr = ['Cluster 12 - Spiral Wave Clockwise ' num2str(frame_interval) ' ms fixed colorscale'];

M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);

%% Spiral Wave Counter-Clockwise from Cluster 14

close all

frame_start = 1;
frame_step = 6;
frame_stop = frame_start + 43;
frames = squeeze(spikes(796,:,frame_start:frame_step:frame_stop));

numRowplot = 5;
numColplot = 8;
satMode = 'FRAME';
satMin = 0.01;
satMax = 0.99;
%save_fig = 'FALSE';
colorscale_label = 'Volts';
aspect_corr = 'TRUE';
frame_interval = (frame_step / Fs) * 1000;
titleStr = ['Cluster 14 - Spiral Wave Counter-Clockwise ' num2str(frame_interval) ' ms frame saturated'];
normalizeMinScale = 'FALSE';
plotTitles = [];
ySpace = 0.008;

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);

satMode = 'FIXED';
satMin = -3e-3;
satMax = 3e-3;
titleStr = ['Cluster 14 - Spiral Wave Counter-Clockwise ' num2str(frame_interval) ' ms fixed colorscale'];

M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);


%% Planar wave bottom -> top  from Cluster 18

close all

frame_start = 13;
frame_step = 4;
frame_stop = frame_start + 42;
frames = squeeze(spikes(224,:,frame_start:frame_step:end));

numRowplot = 5;
numColplot = 8;
satMode = 'FRAME';
satMin = 0.01;
satMax = 0.99;
%save_fig = 'TRUE';
colorscale_label = 'Volts';
aspect_corr = 'TRUE';
frame_interval = (frame_step / Fs) * 1000;
titleStr = ['Cluster 18 - Planar wave from bottom to top ' num2str(frame_interval) ' ms frame saturated'];
normalizeMinScale = 'FALSE';
plotTitles = [];
ySpace = 0.008;

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);

satMode = 'FIXED';
satMin = -3e-3;
satMax = 3e-3;
titleStr = ['Cluster 18 - Planar wave from bottom to top ' num2str(frame_interval) ' ms fixed colorscale'];

M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);


%% U shaped wave L --> R --> L from Cluster 20

close all

frame_start = 13;
frame_step = 3;
frame_stop = frame_start + 23;
frames = squeeze(spikes(374,:,frame_start:frame_step:frame_stop));

numRowplot = 5;
numColplot = 8;
satMode = 'FRAME';
satMin = 0.01;
satMax = 0.99;
%save_fig = 'TRUE';
colorscale_label = 'Volts';
aspect_corr = 'TRUE';
frame_interval = (frame_step / Fs) * 1000;
titleStr = ['Cluster 20 - U shaped wave L to R to L ' num2str(frame_interval) ' ms frame saturated'];
normalizeMinScale = 'FALSE';
plotTitles = [];
ySpace = 0.008;

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);

satMode = 'FIXED';
satMin = -3e-3;
satMax = 3e-3;
titleStr = ['Cluster 20 - U shaped wave L to R to L ' num2str(frame_interval) ' ms fixed colorscale'];

M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);

%% Cluster 1

close all

frame_start = 14;
frame_step = 3;
frame_stop = frame_start + 23;
frames = squeeze(spikes(698,:,frame_start:frame_step:frame_stop));

numRowplot = 5;
numColplot = 8;
satMode = 'FRAME';
satMin = 0.01;
satMax = 0.99;
%save_fig = 'TRUE';
colorscale_label = 'Volts';
aspect_corr = 'TRUE';
frame_interval = (frame_step / Fs) * 1000;
titleStr = ['Cluster 1 - ' num2str(frame_interval) ' ms frame saturated'];
normalizeMinScale = 'FALSE';
plotTitles = [];
ySpace = 0.008;

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);

satMode = 'FIXED';
satMin = -3e-3;
satMax = 3e-3;
titleStr = ['Cluster 1 - ' num2str(frame_interval) ' ms fixed colorscale'];

M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);


%% Cluster 5

close all

frame_start = 12;
frame_step = 3;
frame_stop = frame_start + 23;
frames = squeeze(spikes(382,:,frame_start:frame_step:frame_stop));

numRowplot = 5;
numColplot = 8;
satMode = 'FRAME';
satMin = 0.01;
satMax = 0.99;
save_fig = 'TRUE';
colorscale_label = 'Volts';
aspect_corr = 'TRUE';
frame_interval = (frame_step / Fs) * 1000;
titleStr = ['Cluster 5 - ' num2str(frame_interval) ' ms frame saturated'];
normalizeMinScale = 'FALSE';
plotTitles = [];
ySpace = 0.008;

% plot first with all frames saturated individually
M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);

satMode = 'FIXED';
satMin = -3e-3;
satMax = 3e-3;
titleStr = ['Cluster 5 - ' num2str(frame_interval) ' ms fixed colorscale'];

M = ImagemapSubplot(frames, numRowplot, numColplot, satMode, satMin, satMax, aspect_corr, titleStr, colorscale_label, save_fig, numRow, numCol, filename, normalizeMinScale, plotTitles, ySpace);





