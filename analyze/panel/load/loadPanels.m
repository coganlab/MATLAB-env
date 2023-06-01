function Panels = loadPanels(Session, CondParams, AnalParams)
%
%  Panels = loadPanels(Session, CondParams, AnalParams)
%
%

global MONKEYDIR

Panels = [];
SessionType = getSessionType(Session);
SessionNumberString = getSessionNumberString(Session);
PanelNameString = getPanelNameString(CondParams);

filemat = fullfile(MONKEYDIR, 'mat', SessionType, ['Panel.' PanelNameString '.' SessionNumberString '.mat']);
if exist(filemat, 'file')
    load(filemat);
end

