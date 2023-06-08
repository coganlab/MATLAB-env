function averageHighReward = calcAverageHighReward(trials, tasktype)
%
%  averageHighReward = calcAverageHighReward(trials)
%  Calculates the high reward target based on the mean of the trials in the
%  block not the actual reward for each trial (i.e. does not take into
%  account noise on the reward. For this value look in Trials.HighReward

% For the 2T Task: Returns 1 when the circle target is the higher value reward target and 0
% when the triangle is the higher value reward target.
% For the 4T Task: Returns the number of the combination that has the highest value 1 - HCEC, 2 - HTEC, 3 - HCET, 4 - HTET
% tasktype = 3 (2T Task)
% tasktype = 6 (4T reward mag)

if  nargin < 2
    tasktype = 3;
end

reward_dist = [trials.RewardDist];
reward_dist = reshape(reward_dist, 4, length(trials))';


if(tasktype == 3)
    high_reward = reward_dist(:,1) - reward_dist(:,2);
    high_reward(find(high_reward > 0)) = 1;
    high_reward(find(high_reward < 0)) = 0;
    averageHighReward = high_reward';
    %Hack to fix reward file misalignment - fixed in new verison of LabVIEW
    %Task Controller
    averageHighReward = [averageHighReward(2:end),averageHighReward(end)];
elseif(tasktype  == 6)
    [high_reward,averageHighReward] = max(reward_dist');
else
    error('Unknown task type')
end