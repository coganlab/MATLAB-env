function RewardDifference = calcRewardDifferenceForChosenTarget(Trials)
%
%  RewardDifference = calcRewardDifferenceForChosenTarget(Trials)
%
%  RewardDifference is Trials.RewardDist(1) - Trials.RewardDist(2);

nReward = size(Trials(1).RewardVolumeDist,2);
RD = reshape([Trials.RewardVolumeDist],[nReward,length(Trials)]);
RewardDifference = -diff(RD(1:2,:),1,1);

chosenLocation = reshape([ Trials.SaccadeChoiceContinuousLocation ]',2,length(Trials))';
T1T2Locations = [ Trials.T1T2Locations ];
T2Location = reshape(T1T2Locations(2,:)',2,length(Trials))';

choseT2locs = find(sum(chosenLocation==T2Location,2)==2);
RewardDifference(choseT2locs) = -RewardDifference(choseT2locs);

% for i=1:length(Trials)
%   if ismember(Trials(i).SaccadeChoiceContinuousLocation,Trials(i).T1T2Locations(2,:),'rows')
%     RewardDifference(i) = -RewardDifference(i);  
%   end
% end