function target_choice = calcMovementDirection(trials, comparator);
%
% target_choice = calcMovementDirection(trials)
%

if nargin < 2
    comparator = -1;
end

ReachCode = 10;
SaccadeCode = 12;
ReachSaccadeCode = 13;
correct = zeros(1,length(trials));

task_code = [trials.TaskCode];
saccade_choice = [trials.SaccadeChoice];
reach_choice = [trials.ReachChoice];

%Lazy - Need to vectorise
target_choice = zeros(1,length(trials));
for i = 1:length(trials)
    if(task_code(i) == ReachCode || task_code(i) == ReachSaccadeCode) 
        target_choice(i) = reach_choice(i);
    elseif(task_code(i) == SaccadeCode) 
        target_choice(i) = saccade_choice(i);
    end
end

if(comparator > -1)
   target_choice = (target_choice == comparator);
end