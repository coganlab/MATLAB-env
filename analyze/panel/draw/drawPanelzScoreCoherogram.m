function [Axes, DataHandle] = drawPanelzScoreCoherogram(Axes,Data)
%
%  Axes = drawPanelzScoreCoherogram(Axes,Data)
%

DataHandle = imagesc(flipud(Data.Data'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');


