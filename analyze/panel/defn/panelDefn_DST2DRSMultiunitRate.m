%  Field Spectrogram Memory Tasks panel
clear CondParams AnalParams CondDiff AnalDiff;

SessType = sessType(Sess);

CondParams(1,1).Name = ['DST2DRS' SessType 'Rate']; 

CondParams(1,1).Task = {{'DelSaccadeTouch'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).IntervalName = 'Delay';
CondParams(1,1).IntervalDuration = [0 1500];

CondParams(2,1) = CondParams(1,1);
CondParams(2,1).conds = {[Dirs(2)]};

CondParams(1,2).Task = {{'DST2DRS'}};
CondParams(1,2).conds = {[Dirs(1)]};
CondParams(1,2).IntervalName = 'SOADelay';
CondParams(1,2).IntervalDuration = [0 1500];

CondParams(2,2) = CondParams(1,2);
CondParams(2,2).conds = {[Dirs(2)]};

AnalParams(1,1).Type = 'SpikeRate';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,500];
AnalParams(1,1).Smoothing = 30;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'Targ2On';
AnalParams(1,2).bn = [-500,1e3];

AnalParams(1,3) = AnalParams(1,1);
AnalParams(1,3).Field = 'Go';
AnalParams(1,3).bn = [-500,1e3];


