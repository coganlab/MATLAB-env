function rewardSwitch = calcBeforeRewardSwitch(trials,comparator)
%
%  rewardSwitch = rewardSwitch(trials,comparator)
%

if  nargin < 2
    comparator = -1;
end

tmp = [trials.RewardSwitchPoint];
tmp = reshape(tmp,2,length(trials));
rewardSwitch = tmp(2,:);

if(comparator > -1)
    rewardSwitch = (rewardSwitch == comparator);
end