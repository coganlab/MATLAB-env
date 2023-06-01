function [Axes, DataHandle] = drawPanelSpikeRate(Axes,Data)
%
%  Axes = drawPanelSpikeRate(Axes,Data)
%

DataHandle = plot(Data.t, Data.Data, 'Parent', Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');


