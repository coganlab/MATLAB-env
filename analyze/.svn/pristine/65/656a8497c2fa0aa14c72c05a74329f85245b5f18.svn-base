function RewardDifference = calcRewardDifference(Trials)
%
%  RewardDifference = calcRewardDifference(Trials)
%
%  RewardDifference is Trials.RewardDist(1) - Trials.RewardDist(2);

nReward = size(Trials(1).RewardDist,2);
RD = reshape([Trials.RewardDist],[nReward,length(Trials)]);
RewardDifference = -diff(RD(1:2,:),1,1);
