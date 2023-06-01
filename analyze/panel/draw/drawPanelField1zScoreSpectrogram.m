function [Axes, DataHandle] = drawPanelField1zScoreSpectrogram(Axes,Data)
%
%  Axes = drawPanelField1zScoreSpectrogram(Axes,Data)
%
size(Data.Data);
DataHandle = imagesc(flipud(Data.Data'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');
