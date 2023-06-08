%  Multiunit Spectrogram DST Tasks panel
clear CondParams AnalParams;

SessType = sessType(Sess);

CondParams(1,1).Name = ['DST' SessType 'DirRate']; 

CondParams(1,1).Task = {{'DelSaccadeTouch'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondDiff.Task = CondParams(1,1).Task;
CondDiff.Cond = {[Dirs(2)]};
CondParams(1,1).Diff = CondDiff;

AnalParams(1,1).Type = 'SpikeRate';
AnalParams(1,1).Field = 'Go';
AnalParams(1,1).bn = [-1e3,500];
AnalDiff.Field = 'Go';
AnalDiff.bn = [-1e3,500];
AnalParams(1,1).Diff = AnalDiff;
AnalParams(1,1).Smoothing = 30;


