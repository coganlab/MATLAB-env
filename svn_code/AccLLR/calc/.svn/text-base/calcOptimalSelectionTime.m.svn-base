function [ST, opt_p, opt_ST, opt_FA] = calcOptimalSelectionTime(Onset, DetectType)
%
%  [ST, opt_p, opt_ST, opt_FA] = calcOptimalSelectionTime(Onset, DetectType)
%
%   Inputs: Onset      = Data structure
%           DetectType = String. 'Hit' or 'Reject'
%                           Defaults to 'Hit'
%

if nargin < 2 || isempty(DetectType)
    DetectType = 'Hit';
end

NullAccLLR = Onset.Results.NoHist.Null.AccLLR;
EventAccLLR = Onset.Results.NoHist.Event.AccLLR;

switch DetectType
    case 'Hit'
        [p,ST,Levels] = performance_levels(EventAccLLR, NullAccLLR);
        [opt_p, opt_ST, opt_FA, opt_Level] = optimal_performance(p, ST, Levels);
        [dum, ST] = DetectAccLLR(EventAccLLR, opt_Level, -opt_Level);
    case 'Reject'
        [p,ST,Levels] = performance_levels(-NullAccLLR,-EventAccLLR);
        [opt_p, opt_ST, opt_FA, opt_Level] = optimal_performance(p, ST, Levels);
        [dum, ST] = DetectAccLLR(-NullAccLLR, opt_Level, -opt_Level);
end

