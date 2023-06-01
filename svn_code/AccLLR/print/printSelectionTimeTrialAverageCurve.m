function printSelectionTimeTrialAverageCurve(Onset, DetectType)
%
%  printSelectionTimeTrialAverageCurve(Onset, DetectType)
%
%   Inputs: Onset      = Data structure
%           DetectType = String. 'Hit', 'Reject' or 'Correct'
%                           Defaults to 'Hit'
%

if nargin < 2 || isempty(DetectType)
    DetectType = 'Hit';
end

FigureHandle = plotSelectionTimeTrialAverageCurve(Onset, DetectType);

printSelectionHelper(FigureHandle, 'SelectionTimeTrialAverageCurve', Onset);

