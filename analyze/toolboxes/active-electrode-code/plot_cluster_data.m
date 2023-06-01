

% plot examples from each cluster
close all
numSubplot = 100;   % how many per plot
numClusters = max(jonResults.clusterLabels);    % how many total clusters

meanCluster = zeros(numClusters,numRow*numCol);
meanRMS = zeros(numClusters,numRow*numCol);

for i=1:numClusters
    
    %figure(i)       % open figure for each cluster
    figure(1)
    clf
    
    numMembers = sum(jonResults.clusterLabels == i);
    clusterData = spikeDelays(jonResults.clusterLabels == i,:);
    rmsData = rmsVals(jonResults.clusterLabels == i,:);
    meanRMS(i,:) = mean(rmsData,1); 
    
    for j = 1:numMembers
        
        % if we haven't filled up the plot, add one more
        if j <= numSubplot
            % 1 figure per cluster
            subplot(sqrt(numSubplot),sqrt(numSubplot),j)
            % plot the source data
            imagesc(reshape(clusterData(j,:),numRow,numCol))
        end
        
        
    end
    
    figure(2)
    clf
    meanCluster(i,:) = mean(clusterData,1);
    imagesc(reshape(meanCluster(i,:),numRow,numCol))
    
    %pause
end

figure(3)
clf
for i = 1:numClusters
    
    subplot(4,5,i)
    imagesc(reshape(meanCluster(i,:),numRow,numCol))
    title(['cluster' num2str(i)]);
    
end

figure(4)
clf
for i = 1:numClusters
    
    subplot(4,5,i)
    imagesc(reshape(meanRMS(i,:),numRow,numCol))
    title(['cluster' num2str(i)]);
    
end
