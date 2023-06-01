%  Field Field Memory Tasks panel
clear CondParams AnalParams;

fk = 100; tapers = [.5,5]; 
clim = [0.5,2]; coh_clim = [0,1];
Norm.Task = ''; Norm.Cond = {[]};
Norm.bn = [-tapers(1)*1e3,0]; Norm.Field = 'TargsOn';

CondParams(1,1).Task = 'MemoryReachSaccade';
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,2).Task = CondParams(1,1).Task;
CondParams(1,2).conds = {[Dirs(2)]};

CondParams(2,1).Task = 'MemorySaccadeTouch';
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,2).Task = CondParams(2,1).Task;
CondParams(2,2).conds = {[Dirs(2)]};

AnalParams(1,1).Type = 'Field1Spectrogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-1e3,1e3];

AnalParams(3,1) = AnalParams(1,1);
AnalParams(3,1).Type = 'Field2Spectrogram';
AnalParams(3,2) = AnalParams(1,2);
AnalParams(3,2).Type = 'Field2Spectrogram';

AnalParams(5,1) = AnalParams(1,1);
AnalParams(5,1).Type = 'Coherogram';
AnalParams(5,1).CLim = coh_clim;
AnalParams(5,2) = AnalParams(1,2);
AnalParams(5,2).Type = 'Coherogram';
AnalParams(5,2).CLim = coh_clim;

AnalParams(2,1) = AnalParams(1,1);
AnalParams(2,1).Type = 'Field1NormalizedSpectrogram';
AnalParams(2,1).Norm = Norm; AnalParams(2,1).CLim = clim;
AnalParams(2,2) = AnalParams(2,1);
AnalParams(2,2).Field = 'SaccStart';
AnalParams(2,2).bn = [-1e3,1e3];

AnalParams(4,1) = AnalParams(2,1);
AnalParams(4,1).Type = 'Field2NormalizedSpectrogram';
AnalParams(4,2) = AnalParams(2,2);
AnalParams(4,2).Type = 'Field2NormalizedSpectrogram';


