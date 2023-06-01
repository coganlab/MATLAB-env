function [Axes, DataHandle] = drawPanelSpikeSpectrogram(Axes,Data)
%
%  Axes = drawPanelSpikeSpectrogram(Axes,Data)
%

DataHandle = imagesc((flipud(Data.Data')),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');


