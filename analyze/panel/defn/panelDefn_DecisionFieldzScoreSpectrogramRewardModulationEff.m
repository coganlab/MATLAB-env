clear CondParams AnalParams;

CondParams(1,1).Name = 'DecisionFieldzScoreSpectogramRewardModulationEffector';
CondParams(1,1).Task = {{'DelSaccadeTouch'}};
CondParams(1,1).conds = {[]};
CondParams(1,1).Choice = 1;
CondParams(1,1).sort{1} = {'CorrectChoice',1};
CondParams(1,1).sort{2} = {'HighRewardValue',320};
CondParams(1,1).sort{3} = {'MovementDirection',Dirs(1)};

CondParams(1,1).Diff.Task = {{'DelSaccadeTouch'}};
CondParams(1,1).Diff.Cond = {[]};
CondParams(1,1).Diff.Choice = 1;
CondParams(1,1).Diff.sort{1} = {'CorrectChoice',1};
CondParams(1,1).Diff.sort{2} = {'HighRewardValue',275};
CondParams(1,1).Diff.sort{3} = {'MovementDirection',Dirs(1)};

CondParams(1,2) = CondParams(1,1);
CondParams(1,2).sort{3} = {'MovementDirection', Dirs(2)};
CondParams(1,2).Diff.sort{3} = {'MovementDirection',Dirs(2)};


CondParams(1,3).Task = {{'DelReachFix'}};
CondParams(1,3).conds = {[]};
CondParams(1,3).Choice = 1;
CondParams(1,3).sort{1} = {'CorrectChoice',1};
CondParams(1,3).sort{2} = {'HighRewardValue',320};
CondParams(1,3).sort{3} = {'MovementDirection',Dirs(1)};

CondParams(1,3).Diff.Task = {{'DelReachFix'}};
CondParams(1,3).Diff.Cond = {[]};
CondParams(1,3).Diff.Choice = 1;
CondParams(1,3).Diff.sort{1} = {'CorrectChoice',1};
CondParams(1,3).Diff.sort{2} = {'HighRewardValue',275};
CondParams(1,3).Diff.sort{3} = {'MovementDirection',Dirs(1)};

CondParams(1,4) = CondParams(1,3);
CondParams(1,4).sort{3} = {'MovementDirection', Dirs(2)};
CondParams(1,4).Diff.sort{3} = {'MovementDirection',Dirs(2)};



AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500, 1e3];
AnalParams(1,1).tapers = [0.5, 15];
AnalParams(1,1).fk = 100;
AnalParams(1,1).Type = 'FieldzScoreSpectrogram';


AnalParams(1,2).Field = 'EffInstOn';
AnalParams(1,2).bn = [-500, 1e3];
AnalParams(1,2).tapers = [0.5, 15];
AnalParams(1,2).fk = 100;
AnalParams(1,2).Type = 'FieldzScoreSpectrogram';



