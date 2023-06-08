%  Field Spectrogram SOA panel
clear CondParams AnalParams;

fk = 200; tapers = [.3,5];
CondParams(1,1).Task = 'SOA';
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).IntervalName = 'SOA';
CondParams(1,1).IntervalDuration = [0 100];
CondParams(1,2).Task = CondParams(1,1).Task;
CondParams(1,2).conds = {[Dirs(2)]};
CondParams(1,2).IntervalName = CondParams(1,1).IntervalName;
CondParams(1,2).IntervalDuration = CondParams(1,1).IntervalDuration;

CondParams(2,1).Task = 'SOA';
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,1).IntervalName = 'SOA';
CondParams(2,1).IntervalDuration = [500 1000];
CondParams(2,2).Task = CondParams(2,1).Task;
CondParams(2,2).conds = {[Dirs(2)]};
CondParams(2,2).IntervalName = CondParams(2,1).IntervalName;
CondParams(2,2).IntervalDuration = CondParams(2,1).IntervalDuration;

AnalParams(1,1).Type = 'FieldSpectrogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-1e3,1e3];

AnalParams(2,1).Type = 'FieldNormalizedSpectrogram';
AnalParams(2,1).Field = AnalParams(1,1).Field;
AnalParams(2,1).bn = AnalParams(1,1).bn;
AnalParams(2,1).fk = fk;
AnalParams(2,1).tapers = tapers;

Norm.Task = ''; Norm.Cond = {[]}; 
Norm.bn = [-tapers(1)*1e3,0]; Norm.Field = 'TargsOn';
AnalParams(2,1).Norm = Norm;
AnalParams(2,1).CLim = [0.5,2];
 
AnalParams(2,2) = AnalParams(2,1);
AnalParams(2,2).Field = AnalParams(1,2).Field;
AnalParams(2,2).bn = AnalParams(1,2).bn;