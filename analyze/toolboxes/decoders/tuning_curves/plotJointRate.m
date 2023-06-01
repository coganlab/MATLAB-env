function plotJointRate(spikeCounts,jointPos,jointNames)

numJoints = size(jointPos,2);
assert(numJoints==numel(jointNames),'Must have same number of joints and joint names');
for i = 1:numJoints
    jointNames{i} = regexprep(jointNames{i},'_',' ');
end
numBins = 10; % Can change this to bin data more finely or coarsely
binCenters = zeros(numJoints,numBins);
jointBins = zeros(size(jointPos)); % for each joint and time point, gives the bin into which that time point falls
for i = 1:size(binCenters,1)
    [~,binCenters(i,:)] = hist(jointPos(:,i),numBins);
    [~,jointBins(:,i)] = min(abs(repmat(jointPos(:,i),1,numBins)-repmat(binCenters(i,:),size(jointPos,1),1)),[],2);
end

t = 0;
meanSpikeCount = zeros(numBins,numBins,size(spikeCounts,2),numJoints*(numJoints+1)/2);
for i = 1:numJoints
    for j = i+1:numJoints
        t = t+1;
        for m = 1:numBins
            for n = 1:numBins
                meanSpikeCount(m,n,:,t) = mean(spikeCounts(jointBins(:,i) == m & jointBins(:,j) == n,:));
            end
        end
    end
end

maxCount = max(max(max(max(meanSpikeCount))));
t = 0;
for i = 1:numJoints
    for j = i+1:numJoints
        t = t+1;
        for q = 1:size(spikeCounts,2)
            figure(q)
            if mod(numJoints,2) == 0
                subplot(numJoints/2,numJoints-1,t)
            else
                subplot((numJoints-1)/2,numJoints,t)
            end
            image(meanSpikeCount(:,:,q,t),'CDataMapping','scaled');
            caxis([0 maxCount])
            axis xy
            axis square
            xlabel(jointNames{i})
            ylabel(jointNames{j})
        end
    end
end