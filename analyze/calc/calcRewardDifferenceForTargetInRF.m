function RewardDifference = calcRewardDifferenceForTargetInRF(Trials)
%
%  RewardDifference = calcRewardDifferenceForChosenTarget(Trials)
%

RewardDifference = [];
if length(Trials)>0
% Calculate Reward difference as (R_chosen - R_unchosen)
nReward = size(Trials(1).RewardVolumeDist,2);
RD = reshape([Trials.RewardVolumeDist],[nReward,length(Trials)]);
RewardDifference = -diff(RD(1:2,:),1,1); % assume T1 chosen, by default

chosenLocation = reshape([ Trials.SaccadeChoiceContinuousLocation ]',2,length(Trials))';
T1T2Locations = [ Trials.T1T2Locations ];
T2Location = reshape(T1T2Locations(2,:)',2,length(Trials))';
choseT2locs = find(sum(chosenLocation==T2Location,2)==2);
RewardDifference(choseT2locs) = -RewardDifference(choseT2locs);

% for i=1:length(Trials)
%   if ismember(Trials(i).SaccadeChoiceContinuousLocation,Trials(i).T1T2Locations(2,:),'rows')
%     RewardDifference(i) = -RewardDifference(i); % negate when T2 chosen
%   end
% end

% If the chosen target was out of the RF, negate Reward difference
chosenTargetInRFCode = [Trials.chosenTargetInRFCode];
outRFlocs = find(chosenTargetInRFCode==0);
RewardDifference(outRFlocs) = -RewardDifference(outRFlocs);

% If the chosen target was in an excluded area, set Reward difference = NaN;
nanLocs = find(chosenTargetInRFCode==-1);
RewardDifference(nanLocs) = NaN;
end