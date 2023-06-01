function [Axes, DataHandle] = drawPanelField1Spectrogram(Axes,Data)
%
%  Axes = drawPanelField1Spectrogram(Axes,Data)
%

DataHandle = imagesc((flipud(Data.Data')),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');
