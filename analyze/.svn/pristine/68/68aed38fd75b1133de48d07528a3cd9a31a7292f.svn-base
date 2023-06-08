qfunction rewardSwitch = rewardSwitch(trials,comparator)
%
%  rewardSwitch = rewardSwitch(trials,comparator)
%

if  nargin < 2
    comparator = -1;
end

RewardBlock = [trials.EyeRewardBlock];
Blocks = find(abs(diff(RewardBlock)))';
rewardSwitch = NaN(1,length(trials));

% reward_dist = [trials.RewardDist];
% reward_dist = reshape(reward_dist, 4, length(trials))';

for iBlock = 1:length(Blocks)
    for i = 1:20
        if((Blocks(iBlock)-i) > 0)
            rewardSwitch([Blocks(iBlock)-i]) = -i;
        end
    end
    for i = 0:30
        if((Blocks(iBlock)+i) <= length(trials))
            rewardSwitch([Blocks(iBlock)+i]) = i;
        end
    end
    
end


if(comparator > -1)
    rewardSwitch = (rewardSwitch == comparator);
end