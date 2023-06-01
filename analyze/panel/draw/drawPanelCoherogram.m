function [Axes, DataHandle] = drawPanelCoherogram(Axes,Data)
%
%  Axes = drawPanelCoherogram(Axes,Data)
%

DataHandle = imagesc(flipud(abs(Data.Data)'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');


