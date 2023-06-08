%  Field Spectrogram Memory Tasks panel

fk = 100; tapers = [.5,5];
CondParams(1,1).Task = 'MemoryReachSaccade';
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,2).Task = CondParams(1,1).Task;
CondParams(1,2).conds = {[Dirs(2)]};

CondParams(2,1).Task = 'MemorySaccadeTouch';
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,2).Task = CondParams(2,1).Task;
CondParams(2,2).conds = {[Dirs(2)]};

AnalParams(1,1).Type = 'FieldSpectrogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1.5e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
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

%AnalParams(3,1).Type = 'PSTH';
%AnalParams(3,1).Field = AnalParams(1,1).Field;
%AnalParams(3,1).bn = AnalParams(1,1).bn;
%AnalParams(3,2).Type = 'PSTH';
%AnalParams(3,2).Field = AnalParams(1,2).Field;
%AnalParams(3,2).bn = AnalParams(1,2).bn;
