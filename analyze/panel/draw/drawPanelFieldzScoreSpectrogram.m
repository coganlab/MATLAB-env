function [Axes, DataHandle] = drawPanelFieldzScoreSpectrogram(Axes,Data)
%
%  Axes = drawPanelFieldzScoreSpectrogram(Axes,Data)
%
size(Data.Data);
DataHandle = imagesc(flipud(Data.Data'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');
