% 
% Gene Test Stuff
clear CondParams AnalParams;

TASKS = {{'DelSaccadeTouch','DelReachFix'}};

CondParams(2,1).Name = ['ChoiceCellDecimateSpatialTuningCoherogram']; 
CondParams(2,1).Task = TASKS;
CondParams(2,1).Choice = 1;
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,1).condstype = 'Movement';

CondParams(1,1) = CondParams(2,1);
CondParams(1,1).conds = {[Dirs(2)]};


AnalParams(1,1).Type = 'DecimateNullzScoreCoherogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = 100;
AnalParams(1,1).p = p;

AnalParams(1,2).Type = 'DecimateNullzScoreCoherogram';
AnalParams(1,2).Field = 'EffInstOn';
AnalParams(1,2).bn = [-500,1e3];
AnalParams(1,2).fk = 100;
AnalParams(1,2).p = p;

