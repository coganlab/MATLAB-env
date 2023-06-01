clear CondParams AnalParams;

TASKS = {{'DelSaccadeTouch', 'DelReachFix', 'DelReachSaccade'}};
shuffle = 0;
CondParams(1,1).Name = 'DecisionFieldSpectogramRewardModulationAllEpochs';
CondParams(1,1).Task = TASKS;
CondParams(1,1).conds = {[]};
CondParams(1,1).Choice = 1;
CondParams(1,1).shuffle = shuffle;


AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500, 1e3];
AnalParams(1,1).tapers = [0.5, 15];
AnalParams(1,1).fk = 100;
AnalParams(1,1).Type = 'FieldNormalizedSpectrogram';


AnalParams(1,2).Field = 'EffInstOn';
AnalParams(1,2).bn = [-500, 1e3];
AnalParams(1,2).tapers = [0.5, 15];
AnalParams(1,2).fk = 100;
AnalParams(1,2).Type = 'FieldNormalizedSpectrogram';


AnalParams(1,3).Field = 'TargAq';
AnalParams(1,3).bn = [-1e3, 500];
AnalParams(1,3).tapers = [0.5, 15];
AnalParams(1,3).fk = 100;
AnalParams(1,3).Type = 'FieldNormalizedSpectrogram';





