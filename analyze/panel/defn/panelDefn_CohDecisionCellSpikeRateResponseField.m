% 
% Gene Test Stuff
clear CondParams AnalParams;

TASKS = {{'DelSaccadeTouch','DelReachFix'}};

fk = 200; 
tapers = [.3,5];
CondParams(1,1).Name = ['CohDecisionCellSpikeRateResponseField']; 
CondParams(1,1).Task = TASKS;
CondParams(1,1).Choice = 1;
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).condstype = 'Movement';
CondParams(1,2) = CondParams(1,1);
CondParams(1,2).conds = {[Dirs(2)]};


AnalParams(1,1).Type = 'SpikeRate';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).Smoothing = [20];

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).bn = [-1e3,1e3];
AnalParams(1,2).Field = 'EffInstOn';



