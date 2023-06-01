%  Helper structure for Center-Out tuning analysis 

ind = 1;
CondParams = [];

CondParams(ind,1).Name = 'DelSaccade';
CondParams(ind,1).Task = 'DelSaccade';
% CondParams(ind,1).TuningFields = {'Baseline','CueTransient','CuePostTransient','EarlyDelay','PreSaccLateDelay','PreSaccTransient','PostSacc'};
CondParams(ind,1).Choice = 0;
CondParams(ind,1).shuffle = 0;
CondParams(ind,1).sort = [];
ind = ind + 1;

CondParams(ind,1) = CondParams(ind-1,1);
CondParams(ind,1).Name = 'MemorySaccade';
CondParams(ind,1).Task = 'MemorySaccade';
% CondParams(ind,1).TuningFields = {'Baseline','CueTransient','CuePostTransient','EarlyDelay','PreSaccLateDelay','PreSaccTransient','PostSacc'};
CondParams(ind,1).Choice = 0;
CondParams(ind,1).shuffle = 0;
CondParams(ind,1).sort = [];

ind = 1;
AnalParams = [];

AnalParams(ind,1).CalcTrig = 1;
AnalParams(ind,1).CalcVonMises = 1;
AnalParams(ind,1).Fields = {'TargsOn','Go','SaccStart'}; % used by PSTH code
AnalParams(ind,1).bn = [-2000 2000];   % used by PSTH code
AnalParams(ind,1).wlen = 0.3; % sliding window length
AnalParams(ind,1).dn = 0.05; % sliding window increment
AnalParams(ind,1).nPerm = 1e3;
ind = ind + 1;

AnalParams(ind,1) = AnalParams(ind-1,1);


% AnalParams(ind,1).HighThreshPct = 0.65; % 1-1/exp(1); % inRF exists where von mises density is above this threshold
% AnalParams(ind,1).LowThreshPct = 0.2; % 1/exp(1); % outRF exists where von mises density is below this threshold
%                                      % all other locations are uncategorized  
% Threshold parameters were chosen to yield a min in/out RF firing rate = 2,
% max # of excluded locations (out of 8) = 4, and a minimum RF/surround size ratio of 0.2.
% I confirmed these results in both animals using (now commented out) code in Plot_TuningSammary.
% AnalParams(ind,1).slidingWindowLengths = [ 20 60 100 300 500 ]; % used for sliding window analyses
% AnalParams(ind,1).slidingWindowIncrement = 20; % used for sliding window analyses
% AnalParams(ind,1).SelThresh = 2; % minimum selectivity (of trig moment) for unit to qualify as tuned 
% AnalParams(ind,1).PThresh = 0.05; % maximum p-value for unit to qualify as tuned
