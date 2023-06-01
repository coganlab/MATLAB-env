function Value = calcpCohUF(Session,CondParams,AnalParams)
%
%  Value = calcpCohUF(Session,CondParams,AnalParams)

iPanel = CondParams(1).iPanel;
isubPanel = CondParams(1).isubPanel;
timeind = CondParams.timeind;
freqind = CondParams.freqind;

Panels = loadPanels(Session, CondParams, AnalParams);
if isempty(Panels) || ~isfield(Panels.Data(iPanel,1).SubPanel(1,isubPanel).Data,'SuppData')
    savePanels(Session, CondParams, AnalParams)
    Panels = loadPanels(Session, CondParams, AnalParams);
end
Value = Panels.Data(iPanel,1).SubPanel(1,isubPanel).Data.SuppData.pCoh(timeind,freqind);



