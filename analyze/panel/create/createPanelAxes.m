function PanelAxes = createPanelAxes(PanelCoords, AnalParams)
%
%  PanelAxes = createPanelAxes(PanelCoords, AnalParams)
%

M = size(PanelCoords,1);
N = size(PanelCoords,2);

figure;
for iM = 1:M
    for iN = 1:N
        SubM = size(PanelCoords(iM,iN).SubPanelCoords,1);
        SubN = size(PanelCoords(iM,iN).SubPanelCoords,2);
        for iSubM = 1:SubM
            for iSubN = 1:SubN
                left = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).LowerLeft(1);
                bottom = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).LowerLeft(2);
                width = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Width;
                height = PanelCoords(iM,iN).SubPanelCoords(iSubM,iSubN).Height;
                rect = [left, bottom, width, height];
                ax = axes('position', rect);
                set(ax, 'XTickLabel','', 'YTickLabel','');
                PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes = ax;
            end
        end
    end
end
