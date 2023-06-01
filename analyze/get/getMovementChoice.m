function MovementChoice = getMovementChoice(Trials)
%
% MovementChoice = getMovementChoice(Trials)
% Defaults to saccade movement for reach and sacc trials

ReachCode = 10;
SaccadeCode = 12;
ReachSaccadeCode = 13;


SaccadeChoice = [Trials.SaccadeChoice];
ReachChoice = [Trials.ReachChoice];
task = [Trials.TaskCode];

% Defaults to saccade movement for reach and sacc trials
MovementChoice = zeros(1,length(SaccadeChoice));
MovementChoice([task == SaccadeCode]) = SaccadeChoice([task == SaccadeCode]);
MovementChoice([task == ReachCode]) = ReachChoice([task == ReachCode]);
MovementChoice([task == ReachSaccadeCode]) = SaccadeChoice([task == ReachSaccadeCode]);
