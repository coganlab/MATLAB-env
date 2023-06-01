% Field Spectrogram Choice Tasks panel
% Gene Test Stuff
clear CondParams AnalParams;

fk = 200; 
tapers = [.5,5]; 
clim = [0.5,2]; 
Norm.Task = ''; 
Norm.Cond = {[]};
Norm.bn = [-tapers(1)*1e3,0]; 
Norm.Field = 'TargsOn';

TASKS = {{'DelSaccadeTouch', 'DelReachSaccade', 'DelReachFix'}};

CondParams(1,1).Name = 'DecisionRewardFieldSpectrogram'; 
CondParams(1,1).Task = TASKS;
CondParams(1,1).conds = {[]};
CondParams(1,1).sort{1} = {'CorrectChoice',1};
CondParams(1,1).sort{2} = {'HighRewardValue',320};
CondParams(1,1).sort{3} = {'MovementDirection',Dirs(1)};


CondParams(1,2).Task = CondParams(1,1).Task;
CondParams(1,2).conds = {[]};
CondParams(1,2).sort{1} = {'CorrectChoice',1};
CondParams(1,2).sort{2} = {'HighRewardValue',275};
CondParams(1,2).sort{3} = {'MovementDirection',Dirs(1)};



AnalParams(1,1).Type = 'FieldSpectrogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers; 

AnalParams(2,1).Type = 'FieldNormalizedSpectrogram';
AnalParams(2,1).Field = AnalParams(1,1).Field;
AnalParams(2,1).bn = AnalParams(1,1).bn;
AnalParams(2,1).fk = fk;
AnalParams(2,1).tapers = tapers;
AnalParams(2,1).Norm = Norm;
AnalParams(2,1).CLim = [0.5,2];
 

