function [Axes, DataHandle] = drawPanelPartialCoherogram(Axes,Data)
%
%  Axes = drawPanelPartialCoherogram(Axes,Data)
%

DataHandle = imagesc(flipud(abs(Data.Data)'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');


