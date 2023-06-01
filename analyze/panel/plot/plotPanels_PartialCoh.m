function Panels = plotPanels_PartialCoh(Session, CondParams, AnalParams, PlotParams)
%
%  Panels = plotPanels_PartialCoh(Session, CondParams, AnalParams, PlotParams)
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

PanelCoords = calcPanelCoords(CondParams, PlotParams);

PanelCoords = calcSubPanelCoords_PartialCoh(AnalParams, PlotParams, PanelCoords);

PanelAxes = createPanelAxes(PanelCoords, AnalParams);

PanelData = calcPanelData(Session, CondParams, AnalParams);

Pos = [100,100,PlotParams.Size];
set(gcf,'Position',Pos);

PanelData = RedistributePartialCohData(PanelData);
AnalParams = RedistributePartialAnalParams(AnalParams);

PanelAxes = setPanelAxesData(PanelAxes, PanelData, AnalParams);

PanelAxes = setPanelAxesLimits(PanelAxes, PanelData, AnalParams);

PanelAxes = setPanelAxesLabels(PanelAxes, PanelData, AnalParams);

PanelAxes = setPanelLabels(PanelCoords, PanelAxes, PanelData, CondParams, AnalParams);

createPanelTitleBar(Session, PlotParams);

Panels.Axes = PanelAxes;
Panels.Data = PanelData;
Panels.Coords = PanelCoords;

