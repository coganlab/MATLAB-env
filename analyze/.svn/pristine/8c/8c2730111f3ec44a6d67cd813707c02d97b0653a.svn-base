function Value = calcTablePrefSigDiffCoh21v31(Session,CondParams,AnalParams)
%
%  Value = calcTablePrefSigDiffCoh21v31(Session,CondParams,AnalParams)


iPanel = CondParams(1).iPanel;
isubPanel = CondParams(1).isubPanel;
timeind = CondParams.timeind;
freqind = CondParams.freqind;

Panels = loadPanels(Session, CondParams, AnalParams);
if isempty(Panels)
    savePanels(Session, CondParams, AnalParams)
    %saveReorderedSigDiff(Session, CondParams, AnalParams)
    Panels = loadPanels(Session, CondParams, AnalParams);
end
Value = Panels.Data(iPanel,1).SubPanel(1,isubPanel).Data.Data(timeind,freqind) < 0.05;

close all


