function updateSpike_Database(SessNum)
%
%   UpdateSpike_Database(SessNum)
%
%   
%

if nargin == 1
    replaceSpikeSessInfo(SessNum);
    updateSpike_NumTrials(SessNum);
%     updateSpike_NumTrialsConds(SessNum);
%     updateSpike_ControlTuning(SessNum);
%     updateSpike_Figs(SessNum);
else
    updateSpike_NumTrials;
%     updateSpike_NumTrialsConds;
%     updateSpike_ControlTuning;
%     updateSpike_Figs;
end