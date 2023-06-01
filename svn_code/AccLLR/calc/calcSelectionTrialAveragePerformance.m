function [Opt_p, Opt_ST, Opt_FA, Con_p, Con_ST, Con_FA] = calcSelectionTrialAveragePerformance(Onset, FA, DetectType,MinST)
%
%  [Opt_p, Opt_ST, Opt_FA, Con_p, Con_ST, Con_FA] = calcSelectionTrialAveragePerformance(Onset, FA, DetectType)
%
%   Inputs: Onset      = Data structure
%           FA         = Scalar.  False alarm rate
%           DetectType = String. 'Hit' or 'Correct'
%                           Defaults to 'Hit'
%           MinST = Scalar - minimum selection time
%


if nargin < 3 || isempty(DetectType)
    DetectType = 'Hit';
end
if nargin < 4
    MinST = 0;
end

Results = Onset.Results;
MaxTime = Onset.Params.MaximumTimetoOnsetDetection;
NumTrials = Results.NoHist.InputParams.TrialAvNumTrials;

Type = 'NoHist';
eval(['AccLLRNull = Results.' Type '.Null.AccLLR;'])
eval(['AccLLREvent = Results.' Type '.Event.AccLLR;'])

for iNumTrials = 1:length(NumTrials)
    %  NoHist across Trial Averages
    Type = 'NoHist';
    AccLLREvent = Onset.Results.NoHist.TrialAv.AccLLREvent{iNumTrials};
    AccLLRNull = Onset.Results.NoHist.TrialAv.AccLLRNull{iNumTrials};
    [p, ST, Levels] = performance_levels(AccLLREvent, AccLLRNull, DetectType);
    [Opt_p(iNumTrials), Opt_ST(iNumTrials), Opt_FA(iNumTrials)] = ...
        optimal_performance(p, ST, DetectType, MinST);
    [Con_p(iNumTrials), Con_ST(iNumTrials), Con_FA(iNumTrials)] = ...
        controlled_performance(p, ST, FA, DetectType, MinST);
end
