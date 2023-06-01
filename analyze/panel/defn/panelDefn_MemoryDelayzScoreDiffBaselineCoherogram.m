%  Memory and Delay Differential Coherence Tasks panel
clear CondParams AnalParams CondDiff AnalDiff;

SessType = sessType(Sess);

fk = 200; tapers = [.5,15]; 
coh_clim = [-.3,.3];

Diffbn = [-500,0]; DiffField = 'TargsOn';
DiffCond = {[]}; DiffTask = '';

CondParams(1,1).Name = [SessType 'zScoreDiffBaselineCoherogram'];
CondParams(1,1).Task = {{'MemoryReachSaccade','DelReachSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).Diff.Task = DiffTask;
CondParams(1,1).Diff.conds = DiffCond;

CondParams(2,1).Task = {{'MemorySaccadeTouch','DelSaccadeTouch'}};
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,1).Diff.Task = DiffTask;
CondParams(2,1).Diff.conds = DiffCond;

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = 'zScoreCoherogram';
%AnalParams(1,1).CLim = coh_clim;
AnalDiff.Field = DiffField;
AnalDiff.bn = Diffbn;
AnalParams(1,1).Diff = AnalDiff;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-500,1e3];
AnalDiff.Field = DiffField;
AnalDiff.bn = Diffbn;
AnalParams(1,2).Diff = AnalDiff;

