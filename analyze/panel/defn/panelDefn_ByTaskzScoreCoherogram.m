clear CondParams AnalParams;

fk = 100; 
tapers = [.5,15]; 
clim = [0.5,2]; 
zclim = [0,3];

CondParams(1,1).Name = 'ByTaskzScoreCoherogram';
%%{[Dirs(2)]};

CondParams(1,1).Task = {{'DelReachFix'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).condstype = 'Movement';
CondParams(1,1).Choice = 1;
CondParams(1,1).Diff = CondParams(1,1);
CondParams(1,1).Diff.Task = {{'DelSaccadeTouch'}};
CondParams(1,1).Diff.Cond = {[Dirs(1)]};

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = 'zScoreCoherogram';
%AnalParams(1,1).CLim = zclim;
AnalParams(1,1).Diff = AnalParams(1,1);


AnalParams(1,2).Field = 'EffInstOn';
AnalParams(1,2).bn = [-1e3,1e3];
AnalParams(1,2).fk = fk;
AnalParams(1,2).tapers = tapers;
AnalParams(1,2).Type = 'zScoreCoherogram';
%AnalParams(1,2).CLim = zclim;
AnalParams(1,2).Diff = AnalParams(1,2);




