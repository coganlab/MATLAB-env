function [meanSpikeCount nlinSpikeCount numSpikeCount binCenters] = nlinPairJointRate(spikeCounts,jointPos,jointNames,jointCombo,posMin,posMax)
% Same as getPairJointRate, but also produces a tuning curve with linear
% tuning subtracted off, to highlight any nonlinearity

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
nlinSpikeCount = meanSpikeCount;
numSpikeCount = meanSpikeCount;
for t = 1:size(jointCombo,1)
    lin = spikeCounts'*pinv([binCenters(jointBins(:,jointCombo(t,:)))';ones(1,size(jointBins,1))]); % best linear fit mapping pairs of joint angles to firing rate
    for m = 1:numBins
        for n = 1:numBins
            meanSpikeCount(m,n,:,t) =  mean(spikeCounts(jointBins(:,jointCombo(t,1)) == m & jointBins(:,jointCombo(t,2)) == n,:));
            numSpikeCount(m,n,:,t)  = nnz(jointBins(:,jointCombo(t,1)) == m & jointBins(:,jointCombo(t,2)) == n);
            nlinSpikeCount(m,n,:,t) = squeeze(meanSpikeCount(m,n,:,t)) - lin*[binCenters(jointCombo(t,1),m); binCenters(jointCombo(t,2),n); 1];
        end
    end
end
nlinSpikeCount(numSpikeCount==0) = 0;