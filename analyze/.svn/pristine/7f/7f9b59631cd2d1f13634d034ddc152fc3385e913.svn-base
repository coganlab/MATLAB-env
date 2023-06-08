function savePanels(Session, CondParams, AnalParams, OverwriteFlag)
%
%  savePanels(Session, CondParams, AnalParams, OverwriteFlag)
%
%   OverwriteFlag = 1 Overwrite if saved.  0 = Do not overwrite if saved.
%                   Defaults to 0.

global MONKEYDIR

if nargin < 4; OverwriteFlag = 0; end

SessionType = getSessionType(Session);
SessionNumberString = getSessionNumberString(Session);
PanelNameString = getPanelNameString(CondParams);

filemat = fullfile(MONKEYDIR, 'mat', SessionType, ['Panel.' PanelNameString '.' SessionNumberString '.mat'])
if exist(filemat, 'file') && OverwriteFlag==0
    disp([filemat ' exists.  No overwrite'])
else
    Panels = plotPanels(Session, CondParams, AnalParams);
    save(filemat, 'Panels');
end