function [Axes, DataHandle] = drawPanelField2Spectrogram(Axes,Data)
%
%  Axes = drawPanelField2Spectrogram(Axes,Data)
%

DataHandle = imagesc((flipud(Data.Data')),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');
