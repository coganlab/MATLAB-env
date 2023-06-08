clear CondParams AnalParams;

fk = 200; tapers = [.5,5]; 
clim = [0.5,2]; coh_clim = [0.5,2];
Norm.Task = ''; Norm.Cond = {[]};
Norm.bn = [-tapers(1)*1e3,0]; Norm.Field = 'TargsOn';

Diffbn = [-500,0]; 
DiffField = 'TargsOn';
DiffCond = {[]};
DiffTask = '';

CondParams(1,1).Name = 'DecisionLFPSpatialTuning';
%%{[Dirs(2)]};
TASKS = {{'DelSaccadeTouch', 'DelReachSaccade', 'DelReachFix'}};


CondParams(1,1).Task = TASKS;
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).condstype = 'Movement';
CondParams(1,1).Choice = 1;
CondParams(1,1).Diff.Task = DiffTask;
CondParams(1,1).Diff.conds = DiffCond;

CondParams(1,2) = CondParams(1,1);
CondParams(1,2).conds = {[Dirs(2)]};


AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = 'FieldNormalizedSpectrogram';
AnalParams(1,1).CLim = coh_clim;
AnalDiff.Field = DiffField;
AnalDiff.bn = Diffbn;
AnalParams(1,1).Diff = AnalDiff;
% 
 AnalParams(1,2) = AnalParams(1,1);
 AnalParams(1,2).Type = 'FieldSpectrogram';






