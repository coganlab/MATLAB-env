function rewardSwitch = calcNumberFromRewardSwitch(trials,comparator)
%
%  rewardSwitch = calcNumberFromRewardSwitch(trials,comparator)
%  gives distance from reward switch up and down

if  nargin < 2
    comparator = -1;
end

tmp = [trials.RewardSwitchPoint];
tmp = reshape(tmp,2,length(trials));
rewardSwitch = tmp(2,:);
afterswitch = tmp(1,:);
ind = find(afterswitch == 0);
ind(find(ind < 15)) = [];
ind(find(ind+15 > length(tmp))) = [];
for i = 1:15
    rewardSwitch(ind+i) = i;
end

if(comparator > -1)
    rewardSwitch = (rewardSwitch == comparator);
end