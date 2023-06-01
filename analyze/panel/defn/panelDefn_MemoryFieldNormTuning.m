%  Memory and Delay Field Normalized Spectrogram Tasks panel
clear CondParams AnalParams;
SessType = 'Field';

fk = 100; tapers = [.5,5]; 
TuningLim = [-2,2];  NormLim = [.5,2];

Norm.Task = ''; Norm.Cond = {[]};
Norm.bn = [-tapers(1)*1e3,0]; Norm.Field = 'TargsOn';

CondParams(1,1).Name = 'MemoryFieldNormTuningSpectrogram';

CondParams(1,1).Task = {{'MemoryReachFix'}};
CondParams(1,1).conds = {[]};
%CondParams(1,2).Task = CondParams(1,1).Task;
%CondParams(1,2).conds = {[Dirs(2)]};

CondParams(2,1).Task = {{'MemorySaccadeTouch'}};
CondParams(2,1).conds = {[]};
%CondParams(2,2).Task = CondParams(2,1).Task;
%CondParams(2,2).conds = {[Dirs(2)]};

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = [SessType 'TuningSpectrogram'];
AnalParams(1,1).CLim = TuningLim;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'Go';
AnalParams(1,2).bn = [-750,1e3];
AnalParams(1,2).Type = [SessType 'TuningSpectrogram'];
AnalParams(1,2).CLim = TuningLim;

AnalParams(2,1) = AnalParams(1,1);
AnalParams(2,1).Type = [SessType 'NormalizedSpectrogram'];
AnalParams(2,1).CLim = NormLim;

AnalParams(2,2) = AnalParams(1,2);
AnalParams(2,2).Type = [SessType 'NormalizedSpectrogram'];
AnalParams(2,2).CLim = NormLim;


