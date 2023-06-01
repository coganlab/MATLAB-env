function printSelectionROC(Onset)
%
%  printSelectionROC(Onset)
%
%   Inputs: Onset      = Data structure
%

FigureHandle = plotSelectionROC(Onset);
set(gcf,'Renderer','zbuffer');

printSelectionHelper(FigureHandle, 'SelectionROC', Onset);

