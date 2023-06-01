function Value = calcNumTrials(Session,CondParams,AnalParams)
%
%  Value = calcNumTrials(Session,CondParams,AnalParams)

%Hmm. Simply loading up NumTrials may give a different answer than that
%stored in the ParCoh data, since some trials may be excluded, thus...
% We want only those trials that were in full threepart session included,
% so we get this value from partial coh file, not coh file.

iPanel = CondParams(1).iPanel;
isubPanel = CondParams(1).isubPanel;

Panels = loadPanels(Session, CondParams, AnalParams);
if isempty(Panels)
    savePanels(Session, CondParams, AnalParams)
    Panels = loadPanels(Session, CondParams, AnalParams);
end
Value = Panels.Data(iPanel,1).SubPanel(1,isubPanel).Data.NumTrials;






