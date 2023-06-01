function Panels = plotSavedPanels(Session, CondParams, AnalParams, PlotParams)
%
%  Panels = plotSavedPanels(Session, CondParams, AnalParams, PlotParams)
%

if nargin < 4
    PlotParams.TitleBar.Height = 0.05;
    PlotParams.Margins.Outer = 0.05;
    PlotParams.Margins.Inner = 0.025;
    PlotParams.SubTextBar.TopMargin = 0.025;
    PlotParams.SubTextBar.SideMargin = 0.025;
    PlotParams.Margins.SubInner = 0.008;
    PlotParams.Size = [1e3, 800];
end

[Panels] = loadPanels(Session, CondParams, AnalParams);

PanelCoords = calcPanelCoords(CondParams, PlotParams);

PanelCoords = calcSubPanelCoords(AnalParams, PlotParams, PanelCoords);

PanelAxes = createPanelAxes(PanelCoords, AnalParams);

Pos = [100,100,PlotParams.Size];
set(gcf,'Position',Pos);

PanelAxes = setPanelAxesData(PanelAxes, Panels.Data, AnalParams);

PanelAxes = setPanelAxesLimits(PanelAxes, Panels.Data, AnalParams);

PanelAxes = setPanelAxesLabels(PanelAxes, Panels.Data, AnalParams);

PanelAxes = setPanelLabels(PanelCoords, PanelAxes, Panels.Data, CondParams, AnalParams);

try createPanelTitleBar(Session, PlotParams); catch end


