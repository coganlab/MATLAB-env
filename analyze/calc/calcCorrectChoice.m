function correct = calcCorrectChoice(trials, tasktype, comparator)
%
%  correct = calcCorrectChoice(trials,comparator)
% tasktype = 3 (2T Task)
% tasktype = 6 (4T reward mag)

if  nargin < 2
    tasktype = 3;
    comparator = -1;
elseif  nargin < 3
    comparator = -1;
end

ReachCode = 10;
SaccadeCode = 12;
ReachSaccadeCode = 13;

% For 2T task 1 if circle is high reward
% For 4T task first row is the reach and the second row is the saccade: 1 -
% correct, 0 incorrect
averageHighReward = calcAverageHighReward(trials, tasktype);

correct = zeros(1,length(trials));

task_code = [trials.TaskCode];
saccade_choice = [trials.SaccadeChoice];
reach_choice = [trials.ReachChoice];
ReachCircleTarget = [trials.ReachCircleTarget];
SaccadeCircleTarget = [trials.SaccadeCircleTarget];
reach_circle_chosen = (ReachCircleTarget == reach_choice);
saccade_circle_chosen = (SaccadeCircleTarget == saccade_choice);
% 2T Task
if(tasktype == 3)
    %Need to vectorise
    for iTrials = 1:length(trials)
        if(task_code(iTrials) == ReachCode || task_code(iTrials) == ReachSaccadeCode)
            circle_chosen(iTrials) = reach_circle_chosen(iTrials);
        elseif(task_code(iTrials) == SaccadeCode)
            circle_chosen(iTrials) = saccade_circle_chosen(iTrials);
        end
    end
    correct = (circle_chosen == averageHighReward);
elseif(tasktype == 6) % 4T reward Mag
    reachAverageHighReward = (averageHighReward == 1) + (averageHighReward == 3);
    saccadeAverageHighReward = (averageHighReward == 1) + (averageHighReward == 2);   
    reach_correct = (reach_circle_chosen == reachAverageHighReward);
    saccade_correct = (saccade_circle_chosen == saccadeAverageHighReward);
    correct = [reach_correct; saccade_correct];
else
    error('Unknown task type')
end

if(comparator > -1)
   correct = (correct == comparator);
end