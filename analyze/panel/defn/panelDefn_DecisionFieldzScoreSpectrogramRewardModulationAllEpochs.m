clear CondParams AnalParams;

TASKS = {{'DelSaccadeTouch', 'DelReachFix'}};

CondParams(1,1).Name = 'DecisionFieldSpectogramRewardModulationAllEpochs';
CondParams(1,1).Task = TASKS;
CondParams(1,1).conds = {[]};
CondParams(1,1).Choice = 1;
CondParams(1,1).sort{1} = {'CorrectChoice',1};
CondParams(1,1).sort{2} = {'HighRewardValue',320};
CondParams(1,1).sort{3} = {'MovementDirection',Dirs(1)};

CondParams(2,1).Task = TASKS;
CondParams(2,1).conds = {[]};
CondParams(2,1).Choice = 1;
CondParams(2,1).sort{1} = {'CorrectChoice',1};
CondParams(2,1).sort{2} = {'HighRewardValue',275};
CondParams(2,1).sort{3} = {'MovementDirection',Dirs(2)};

CondParams(3,1).Task = TASKS;
CondParams(3,1).conds = {[]};
CondParams(3,1).Choice = 1;
CondParams(3,1).sort{1} = {'CorrectChoice',1};
CondParams(3,1).sort{2} = {'HighRewardValue',320};
CondParams(3,1).sort{3} = {'MovementDirection',Dirs(1)};

CondParams(4,1).Task = TASKS;
CondParams(4,1).conds = {[]};
CondParams(4,1).Choice = 1;
CondParams(4,1).sort{1} = {'CorrectChoice',1};
CondParams(4,1).sort{2} = {'HighRewardValue',275};
CondParams(4,1).sort{3} = {'MovementDirection',Dirs(2)};



AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500, 1e3];
AnalParams(1,1).tapers = [0.5, 15];
AnalParams(1,1).fk = 100;
AnalParams(1,1).Type = 'FieldNormalizedSpectrogram';

AnalParams(1,1).Field = 'EffInstOn';
AnalParams(1,1).bn = [-500, 1e3];
AnalParams(1,1).tapers = [0.5, 15];
AnalParams(1,1).fk = 100;
AnalParams(1,1).Type = 'FieldNormalizedSpectrogram';

AnalParams(1,1).Field = 'TargAq';
AnalParams(1,1).bn = [-1e3, 500];
AnalParams(1,1).tapers = [0.5, 15];
AnalParams(1,1).fk = 100;
AnalParams(1,1).Type = 'FieldNormalizedSpectrogram';





