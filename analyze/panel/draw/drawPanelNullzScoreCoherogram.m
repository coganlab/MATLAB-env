function [Axes, DataHandle] = drawPanelNullzScoreCoherogram(Axes,Data)
%
%  Axes = drawPanelNulllzScoreCoherogram(Axes,Data)
%

DataHandle = imagesc(flipud(Data.Data'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');

