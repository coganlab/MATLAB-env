function printSelectionTimeCurve(Onset, ModelType, DetectType)
%
%  printSelectionTimeCurve(Onset, DetectType)
%
%   Inputs: Onset      = Data structure
%           DetectType = String. 'Hit', 'Reject' or 'Correct'
%                           Defaults to 'Hit'
%

global MONKEYDIR


if nargin < 2 || isempty(ModelType)
    ModelType = 'NoHist';
end
if nargin < 3 || isempty(DetectType)
    DetectType = 'Hit';
end


FigureHandle = plotSelectionTimeCurve(Onset, ModelType, DetectType);

printSelectionHelper(FigureHandle, 'SelectionTimeCurve', Onset);

