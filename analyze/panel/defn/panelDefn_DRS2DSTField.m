%  Field Spectrogram Memory Tasks panel
clear CondParams AnalParams CondDiff AnalDiff;
CondParams(1,1).Name = 'DRS2DSTField';

fk = 200; tapers = [.3,5];


CondParams(1,1).Name = ['DRS2DSTField']; 

CondParams(1,1).Task = {{'DRS2DST'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).IntervalName = 'SOADelay';
CondParams(1,1).IntervalDuration = [0 1500];

CondParams(2,1) = CondParams(1,1)
CondParams(2,1).conds = {[Dirs(2)]};

AnalParams(1,1).Type = 'FieldNormalizedSpectrogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'Targ2On';
AnalParams(1,2).bn = [-1e3,1e3];

AnalParams(1,3) = AnalParams(1,1);
AnalParams(1,3).Field = 'SaccStart';
AnalParams(1,3).bn = [-500,1e3];
