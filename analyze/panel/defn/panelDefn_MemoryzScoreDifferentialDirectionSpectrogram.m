%  Memory Normalized Spectrogram Tasks panel
clear CondParams AnalParams;
SessType = sessType(Sess);

fk = 200; tapers = [.5,5]; 
clim = [-5,5]; 
AnalNorm.bn = [-500, 1e3];

CondParams(1,1).Name = ['Memory' SessType 'zScoreDifferentialDirectionSpectrogram']; 
CondParams(1,1).Task = {{'MemoryReachSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondDiff.Task = {{'MemoryReachSaccade'}};
CondDiff.Cond = {[Dirs(2)]};
CondParams(1,1).Diff = CondDiff;

CondParams(2,1).Task = {{'MemorySaccadeTouch'}};
CondParams(2,1).conds = {[Dirs(1)]};
CondNorm.Task = {{'MemorySaccadeTouch'}};
CondNorm.Cond = {[Dirs(2)]};
CondParams(2,1).Diff = CondDiff;

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = [SessType 'zScoreSpectrogram'];
AnalParams(1,1).CLim = clim;
AnalNorm.Field = 'TargsOn';
AnalParams(1,1).Norm = AnalNorm;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-500,1e3];
AnalParams(1,2).Type = [SessType 'zScoreSpectrogram'];
AnalParams(1,2).CLim = clim;
AnalNorm.Field = 'SaccStart';
AnalParams(1,2).Norm = AnalNorm;

