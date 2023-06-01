%  Field Spectrogram Choice Tasks panel
clear CondParams AnalParams;

fk = 200; tapers = [.5,5];

CondParams(1,1).Name = ['ChoiceFieldNormalizedSpectrogram']; 

CondParams(1,1).Task = {{'DelReachSaccade'}};
CondParams(1,1).conds = {[Dirs(1)]};
CondParams(1,1).IntervalName = 'Delay';
%CondParams(1,1).IntervalDuration = [0 1500];
CondParams(1,1).Delay = [0 1500];
% Subset choice trials
CondParams(1,1).Choice = 1;
% Select trials based on actual movement direction not target
CondParams(1,1).condstype = 'Movement';

CondParams(2,1) = CondParams(1,1);
CondParams(2,1).conds = {[Dirs(2)]};
CondParams(2,1).Choice = 1;
CondParams(2,1).condstype = 'Movement';

AnalParams(1,1).Type = 'FieldNormalizedSpectrogram';
AnalParams(1,1).Field = 'TargsOn';
AnalParams(1,1).bn = [-500,1000];
AnalParams(1,1).fk = fk;
AnalParams(1,1).tapers = tapers;
 
AnalParams(1,2) = AnalParams(1,1);
AnalParams(1,2).Field = 'EffInstOn';
AnalParams(1,2).bn = [-1000,1e3];

AnalParams(1,3) = AnalParams(1,1);
AnalParams(1,3).Field = 'Go';
AnalParams(1,3).bn = [-500,1e3];
