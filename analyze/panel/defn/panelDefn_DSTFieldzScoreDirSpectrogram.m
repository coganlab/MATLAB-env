%  DST Differential Direction Spectrogram Tasks panel
clear CondParams AnalParams CondDiff AnalDiff;
SessType = sessType(Sess);

fk = 200; tapers = [.5,5]; 

CondParams(1,1).Name = ['DST' SessType 'zScoreDirSpectrogram']; 
CondParams(1,1).Task = {{'DelSaccadeTouch'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondDiff.Task = CondParams(1,1).Task;
CondDiff.Cond = {[Dirs(2)]};
CondParams(1,1).Diff = CondDiff;

AnalParams(1,1).Field = 'Go';
AnalParams(1,1).bn = [-1e3,500];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = 'FieldzScoreSpectrogram';
AnalDiff.Field = 'Go';
AnalDiff.bn = [-1e3,500];
AnalParams(1,1).Diff = AnalDiff;


