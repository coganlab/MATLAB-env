%  Delayed Saccade Spectrogram Tasks panel
clear CondParams AnalParams;

SessType = 'Field';
fk = 200;   % Number of frequencies to keep
tapers = [.5,5]; 


Norm.Task = ''; Norm.Cond = {[]};
Norm.bn = [-tapers(1)*1e3,0]; Norm.Field = 'TargsOn';

CondParams(1,1).Name = 'DSFieldSpectrogram';

CondParams(1,1).Task = {{'DelSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(2,1).Task = CondParams(1,1).Task;
CondParams(2,1).conds = {[Dirs(2)]};

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1000];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = [SessType 'Spectrogram'];
% 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-1e3,1e3];
AnalParams(1,2).Type = [SessType 'Spectrogram'];

