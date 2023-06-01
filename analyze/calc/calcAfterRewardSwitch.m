function rewardSwitch = AfterRewardSwitch(trials,comparator)
%
%  rewardSwitch = rewardSwitch(trials,comparator)
%

if  nargin < 2
    comparator = -1;
end
trials
tmp = [trials.RewardSwitchPoint];
tmp = reshape(tmp,2,length(trials));
rewardSwitch = tmp(1,:);

if(comparator > -1)
    rewardSwitch = (rewardSwitch == comparator);
end