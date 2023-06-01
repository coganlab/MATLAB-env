%  Memory and Delay Normalized Spectrogram Tasks panel
clear CondParams AnalParams;
%SessType = sessType(Sess);
SessType = 'Field';
fk = 100; tapers = [.3,5]; 
clim = [-4,4]; 

CondParams(1,1).Name = ['MemorySaccade' SessType 'TuningSpectrogram']; 

CondParams(1,1).Task = {{'MemorySaccade'}};
CondParams(1,1).conds = {[]};

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = [SessType 'TuningSpectrogram'];
AnalParams(1,1).CLim = clim;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-500,1e3];
AnalParams(1,2).Type = [SessType 'TuningSpectrogram'];
AnalParams(1,2).CLim = clim;

