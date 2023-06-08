function printSelectionTimeTrialAverageCurve(Onset, ModelType, DetectType)
%
%  printSelectionTimeTrialAverageCurve(Onset, DetectType)
%
%   Inputs: Onset      = Data structure
%           DetectType = String. 'Hit', 'Reject' or 'Correct'
%                           Defaults to 'Hit'
%

if nargin < 2 || isempty(ModelType)
    ModelType = 'NoHist';
end
if nargin < 3 || isempty(DetectType)
    DetectType = 'Hit';
end

FigureHandle = plotSelectionTimeTrialAverageCurve(Onset, ModelType,  DetectType);

printSelectionHelper(FigureHandle, 'SelectionTimeTrialAverageCurve', Onset);

