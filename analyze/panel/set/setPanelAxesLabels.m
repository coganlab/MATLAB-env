function PanelAxes = setPanelAxesLabels(PanelAxes, PanelData, AnalParams)
%
%  PanelAxes = setPanelAxesLabels(PanelAxes, PanelData, AnalParams)
%

M = size(PanelAxes,1);
N = size(PanelAxes,2);
SubM = size(PanelAxes(1,1).SubPanel,1);
SubN = size(PanelAxes(1,1).SubPanel,2);

for iM = 1
    for iN = 1:N
        iSubM = 1;
        for iSubN = 1:SubN
            DataHandle = PanelAxes(iM,iN).SubPanel(iSubM,iSubN).DataHandle;
            DataHandleType = get(DataHandle,'Type');
            Axes = PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes;
            dum = get(Axes);  % Needed for some random reason.  Don't delete
            XTick = get(Axes,'XTick');
            Data = PanelData(iM,iN).SubPanel(iSubM,iSubN).Data;
            XTickLabel = setPanelXTickLabel(DataHandleType, Data, XTick);
            set(Axes,'XTickLabel',XTickLabel);
            PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes = Axes;
        end
    end
end

for iM = 1:M
    for iN = 1:N
        for iSubN = 1:SubN
        for iSubM = 1:SubM
            DataHandle = PanelAxes(iM,iN).SubPanel(iSubM,iSubN).DataHandle;
            DataHandleType = get(DataHandle,'Type');
            Axes = PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes;
            dum = get(Axes);  % Needed for some random reason.  Don't delete
            YTick = get(Axes,'YTick');
            Data = PanelData(iM,iN).SubPanel(iSubM,iSubN).Data;
            
            %  This fixes the ticks for all the sub panels, but only
            %  labels the left-most subpanels
            YTickLabel = setPanelYTickLabel(DataHandleType, Data, YTick, Axes);
            if iN==1 && iSubN == 1; set(Axes,'YTickLabel',YTickLabel); end
            
            PanelAxes(iM,iN).SubPanel(iSubM,iSubN).Axes = Axes;
        end
        end
    end
end

