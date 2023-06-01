function Value = calcSigPartialCoh(Session,CondParams,AnalParams)
%
%  Value = calcSigPartialCoh(Session,CondParams,AnalParams)

iPanel = CondParams(1).iPanel;
isubPanel = CondParams(1).isubPanel;
timeind = CondParams.timeind;
freqind = CondParams.freqind;

Panels = loadPanels(Session, CondParams, AnalParams);
if isempty(Panels)
    savePanels(Session, CondParams, AnalParams)
    Panels = loadPanels(Session, CondParams, AnalParams);
end
Value = Panels.Data(iPanel,1).SubPanel(1,isubPanel).Data.SuppData.pParCoh(timeind,freqind) < 0.05;





