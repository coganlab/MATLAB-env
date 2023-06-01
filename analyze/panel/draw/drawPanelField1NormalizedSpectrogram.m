function [Axes, DataHandle] = drawPanelField1NormalizedSpectrogram(Axes,Data)
%
%  Axes = drawPanelField1NormalizedSpectrogram(Axes,Data)
%

DataHandle = imagesc(flipud(Data.Data'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');
