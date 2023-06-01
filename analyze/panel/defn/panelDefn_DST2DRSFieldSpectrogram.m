%  Field Spectrogram DST2DRS Tasks panel
clear CondParams AnalParams;

fk = 200; tapers = [.5,5];

CondParams(1,1).Name = ['DST2DRSFieldSpectrogram']; 

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

AnalParams(1,1).Type = 'FieldSpectrogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,500];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'Targ2On';
AnalParams(1,2).bn = [-500,1e3];

AnalParams(1,3) = AnalParams(1,1);
AnalParams(1,3).Field = 'SaccStart';
AnalParams(1,3).bn = [-500,1e3];
