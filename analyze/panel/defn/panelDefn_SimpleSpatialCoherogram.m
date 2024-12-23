clear CondParams AnalParams;

fk = 100; 
tapers = [.5,15]; 
clim = [0.5,2]; 
coh_clim = [0,0.1];

CondParams(1,1).Name = 'SimpleSpatialCoherogram';
%%{[Dirs(2)]};

CondParams(1,1).Task = {{'DelSaccadeTouch', 'DelReachFix'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).condstype = 'Movement';
CondParams(1,1).Choice = 1;



AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = 'Coherogram';
AnalParams(1,1).CLim = coh_clim;


AnalParams(1,2).Field = 'EffInstOn';
AnalParams(1,2).bn = [-1e3,1e3];
AnalParams(1,2).fk = fk;
AnalParams(1,2).tapers = tapers;
AnalParams(1,2).Type = 'Coherogram';
AnalParams(1,2).CLim = coh_clim;

