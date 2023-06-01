function PanelAxes = setPanelAxesData(PanelAxes, PanelData, AnalParams)
%
%  PanelAxes = setPanelAxesData(PanelAxes, PanelData, AnalParams)
%

M = size(PanelAxes,1);
N = size(PanelAxes,2);

for iM = 1:M
    for iN = 1:N
        SubM = size(PanelAxes(iM,iN).SubPanel,1);
        SubN = size(PanelAxes(iM,iN).SubPanel,2);
        for iSubM = 1:SubM
            for iSubN = 1:SubN
                Ax = PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes;
                Data = PanelData(iM,iN).SubPanel(iSubM,iSubN).Data;
                Type = AnalParams(iSubM,iSubN).Type;
                eval(['[Ax, DataHandle] = drawPanel' Type '(Ax, Data);']);
                PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes = Ax;
                PanelAxes(iM,iN).SubPanel(iSubM,iSubN).DataHandle = DataHandle;
            end
        end
    end
end


