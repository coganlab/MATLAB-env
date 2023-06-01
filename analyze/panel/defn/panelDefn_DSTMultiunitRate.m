%  Multiunit Spectrogram DST Tasks panel
clear CondParams AnalParams CondDiff AnalDiff;
SessType = sessType(Sess);

CondParams(1,1).Name = ['DST' SessType 'Rate']; 

CondParams(1,1).Task = {{'DelSaccadeTouch'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).IntervalName = 'Delay';
CondParams(1,1).IntervalDuration = [0,1500];

CondParams(2,1) = CondParams(1,1)
CondParams(2,1).conds = {[Dirs(2)]};

AnalParams(1,1).Type = 'SpikeRate';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).Smoothing = 30;


