function rewardReceived = calcRewardReceived(trials)
%
%  rewardReceived = calcRewardReceived(trials)

ReachCode = 10;
SaccadeCode = 12;
ReachSaccadeCode = 13;

reward_dur = [trials.RewardDur];
reward_dur = reshape(reward_dur, 4, length(trials))';

task_code = [trials.TaskCode];
saccade_choice = [trials.SaccadeChoice];
reach_choice = [trials.ReachChoice];
ReachCircleTarget = [trials.ReachCircleTarget ];
SaccadeCircleTarget = [trials.SaccadeCircleTarget ];
reach_circle_chosen = (ReachCircleTarget == reach_choice);
saccade_circle_chosen = (SaccadeCircleTarget == saccade_choice);

%Need to vectorise
for iTrials = 1:length(trials)
    if(trials(iTrials).Choice == 1)
        rewardReceived(iTrials) = reward_dur(iTrials,1);
    else
        if(task_code(iTrials) == ReachCode || task_code(iTrials) == ReachSaccadeCode)
            if(reach_circle_chosen(iTrials))
                rewardReceived(iTrials) = reward_dur(iTrials,1);
            else
                rewardReceived(iTrials) = reward_dur(iTrials,2);
            end
        elseif(task_code(iTrials) == SaccadeCode)
            if(saccade_circle_chosen(iTrials))
                rewardReceived(iTrials) = reward_dur(iTrials,1);
            else
                rewardReceived(iTrials) = reward_dur(iTrials,2);
            end
        end
    end
end

rewardReceived = rewardReceived'
end