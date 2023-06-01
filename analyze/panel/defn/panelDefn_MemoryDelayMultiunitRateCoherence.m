%  Memory and Delay SpikeRate and Coherence Tasks panel
clear CondParams AnalParams;

fk = 200; tapers = [.5,15]; 
coh_clim = [0,.2];

CondParams(1,1).Name = 'MemoryDelayMultiunitRateCoherence';

CondParams(1,1).Task = {{'MemoryReachSaccade','DelReachSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,2).Task = CondParams(1,1).Task;
CondParams(1,2).conds = {[Dirs(2)]};

CondParams(2,1).Task = {{'MemorySaccadeTouch','DelSaccadeTouch'}};
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,2).Task = CondParams(2,1).Task;
CondParams(2,2).conds = {[Dirs(2)]};

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = 'Coherogram';
AnalParams(1,1).CLim = coh_clim;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-500,1e3];

AnalParams(2,1).Field = 'TargsOn';
AnalParams(2,1).bn = [-500,1e3];
AnalParams(2,1).Smoothing = 30;
AnalParams(2,1).Type = 'SpikeRate';

AnalParams(2,2) = AnalParams(2,1);
AnalParams(2,2).Field = 'SaccStart';
AnalParams(2,2).bn = [-500,1e3];
