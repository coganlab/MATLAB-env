%  DST Field RT Diff Spectrogram Tasks panel
clear CondParams AnalParams CondDiff AnalDiff;
SessType = sessType(Sess);

fk = 200; tapers = [.5,5]; 

CondParams(1,1).Name = ['DRS' SessType 'zScoreRTSpectrogram']; 
CondParams(1,1).Task = {{'DelReachSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).IntervalName = 'ReachRT';
CondParams(1,1).IntervalDuration = [0,.5];
CondDiff.Task = CondParams(1,1).Task;
CondDiff.Cond = CondParams(1,1).conds;
CondDiff.IntervalName = 'ReachRT';
CondDiff.IntervalDuration = [0.5,1];

CondParams(1,1).Diff = CondDiff;

CondParams(2,1).Task = {{'DelReachSaccade'}};
CondParams(2,1).conds = {[Dirs(2)]};
CondParams(2,1).IntervalName = 'ReachRT';
CondParams(2,1).IntervalDuration = [0,.5];
CondDiff.Task = CondParams(2,1).Task;
CondDiff.Cond = CondParams(2,1).conds;
CondDiff.IntervalName = 'ReachRT';
CondDiff.IntervalDuration = [0.5,1];

CondParams(2,1).Diff = CondDiff;

AnalParams(1,1).Field = 'ReachGo';
AnalParams(1,1).bn = [-1e3,500];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).CLim = [-3,3];
AnalParams(1,1).Type = 'FieldzScoreSpectrogram';
AnalDiff.Field = 'ReachGo';
AnalDiff.bn = [-1e3,500];
AnalParams(1,1).Diff = AnalDiff;



