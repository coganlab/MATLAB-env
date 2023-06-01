%  Field Spectrogram for Reward Value Plots
clear CondParams AnalParams;

middle_value = 290;
fk = 200; tapers = [.3,5];
CondParams(1,1).Task = 'DelSaccadeTouch';
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).sort{1} = {'MovementDirection',Dirs(1)};
CondParams(1,1).sort{2} = {'CorrectChoice',1};
CondParams(1,1).sort{3} = {'HighRewardValue',320};
CondParams(1,2).Task = CondParams(1,1).Task;
CondParams(1,2).conds = {[Dirs(1)]};
CondParams(1,2).sort{1} = {'MovementDirection',Dirs(1)};
CondParams(1,2).sort{2} = {'CorrectChoice',1};
CondParams(1,2).sort{3} = {'HighRewardValue',middle_value};
CondParams(1,3).Task = CondParams(1,1).Task;
CondParams(1,3).conds = {[Dirs(1)]};
CondParams(1,3).sort{1} = {'MovementDirection',Dirs(1)};
CondParams(1,3).sort{2} = {'CorrectChoice',1};
CondParams(1,3).sort{3} = {'HighRewardValue',275};


CondParams(2,1).Task = 'DelSaccadeTouch';
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,1).sort{1} = {'MovementDirection',Dirs(1)};
CondParams(2,1).sort{2} = {'CorrectChoice',0};
CondParams(2,1).sort{3} = {'HighRewardValue',320};
CondParams(2,2).Task = CondParams(1,1).Task;
CondParams(2,2).conds = {[Dirs(1)]};
CondParams(2,2).sort{1} = {'MovementDirection',Dirs(1)};
CondParams(2,2).sort{2} = {'CorrectChoice',0};
CondParams(2,2).sort{3} = {'HighRewardValue',middle_value};
CondParams(2,3).Task = CondParams(1,1).Task;
CondParams(2,3).conds = {[Dirs(1)]};
CondParams(2,3).sort{1} = {'MovementDirection',Dirs(1)};
CondParams(2,3).sort{2} = {'CorrectChoice',0};
CondParams(2,3).sort{3} = {'HighRewardValue',275};

AnalParams(1,1).Type = 'FieldSpectrogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'EffInstOn';
AnalParams(1,2).bn = [-1e3,1e3];

AnalParams(2,1).Type = 'FieldNormalizedSpectrogram';
AnalParams(2,1).Field = AnalParams(1,1).Field;
AnalParams(2,1).bn = AnalParams(1,1).bn;
AnalParams(2,1).fk = fk;
AnalParams(2,1).tapers = tapers;

Norm.Task = ''; Norm.Cond = {[]}; 
Norm.bn = [-tapers(1)*1e3,0]; Norm.Field = 'TargsOn';
AnalParams(2,1).Norm = Norm;
AnalParams(2,1).CLim = [0.5,2];
 
AnalParams(2,2) = AnalParams(2,1);
AnalParams(2,2).Field = AnalParams(1,2).Field;
AnalParams(2,2).bn = AnalParams(1,2).bn;

