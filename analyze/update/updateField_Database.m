function updateField_Database(SessNum)
%
%   UpdateField_Database
%
%



if nargin == 1
    replaceFieldSessInfo(SessNum);
    updateField_NumTrials(SessNum);
    updateField_NumTrialsConds(SessNum);
    updateField_ControlTuning(SessNum);
    %updateField_Figs(SessNum);
else
    updateField_NumTrials;
    updateField_NumTrialsConds;
    updateField_ControlTuning;
    %updateField_Figs;
end