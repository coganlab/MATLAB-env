

% number of times to run kmeans - increase if not finding the minimum, decrease if taking too long
numReplicates = 3;


%cluster_data = [spikeDelays rmsVals];
%cluster_data = spikeDelays .* rmsVals;
cluster_data = [spikeDelays];

% try 1 to 20 clusters
for clust = 1:15
    [idx,levels, sumd] = kmeans(cluster_data,clust, 'Display','final', 'replicates', numReplicates);
    disp(['clustering kmeans into ' num2str(clust) ' clusters']);
    error(clust) = sum(sumd);
end


figure(21)
plot(error)

% 9 clusters seems good from the error plot?
clust = 15;

% run it again
[idx,levels, sumd] = kmeans(spikeDelays,clust, 'Display','final', 'replicates', numReplicates);


% plot examples from each cluster
numSubplot = 100;
subCount = zeros(1,numSubplot);

for i=1:size(idx)
    
    % count how many plots we've done
    subCount(idx(i)) = subCount(idx(i)) + 1;

    % if we haven't filled up the plot, add one more
    if subCount(idx(i)) <= numSubplot
        % 1 figure per cluster
        figure(idx(i))
        subplot(sqrt(numSubplot),sqrt(numSubplot),subCount(idx(i)))
        % plot the source data
        imagesc(reshape(spikeDelays(i,:),numRow,numCol))
    end
end

