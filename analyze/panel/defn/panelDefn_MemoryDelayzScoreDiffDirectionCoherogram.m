%  Memory and Delay Differential Coherence Tasks panel
clear CondParams AnalParams CondDiff AnalDiff;
SessType = sessType(Sess);

fk = 200; tapers = [.5,5]; 
coh_clim = [-3,3];

CondParams(1,1).Name = ['MemoryDelay' SessType 'zScoreDiffDirectionCoherogram']; 
CondParams(1,1).Task = {{'MemoryReachSaccade','DelReachSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondDiff.Task = CondParams(1,1).Task;
CondDiff.Cond = {[Dirs(2)]};
CondParams(1,1).Diff = CondDiff;

CondParams(2,1).Task = {{'MemorySaccadeTouch','DelSaccadeTouch','DelSaccade'}};
CondParams(2,1).conds = {[Dirs(1)]};
CondDiff.Task = CondParams(2,1).Task;
CondDiff.Cond = {[Dirs(2)]};
CondParams(2,1).Diff = CondDiff;

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = 'zScoreCoherogram';
%AnalParams(1,1).CLim = coh_clim;
AnalDiff.Field = 'TargsOn';
AnalDiff.bn = [-500,1e3];
AnalParams(1,1).Diff = AnalDiff;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-500,1e3];
AnalDiff.Field = 'SaccStart';
AnalDiff.bn = [-500,1e3];
AnalParams(1,2).Diff = AnalDiff;

