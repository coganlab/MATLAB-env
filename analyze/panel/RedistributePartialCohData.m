function PanelData = RedistributePartialCohData(PanelData)
%
%  PanelData = RedistributePartialCohData(PanelData)
%


M = size(PanelData,1);
N = size(PanelData,2);

for iM = 1:M
    for iN = 1:N
        SubM = size(PanelAxes(iM,iN).SubPanel,1);
        SubN = size(PanelAxes(iM,iN).SubPanel,2);
        for iSubM = 1:SubM
            for iSubN = 1:SubN
                Sub = mod(iSubN+1,2) + 1;
                tPanelData(iM,iN).SubPanel(iSubM,iSubN).Data.t = PanelData(iM,iN).SubPanel(1,Sub).Data.t;
                tPanelData(iM,iN).SubPanel(iSubM,iSubN).Data.NumTrials = PanelData(iM,iN).SubPanel(1,Sub).Data.NumTrials;
                tPanelData(iM,iN).SubPanel(iSubM,iSubN).Data.f = PanelData(iM,iN).SubPanel(1,Sub).Data.f;
                tPanelData(iM,iN).SubPanel(iSubM,iSubN).Data.xax = PanelData(iM,iN).SubPanel(1,Sub).Data.xax;
                tPanelData(iM,iN).SubPanel(iSubM,iSubN).Data.yax = PanelData(iM,iN).SubPanel(1,Sub).Data.yax;
            end
            tPanelData(iM,iN).SubPanel(iSubM,1).Data.Data = abs(PanelData(iM,iN).SubPanel(1,1).Data.SuppData.Coh{iSubM});
            tPanelData(iM,iN).SubPanel(iSubM,2).Data.Data = abs(PanelData(iM,iN).SubPanel(1,2).Data.SuppData.Coh{iSubM});
            tPanelData(iM,iN).SubPanel(iSubM,3).Data.Data = abs(PanelData(iM,iN).SubPanel(1,1).Data.Data{iSubM});
            tPanelData(iM,iN).SubPanel(iSubM,4).Data.Data = abs(PanelData(iM,iN).SubPanel(1,2).Data.Data{iSubM});
            tPanelData(iM,iN).SubPanel(iSubM,1).Data.SuppData = abs(PanelData(iM,iN).SubPanel(1,1).Data.SuppData.pCoh{iSubM});
            tPanelData(iM,iN).SubPanel(iSubM,2).Data.SuppData = abs(PanelData(iM,iN).SubPanel(1,2).Data.SuppData.pCoh{iSubM});
            tPanelData(iM,iN).SubPanel(iSubM,3).Data.SuppData = abs(PanelData(iM,iN).SubPanel(1,1).Data.SuppData.pParCoh{iSubM});
            tPanelData(iM,iN).SubPanel(iSubM,4).Data.SuppData = abs(PanelData(iM,iN).SubPanel(1,2).Data.SuppData.pParCoh{iSubM});
        end
    end
end

PanelData = tPanelData;


