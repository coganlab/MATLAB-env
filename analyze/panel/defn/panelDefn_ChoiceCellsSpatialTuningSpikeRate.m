% 
% Gene Test Stuff
clear CondParams AnalParams;

TASKS = {{'DelSaccadeTouch','DelReachFix', 'DelReachSaccade'}};

CondParams(2,1).Name = ['CohCellSpatialTuningSpikeRate']; 
CondParams(2,1).Task = TASKS;
CondParams(2,1).Choice = 1;
CondParams(2,1).conds = {[]};
CondParams(2,1).condstype = 'Movement';
CondParams(2,1).sort{1} = {'MovementDirection',Dirs(1)};


CondParams(1,1) = CondParams(2,1);
CondParams(1,1).conds = {[]};
CondParams(1,1).sort{1} = {'MovementDirection',Dirs(2)};




AnalParams(1,1).Type = 'SpikeRate';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).Smoothing = [20];

% AnalParams(1,2).Type = 'SpikeRate';
% AnalParams(1,2).Field = 'EffInstOn';
% AnalParams(1,2).bn = [-1e3,1e3];
% AnalParams(1,2).Smoothing = [20];
% 
