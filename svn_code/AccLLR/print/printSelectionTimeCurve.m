function printSelectionTimeCurve(Onset, DetectType)
%
%  printSelectionTimeCurve(Onset, DetectType)
%
%   Inputs: Onset      = Data structure
%           DetectType = String. 'Hit', 'Reject' or 'Correct'
%                           Defaults to 'Hit'
%

global MONKEYDIR

if nargin < 2 || isempty(DetectType)
    DetectType = 'Hit';
end

FigureHandle = plotSelectionTimeCurve(Onset, DetectType);

printSelectionHelper(FigureHandle, 'SelectionTimeCurve', Onset);

