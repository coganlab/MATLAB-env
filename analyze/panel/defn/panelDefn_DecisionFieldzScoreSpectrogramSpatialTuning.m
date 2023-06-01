clear CondParams AnalParams;

CondParams(1,1).Name = 'DecisionFieldzScoreSpectogramSpatialTuning';
CondParams(1,1).Task = {{'DelSaccadeTouch'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).condstype = 'Movement';
CondParams(1,1).Choice = 1;

CondParams(1,1).Diff.Task = {{'DelSaccadeTouch'}};
CondParams(1,1).Diff.Cond = {[Dirs(2)]};
CondParams(1,1).Diff.condstype = 'Movement';
CondParams(1,1).Diff.Choice = 1;


CondParams(2,1) = CondParams(1,1);
CondParams(2,1).Task = {{'DelReachFix'}};
CondParams(2,1).conds = {[Dirs(1)]};
CondParams(2,1).condstype = 'Movement';

CondParams(2,1).Diff.Task = {{'DelReachFix'}};
CondParams(2,1).Diff.Cond = {[Dirs(2)]};
CondParams(2,1).Diff.condstype = 'Movement';
CondParams(2,1).Diff.Choice = 1;



AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500, 1e3];
AnalParams(1,1).tapers = [0.5, 15];
AnalParams(1,1).fk = 100;
AnalParams(1,1).Type = 'FieldzScoreSpectrogram';

AnalParams(1,2).Field = 'EffInstOn';
AnalParams(1,2).bn = [-1e3, 1e3];
AnalParams(1,2).tapers = [0.5, 15];
AnalParams(1,2).fk = 100;
AnalParams(1,2).Type = 'FieldzScoreSpectrogram';


