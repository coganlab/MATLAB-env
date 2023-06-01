%  Memory and Delay Spike Rate Tasks panel sortd by Reach Latency
clear CondParams AnalParams;
SessType = 'Spike';

CondParams(1,1).Task = {{'MemoryReachSaccade','DelReachSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).IntervalName = 'SaccadetoReachLatency';
CondParams(1,1).IntervalDuration = [0,0.5];

CondParams(1,2).Task = CondParams(1,1).Task;
CondParams(1,2).conds = {[Dirs(2)]};
CondParams(1,2).IntervalName = 'SaccadetoReachLatency';
CondParams(1,2).IntervalDuration = [0,0.5];

CondParams(2,1).Task = CondParams(1,1).Task;
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,1).IntervalName = 'SaccadetoReachLatency';
CondParams(2,1).IntervalDuration = [0.5,1];

CondParams(2,2).Task = CondParams(2,1).Task;
CondParams(2,2).conds = {[Dirs(2)]};
CondParams(2,2).IntervalName = 'SaccadetoReachLatency';
CondParams(2,2).IntervalDuration = [0.5,1];

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).Smoothing = 30;
AnalParams(1,1).Type = [SessType 'Rate'];

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-1e3,1e3];

