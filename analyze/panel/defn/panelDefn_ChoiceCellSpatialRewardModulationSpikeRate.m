% Individual Coherent Decision Cells
% Gene Test Stuff
clear CondParams AnalParams;

TASKS = {{'DelSaccadeTouch','DelReachFix', 'DelReachSaccade'}};

fk = 200; tapers = [.3,5];
CondParams(1,1).Name = ['CohCellSpatialRewardModulationSpikeRate']; 
CondParams(1,1).Task = TASKS;
CondParams(1,1).Choice = 1;
CondParams(1,1).conds = {[]};
%CondParams(1,1).condstype = {'Movement'};
CondParams(1,1).sort{1} = {'CorrectChoice',1};
CondParams(1,1).sort{2} = {'HighRewardValue',320};
CondParams(1,1).sort{3} = {'MovementDirection',Dirs(1)};

CondParams(1,2) = CondParams(1,1);
CondParams(1,2).sort{3} = {'MovementDirection',Dirs(2)};

CondParams(2,1) = CondParams(1,1);
CondParams(2,1).sort{2} = {'HighRewardValue',275};

CondParams(2,2) = CondParams(2,1);
CondParams(2,2).sort{3} = {'MovementDirection',Dirs(2)};


AnalParams(1,1).Type = 'SpikeRate';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;

