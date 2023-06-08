function highReward = getHighReward(trials, tasktype)
%
%  highReward =getHighReward(trials, tasktype)
%
% For a 2T reward magnitude task, gets the high reward value
% tasktype = 3 (2T Task)
% tasktype = 6 (4T reward mag)

if  nargin < 2
    tasktype = 3;
end

reward_dist = [trials.RewardDist];
reward_dist = reshape(reward_dist, 4, length(trials))';
if(tasktype == 3)
    highReward = max(reward_dist(:,1), reward_dist(:,2))';
elseif(tasktype == 6)
    [highReward,ind] = max(reward_dist);
else
    error('Unknown task type')
end