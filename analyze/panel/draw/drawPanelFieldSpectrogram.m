function [Axes, DataHandle] = drawPanelFieldSpectrogram(Axes,Data)
%
%  Axes = drawPanelFieldSpectrogram(Axes,Data)
%

DataHandle = imagesc((flipud(Data.Data')),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');