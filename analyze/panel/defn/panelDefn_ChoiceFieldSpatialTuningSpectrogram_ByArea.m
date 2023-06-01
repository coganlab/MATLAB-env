clear CondParams AnalParams;

fk = 100; 
tapers = [0.5,10];
clim = [0.5,2]; 
Norm.Task = ''; 
Norm.Cond = {[]};
Norm.bn = [-tapers(1)*1e3,0]; 
Norm.Field = 'TargsOn';

Diffbn = [-500,0];
DiffField = 'TargsOn';
DiffCond = {[]};
DiffTask = '';

CondParams(1,1).Name = 'ChoiceFieldSpatialTuningSpectrogram_ByArea';
%%{[Dirs(2)]};


CondParams(1,2).Task = {{'DelSaccadeTouch'}};
CondParams(1,2).conds = {[Dirs(1)]};
CondParams(1,2).Choice = 1;
CondParams(1,2).condstype = 'Movement';
%CondParams(1,2).sort{1} = {'MovementDirection', Dirs(1)};

CondParams(1,1) = CondParams(1,2);
CondParams(1,1).Task = {{'DelReachFix'}};


AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1e3];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = 'FieldNormalizedSpectrogram';
AnalParams(1,1).CLim = clim;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'EffInstOn';
AnalParams(1,2).bn = [-1e3,1e3];

AnalParams(2,1) = AnalParams(1,1);
AnalParams(2,1).Type = 'FieldSpectrogram';
AnalParams(2,1).CLim = [];

AnalParams(2,2) = AnalParams(1,2);
AnalParams(2,2).Type = 'FieldSpectrogram';
AnalParams(2,2).CLim = [];






