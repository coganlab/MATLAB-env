function [Axes, DataHandle] = drawPanelField2NormalizedSpectrogram(Axes,Data)
%
%  Axes = drawPanelField2NormalizedSpectrogram(Axes,Data)
%

DataHandle = imagesc(flipud(Data.Data'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');
