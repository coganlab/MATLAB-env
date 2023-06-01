%  Memory and Delay Differential Coherence Tasks panel
clear CondParams AnalParams;

fk = 100; tapers = [.5,15]; 
coh_clim = [-.3,.3];

CondParams(1,1).Task = {{'MemoryReachSaccade','DelReachSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondDiff.Task = CondParams(1,1).Task;
CondDiff.conds = {[Dirs(2)]};
CondParams(1,1).Diff = CondDiff;

CondParams(2,1).Task = {{'MemorySaccadeTouch','DelSaccadeTouch'}};
CondParams(2,1).conds = {[Dirs(1)]};
CondDiff.Task = CondParams(2,1).Task;
CondDiff.conds = {[Dirs(2)]};
CondParams(2,1).Diff = CondDiff;

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = 'zScoreDiffCoherogram';
AnalParams(1,1).CLim = coh_clim;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-500,1e3];

