%  Multiunit Spectrogram DST Tasks panel
clear CondParams AnalParams;

SessType = sessType(Sess);

CondParams(1,1).Name = ['DST' SessType 'RTRate']; 

CondParams(1,1).Task = {{'DelSaccadeTouch'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).IntervalName = 'SaccadeRT';
CondParams(1,1).IntervalDuration = [0,.5];
CondDiff.Task = CondParams(1,1).Task;
CondDiff.Cond = CondParams(1,1).conds;
CondDiff.IntervalName = 'SaccadeRT';
CondDiff.IntervalDuration = [0.5,1];

CondParams(1,1).Diff = CondDiff;

CondParams(2,1) = CondParams(1,1)
CondParams(2,1).conds = {[Dirs(2)]};

AnalParams(1,1).Type = 'SpikeRate';
AnalParams(1,1).Field = 'SaccadeGo';
AnalParams(1,1).bn = [-1e3,500];
AnalDiff.Field = 'SaccadeGo';
AnalDiff.bn = [-1e3,500];
AnalParams(1,1).Diff = AnalDiff;


