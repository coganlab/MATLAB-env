function [Axes, DataHandle] = drawPanelFieldNormalizedSpectrogram(Axes,Data)
%
%  Axes = drawPanelFieldNormalizedSpectrogram(Axes,Data)
%
size(Data.Data);
DataHandle = imagesc(flipud(Data.Data'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');
