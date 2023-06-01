%  Memory Saccade SFC Tasks panel
clear CondParams AnalParams;

fk = 200; tapers = [.5,5]; 
coh_clim = [0,0.3];

CondParams(1,1).Task = 'MemorySaccade';
CondParams(1,1).conds = {[]};

AnalParams(1,1).Type = 'Coherogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).CLim = coh_clim;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'SaccStart';
AnalParams(1,2).bn = [-1e3,1e3];



