function lowReward = getLowReward(trials)
%
%  lowReward =getLowReward(trials)
%
% For a 2T reward magnitude task, gets the low reward value
%

reward_dist = [trials.RewardDist];
reward_dist = reshape(reward_dist, 4, length(trials));
lowReward = min(reward_dist(1,:), reward_dist(2,:))';