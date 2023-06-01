function Value = calcSigCoh23(Session,CondParams,AnalParams)
%
%  Value = calcSigCoh23(Session,CondParams,AnalParams)

% We want only those trials that were in full threepart session included,
% so we get this value from partial coh file, not coh file.

iPanel = CondParams(1).iPanel;
isubPanel = CondParams(1).isubPanel;
timeind = CondParams.timeind;
freqind = CondParams.freqind;

Panels = loadPanels(Session, CondParams, AnalParams);
if isempty(Panels)
    savePanels(Session, CondParams, AnalParams)
    Panels = loadPanels(Session, CondParams, AnalParams);
end
Value = Panels.Data(iPanel,1).SubPanel(1,isubPanel).Data.SuppData.pCoh23(timeind,freqind) < 0.05;






