%  Field Field Memory Tasks panel
clear CondParams AnalParams;

fk = 100; tapers = [.5,5]; 
clim = [0.5,2]; coh_clim = [0,.7];
Norm.Task = ''; Norm.Cond = {[]};
Norm.bn = [-tapers(1)*1e3,0]; Norm.Field = 'TargsOn';

CondParams(1,1).Name = ['MemoryDelayFieldField']; 

CondParams(1,1).Norm = Norm;
CondParams(1,1).Task = {{'MemoryReachSaccade','DelReachSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,2).Norm = Norm;
CondParams(1,2).Task = CondParams(1,1).Task;
CondParams(1,2).conds = {[Dirs(2)]};
% 
CondParams(2,1).Task = {{'MemorySaccadeTouch','DelSaccadeTouch'}};
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,2).Task = CondParams(2,1).Task;
CondParams(2,2).conds = {[Dirs(2)]};

AnalParams(1,1).Type = 'Field1NormalizedSpectrogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).CLim = clim;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-500,1e3];

AnalParams(3,1) = AnalParams(1,1);
AnalParams(3,1).Type = 'Coherogram';
AnalParams(3,1).CLim = coh_clim;
AnalParams(3,2) = AnalParams(1,2);
AnalParams(3,2).Type = 'Coherogram';
AnalParams(3,2).CLim = coh_clim;

AnalParams(2,1) = AnalParams(1,1);
AnalParams(2,1).Type = 'Field2NormalizedSpectrogram';
AnalParams(2,2) = AnalParams(1,2);
AnalParams(2,2).Type = 'Field2NormalizedSpectrogram';
