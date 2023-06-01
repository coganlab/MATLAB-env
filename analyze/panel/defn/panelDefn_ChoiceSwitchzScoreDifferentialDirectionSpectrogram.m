%  Memory and Delay Normalized Spectrogram Tasks panel
clear CondParams AnalParams CondDiff;
SessType = sessType(Sess);

fk = 200; %tapers = [.5,5]; 
tapers = [.5,5]; 
clim = [-5,5]; 
AnalNorm.bn = [-500, 1e3];

CondParams(1,1).Name = ['ChoiceSwitch' SessType 'zScoreDifferentialDirectionSpectrogram']; 
CondParams(1,1).Task = {{'DelReachSaccade','DelSaccadeTouch','DelReachFix'}};
CondParams(1,1).conds = {[Dirs(1)]};
% Subset choice trials
CondParams(1,1).Choice = 1;
% Subset trials based on reward switch point
CondParams(1,1).sort{1} = {'AfterRewardSwitch',[0,10]};
% Select trials based on actual movement direction not target
CondParams(1,1).condstype = 'Movement';
CondParams(1,1).shuffle = 0;

CondDiff.Task = CondParams(1,1).Task;
CondDiff.conds  = {[Dirs(2)]};
CondDiff.Choice = 1;
CondDiff.sort{1} = {'AfterRewardSwitch',[0,10]};
CondDiff.condstype = 'Movement';
CondDiff.shuffle = 0;
CondParams(1,1).Diff = CondDiff;

CondParams(2,1).Task = {{'DelReachSaccade','DelSaccadeTouch','DelReachFix'}};
CondParams(2,1).conds = {[Dirs(1)]};
% Subset trials based on reward switch point
CondParams(2,1).sort{1} = {'BeforeRewardSwitch',[-11,-1]};
% Subset choice trials
CondParams(2,1).Choice = 1;
% Select trials based on actual movement direction not target
CondParams(2,1).condstype = 'Movement';
CondParams(2,1).shuffle = 0;

CondDiff.Task = CondParams(2,1).Task;
CondDiff.conds  = {[Dirs(2)]};
CondDiff.Choice = 1;
CondDiff.sort{1} = {'BeforeRewardSwitch',[-11,-1]};
CondDiff.condstype = 'Movement';
CondDiff.shuffle = 0;
CondParams(2,1).Diff = CondDiff;

AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1000];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
AnalParams(1,1).Type = [SessType 'zScoreSpectrogram'];
AnalParams(1,1).CLim = clim;
AnalNorm.Field = 'TargsOn';
AnalParams(1,1).Norm = AnalNorm;
AnalParams(1,1).nPerm = 1e3;

AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'Go';
AnalParams(1,2).bn = [-1000,1e3];
AnalParams(1,2).Type = [SessType 'zScoreSpectrogram'];
AnalParams(1,2).CLim = clim;
AnalNorm.Field = 'Go';
AnalParams(1,2).Norm = AnalNorm;
AnalParams(1,2).nPerm = 1e3;

