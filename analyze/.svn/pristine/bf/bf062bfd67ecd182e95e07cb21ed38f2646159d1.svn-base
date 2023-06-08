% 
% Gene Test Stuff
clear CondParams AnalParams;

TASKS = {{'DelSaccadeTouch','DelReachFix', 'DelReachSaccade'}};

CondParams(1,1).Name = ['ChoiceCellsSpatialTuningDecimatedSpikeRate']; 
CondParams(1,1).Task = TASKS;
CondParams(1,1).Choice = 1;
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).condstype = 'Movement';

CondParams(1,2) = CondParams(1,1);
CondParams(1,2).conds = {[Dirs(2)]};

AnalParams(1,1).Type = 'DecimateSpikeRate';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).Smoothing = [20];
AnalParams(1,1).p = 0.5;

AnalParams(2,1).Type = 'SpikeRate';
AnalParams(2,1).Field = 'TargsOn';
AnalParams(2,1).bn = [-500,1e3];
AnalParams(2,1).Smoothing = [20];
AnalParams(2,1).p = 0.5;



