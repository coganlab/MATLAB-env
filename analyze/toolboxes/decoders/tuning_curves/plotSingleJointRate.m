function plotSingleJointRate(spikeCounts,jointPos,jointNames)

numJoints = size(jointPos,2);
numSpikes = size(spikeCounts,2);
assert(numJoints==numel(jointNames),'Must have same number of joints and joint names');
for i = 1:numJoints
    jointNames{i} = regexprep(jointNames{i},'_',' ');
end
numBins = 10; % Can change this to bin data more finely or coarsely
binCenters = zeros(numJoints,numBins);
jointBins = zeros(size(jointPos)); % for each joint and time point, gives the bin into which that time point falls
meanCounts = zeros(numJoints,numBins,numSpikes);
for i = 1:numJoints
    [~,binCenters(i,:)] = hist(jointPos(:,i),numBins);
    [~,jointBins(:,i)] = min(abs(repmat(jointPos(:,i),1,numBins)-repmat(binCenters(i,:),size(jointPos,1),1)),[],2);
    for j = 1:numBins
        meanCounts(i,j,:) = mean(spikeCounts(jointBins(:,i) == j,:));
    end
end

for i = 1:numJoints
    figure(i)
    subplot(8,8,1); title(jointNames{i})
    for j = 1:numSpikes
        subplot(8,8,j);
        bar(meanCounts(i,:,j))
        axis off
    end
end