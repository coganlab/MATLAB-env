function plotBootstrapSamplesPairJointRate(spikeCounts,jointPos,jointNames,posMin,posMax)

if nargin == 3 % to avoid outliers, define upper and lower bounds for joint positions
    posMin = mean(jointPos) - 3*std(jointPos);
    posMax = mean(jointPos) + 3*std(jointPos);
end
numJoints = size(jointPos,2);
assert(numJoints==numel(jointNames),'Must have same number of joints and joint names');
for i = 1:numJoints
    jointNames{i} = regexprep(jointNames{i},'_',' ');
end
numBins = 10; % Can change this to bin data more finely or coarsely
binCenters = zeros(numJoints,numBins);
jointBins = zeros(size(jointPos)); % for each joint and time point, gives the bin into which that time point falls
for i = 1:size(binCenters,1)
    [~,binCenters(i,:)] = hist(jointPos(jointPos(:,i)>posMin(i) & jointPos(:,i)<posMax(i),i),numBins);
    [~,jointBins(:,i)] = min(abs(repmat(jointPos(:,i),1,numBins)-repmat(binCenters(i,:),size(jointPos,1),1)),[],2); % This still works even if we include outliers, as those will get dumped into either the max or min bin
end

meanSpikeCount = zeros(numBins,numBins,size(spikeCounts,2),numJoints*(numJoints+1)/2,3);
for b = 1:3
    t = 0;
    idx = ceil(size(spikeCounts,1)*rand(size(spikeCounts,1),1));
for i = 1:numJoints
    for j = i+1:numJoints
        t = t+1;
        for m = 1:numBins
            for n = 1:numBins
                meanSpikeCount(m,n,:,t,b) = mean(spikeCounts(jointBins(idx,i) == m & jointBins(idx,j) == n,:));
            end
        end
    end
end
end


maxCount = max(max(max(max(max(meanSpikeCount)))));
for b = 1:3
    t = 0;
for i = 1:numJoints
    for j = i+1:numJoints
        t = t+1;
        for q = 1:size(spikeCounts,2)
            figure(q)
            subplot(3,numJoints*(numJoints-1)/2,t+(numJoints*(numJoints-1)/2*(b-1)))
            image(meanSpikeCount(:,:,q,t,b),'CDataMapping','scaled');
            caxis([0 maxCount])
            axis xy
            axis square
            title('Mean Firing Rate')
            xlabel(jointNames{i})
            ylabel(jointNames{j})
            colorbar
        end
    end
end
end