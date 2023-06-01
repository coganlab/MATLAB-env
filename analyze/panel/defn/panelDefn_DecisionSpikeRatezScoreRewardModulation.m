
clear CondParams AnalParams;

TASKS = {{'DelSaccadeTouch', 'DelReachSaccade', 'DelReachFix'}};

CondParams(1,1).Name = 'DecisionSpikeRatezScoreRewardModulation';
CondParams(1,1).Task = TASKS;
CondParams(1,1).conds = {[]};
%CondParams(1,1).condstype = 'Movement';
CondParams(1,1).sort{1} = {'CorrectChoice',1};
CondParams(1,1).sort{2} = {'HighRewardValue',320};
CondParams(1,1).sort{3} = {'MovementDirection',Dirs(1)};

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500, 1e3];
AnalParams(1,1).Smoothing = [10];
AnalParams(1,1).Type = 'SpikeRatezScore';

CondParams(1,1).Diff.Task = TASKS;
CondParams(1,1).Diff.Cond = {[]};
CondParams(1,1).Diff.sort{1} = {'CorrectChoice',1};
CondParams(1,1).Diff.sort{2} = {'HighRewardValue',275};
CondParams(1,1).Diff.sort{3} = {'MovementDirection',Dirs(1)};



