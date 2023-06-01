function printSelectionTrialAverageOptimalPerformance(Onset, DetectType)
%
%  printSelectionTrialAverageOptimalPerformance(Onset, DetectType)
%
%   Inputs: Onset      = Data structure
%

FigureHandle = plotSelectionTrialAverageOptimalPerformance(Onset, DetectType);

printSelectionHelper(FigureHandle, 'SelectionTrialAverageOptimalPerformance', Onset);

