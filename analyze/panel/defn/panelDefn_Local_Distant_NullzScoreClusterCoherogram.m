clear CondParams AnalParams;

fk = 100; 
tapers = [0.5,10]; 
coh_clim = [0,0.1];

CondParams(1,1).Name = 'Local_Distant_NullzScoreClusterCoherogram';

CondParams(1,1).Task = {{'DelSaccadeTouch', 'DelReachFix'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).condstype = 'Movement';
CondParams(1,1).Choice = 1;

CondParams(1,2).Task = {{'DelSaccadeTouch', 'DelReachFix'}};
CondParams(1,2).conds = {[Dirs(2)]};
CondParams(1,2).condstype = 'Movement';
CondParams(1,2).Choice = 1;



AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = 'NullzScoreClusterCoherogram';
AnalParams(1,1).CLim = coh_clim;

AnalParams(1,2).Field = 'EffInstOn';
AnalParams(1,2).bn = [-1e3,1e3];
AnalParams(1,2).fk = fk;
AnalParams(1,2).tapers = tapers;
AnalParams(1,2).Type = 'NullzScoreClusterCoherogram';
AnalParams(1,2).CLim = coh_clim;

AnalParams(1,3).Field = 'TargAq';
AnalParams(1,3).bn = [-1e3,500];
AnalParams(1,3).fk = fk;
AnalParams(1,3).tapers = tapers;
AnalParams(1,3).Type = 'NullzScoreClusterCoherogram';
AnalParams(1,3).CLim = coh_clim;


AnalParams(2,1).Field = 'TargsOn';
AnalParams(2,1).bn = [-500,1e3];
AnalParams(2,1).fk = fk;
AnalParams(2,1).tapers = tapers;
AnalParams(2,1).Type = 'Coherogram';
AnalParams(2,1).CLim = coh_clim;

AnalParams(2,2).Field = 'EffInstOn';
AnalParams(2,2).bn = [-1e3,1e3];
AnalParams(2,2).fk = fk;
AnalParams(2,2).tapers = tapers;
AnalParams(2,2).Type = 'Coherogram';
AnalParams(2,2).CLim = coh_clim;

AnalParams(2,3).Field = 'TargAq';
AnalParams(2,3).bn = [-1e3,500];
AnalParams(2,3).fk = fk;
AnalParams(2,3).tapers = tapers;
AnalParams(2,3).Type = 'Coherogram';
AnalParams(2,3).CLim = coh_clim;


