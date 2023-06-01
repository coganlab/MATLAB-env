function [Axes, DataHandle] = drawPanelPartialCoherency(Axes,Data)
%
%  Axes = drawPanelPartialCoherency(Axes,Data)
%

DataHandle = imagesc(flipud(Data.Data'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');


