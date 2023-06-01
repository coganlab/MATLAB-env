%  Luminance-Reward Selection tasks helper structure
clear CondParams AnalParams;

neutralLogLumThresh = 0.1;
diffLogLumThresh = 0.05;

% if isequal(MONKEYNAME,'archie')
%   neutralLogLumThresh = 0.1;
%   diffLogLumThresh = 0.05;
% elseif isequal(MONKEYNAME,'spiff')
%   neutralLogLumThresh = 0.1;
%   diffLogLumThresh = 0.05;
% end

rowind = 1;
colind = 1;
CondParams = [];

CondParams(rowind,colind).Name = '- RewardDiff, - BrightDiff';
CondParams(rowind,colind).Task = 'DelSaccade';
CondParams(rowind,colind).Choice = 1;
CondParams(rowind,colind).shuffle = 0;
sortData = []; sortData{1} = 'RewardDifferenceForTargetInRF'; sortData{2} = [-Inf -0.001];
CondParams(rowind,colind).sort{1} = sortData;
sortData = []; sortData{1} = 'LuminanceDifferenceForTargetInRF'; sortData{2} = [-Inf -diffLogLumThresh];
CondParams(rowind,colind).sort{2} = sortData;
rowind = rowind+1;

CondParams(rowind,colind).Name = '0 RewardDiff, - BrightDiff';
CondParams(rowind,colind).Task = 'DelSaccade';
CondParams(rowind,colind).Choice = 1;
CondParams(rowind,colind).shuffle = 0;
sortData = []; sortData{1} = 'RewardDifferenceForTargetInRF'; sortData{2} = [-0.001 0.001];
CondParams(rowind,colind).sort{1} = sortData;
sortData = []; sortData{1} = 'LuminanceDifferenceForTargetInRF'; sortData{2} = [-Inf -diffLogLumThresh];
CondParams(rowind,colind).sort{2} = sortData;
rowind = rowind+1;

CondParams(rowind,colind).Name = '+ RewardDiff, - BrightDiff';
CondParams(rowind,colind).Task = 'DelSaccade';
CondParams(rowind,colind).Choice = 1;
CondParams(rowind,colind).shuffle = 0;
sortData = []; sortData{1} = 'RewardDifferenceForTargetInRF'; sortData{2} = [0.001 Inf];
CondParams(rowind,colind).sort{1} = sortData;
sortData = []; sortData{1} = 'LuminanceDifferenceForTargetInRF'; sortData{2} = [-Inf -diffLogLumThresh];
CondParams(rowind,colind).sort{2} = sortData;
rowind = rowind+1;


colind = colind + 1;
rowind = 1;

CondParams(rowind,colind).Name = '- RewardDiff, 0 BrightDiff';
CondParams(rowind,colind).Task = 'DelSaccade';
CondParams(rowind,colind).Choice = 1;
CondParams(rowind,colind).shuffle = 0;
sortData = []; sortData{1} = 'RewardDifferenceForTargetInRF'; sortData{2} = [-Inf -0.001];
CondParams(rowind,colind).sort{1} = sortData;
sortData = []; sortData{1} = 'LuminanceDifferenceForTargetInRF'; sortData{2} = [-neutralLogLumThresh neutralLogLumThresh];
CondParams(rowind,colind).sort{2} = sortData;
rowind = rowind+1;

CondParams(rowind,colind).Name = '0 RewardDiff, 0 BrightDiff';
CondParams(rowind,colind).Task = 'DelSaccade';
CondParams(rowind,colind).Choice = 1;
CondParams(rowind,colind).shuffle = 0;
sortData = []; sortData{1} = 'RewardDifferenceForTargetInRF'; sortData{2} = [-0.001 0.001];
CondParams(rowind,colind).sort{1} = sortData;
sortData = []; sortData{1} = 'LuminanceDifferenceForTargetInRF'; sortData{2} = [-neutralLogLumThresh neutralLogLumThresh];
CondParams(rowind,colind).sort{2} = sortData;
rowind = rowind+1;

CondParams(rowind,colind).Name = '+ RewardDiff, 0 BrightDiff';
CondParams(rowind,colind).Task = 'DelSaccade';
CondParams(rowind,colind).Choice = 1;
CondParams(rowind,colind).shuffle = 0;
sortData = []; sortData{1} = 'RewardDifferenceForTargetInRF'; sortData{2} = [0.001 Inf];
CondParams(rowind,colind).sort{1} = sortData;
sortData = []; sortData{1} = 'LuminanceDifferenceForTargetInRF'; sortData{2} = [-neutralLogLumThresh neutralLogLumThresh];
CondParams(rowind,colind).sort{2} = sortData;
rowind = rowind+1;


colind = colind + 1;
rowind = 1;

CondParams(rowind,colind).Name = '- RewardDiff, + BrightDiff';
CondParams(rowind,colind).Task = 'DelSaccade';
CondParams(rowind,colind).Choice = 1;
CondParams(rowind,colind).shuffle = 0;
sortData = []; sortData{1} = 'RewardDifferenceForTargetInRF'; sortData{2} = [-Inf -0.001];
CondParams(rowind,colind).sort{1} = sortData;
sortData = []; sortData{1} = 'LuminanceDifferenceForTargetInRF'; sortData{2} = [diffLogLumThresh Inf];
CondParams(rowind,colind).sort{2} = sortData;
rowind = rowind+1;

CondParams(rowind,colind).Name = '0 RewardDiff, + BrightDiff';
CondParams(rowind,colind).Task = 'DelSaccade';
CondParams(rowind,colind).Choice = 1;
CondParams(rowind,colind).shuffle = 0;
sortData = []; sortData{1} = 'RewardDifferenceForTargetInRF'; sortData{2} = [-0.001 0.001];
CondParams(rowind,colind).sort{1} = sortData;
sortData = []; sortData{1} = 'LuminanceDifferenceForTargetInRF'; sortData{2} = [diffLogLumThresh Inf];
CondParams(rowind,colind).sort{2} = sortData;
rowind = rowind+1;

CondParams(rowind,colind).Name = '+ RewardDiff, + BrightDiff';
CondParams(rowind,colind).Task = 'DelSaccade';
CondParams(rowind,colind).Choice = 1;
CondParams(rowind,colind).shuffle = 0;
sortData = []; sortData{1} = 'RewardDifferenceForTargetInRF'; sortData{2} = [0.001 Inf];
CondParams(rowind,colind).sort{1} = sortData;
sortData = []; sortData{1} = 'LuminanceDifferenceForTargetInRF'; sortData{2} = [diffLogLumThresh Inf];
CondParams(rowind,colind).sort{2} = sortData;
rowind = rowind+1;


AnalParams = [];
for rowind=1:3
  for colind=1:3
    AnalParams(rowind,colind).Fields = {'TargsOn','SaccStart'};
    AnalParams(rowind,colind).bn = [ -600 600 ];
    AnalParams(rowind,colind).wlen = 0.1; % sliding window length
    AnalParams(rowind,colind).dn = 0.02; % sliding window increment
    AnalParams(rowind,colind).nPerm = 1e3;    
  end
end
