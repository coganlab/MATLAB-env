function [ST, con_p, con_ST, con_FA] = calcControlledSelectionTime(Onset, FA, DetectType)
%
%  [ST, con_p, con_ST, con_FA] = calcControlledSelectionTime(Onset, FA, DetectType)
%
%   Inputs: Onset      = Data structure
%           FA         = Scalar.  Controlled false alarm probability.
%           DetectType = String. 'Hit' or 'Reject'
%                           Defaults to 'Hit'
%

if nargin < 3 || isempty(DetectType)
    DetectType = 'Hit';
end

NullAccLLR = Onset.Results.NoHist.Null.AccLLR;
EventAccLLR = Onset.Results.NoHist.Event.AccLLR;

switch DetectType
    case 'Hit'
        [p,ST,Levels] = performance_levels(EventAccLLR, NullAccLLR);
        [con_p, con_ST, con_FA, con_Level] = controlled_performance(p, ST, Levels, FA);
        [dum, ST] = DetectAccLLR(EventAccLLR, con_Level, -con_Level);
    case 'Reject'
        [p,ST,Levels] = performance_levels(-NullAccLLR, -EventAccLLR);
        [con_p, con_ST, con_FA, con_Level] = controlled_performance(p, ST, Levels, FA);
        [dum, ST] = DetectAccLLR(-NullAccLLR, con_Level, -con_Level);
end
