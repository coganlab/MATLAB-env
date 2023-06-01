function [Axes, DataHandle] = drawPanelSigDiffCohThreePartSess(Axes,Data)
%
%  Axes = drawPanelSigDiffCohThreePartSess(Axes,Data)
%
size(Data.Data);
DataHandle = imagesc(flipud(Data.Data'),'Parent',Axes);
set(Axes,'XTickLabel','','YTickLabel','','TickDir','out');
