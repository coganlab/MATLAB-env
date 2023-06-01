function [meanSpikeCount numSpikeCount] = plotPairJointRate(spikeCounts,jointPos,jointNames,jointCombo,posMin,posMax)

if nargin == 4 % to avoid outliers, define upper and lower bounds for joint positions
    posMin = mean(jointPos) - 3*std(jointPos);
    posMax = mean(jointPos) + 3*std(jointPos);
end
numJoints = size(jointPos,2);
assert(numJoints==numel(jointNames),'Must have same number of joints and joint names');
for i = 1:numJoints
    jointNames{i} = regexprep(jointNames{i},'_',' ');
end
numBins = 20; % Can change this to bin data more finely or coarsely
binCenters = zeros(numJoints,numBins);
jointBins = zeros(size(jointPos)); % for each joint and time point, gives the bin into which that time point falls
for i = 1:size(binCenters,1)
    [~,binCenters(i,:)] = hist(jointPos(jointPos(:,i)>posMin(i) & jointPos(:,i)<posMax(i),i),numBins);
    [~,jointBins(:,i)] = min(abs(repmat(jointPos(:,i),1,numBins)-repmat(binCenters(i,:),size(jointPos,1),1)),[],2); % This still works even if we include outliers, as those will get dumped into either the max or min bin
end

meanSpikeCount = zeros(numBins,numBins,size(spikeCounts,2),size(jointCombo,1));
numSpikeCount = zeros(numBins,numBins,size(spikeCounts,2),size(jointCombo,1));
for t = 1:size(jointCombo,1)
    for m = 1:numBins
        for n = 1:numBins
            meanSpikeCount(m,n,:,t) =  mean(spikeCounts(jointBins(:,jointCombo(t,1)) == m & jointBins(:,jointCombo(t,2)) == n,:));
            numSpikeCount(m,n,:,t)  = numel(spikeCounts(jointBins(:,jointCombo(t,1)) == m & jointBins(:,jointCombo(t,2)) == n,:));
        end
    end
end


maxCount = max(max(max(max(meanSpikeCount))));
for t = 1:size(jointCombo,1)
    for q = 1:size(spikeCounts,2)
        figure(q)
        subplot(size(jointCombo,1),2,1+2*(t-1))
        image(meanSpikeCount(:,:,q,t),'CDataMapping','scaled');
        caxis([0 maxCount])
        axis xy
        axis square
        title('Mean Firing Rate')
        xlabel(jointNames{jointCombo(t,1)})
        ylabel(jointNames{jointCombo(t,2)})
        colorbar
        
        subplot(size(jointCombo,1),2,2*t)
        imagesc(numSpikeCount(:,:,q,t),'CDataMapping','scaled');
        axis xy
        axis square
        title('Data per Bin')
        xlabel(jointNames{jointCombo(t,1)})
        ylabel(jointNames{jointCombo(t,2)})
        colorbar
    end
end
