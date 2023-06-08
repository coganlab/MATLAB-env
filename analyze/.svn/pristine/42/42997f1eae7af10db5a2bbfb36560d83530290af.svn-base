function printSavedPanels(Session, CondParams, AnalParams, Overwrite, HardCopy)
%
%  printSavedPanels(Session, CondParams, AnalParams, Overwrite, HardCopy)
%
%       Overwrite = 1 if you want to overwrite the saved copy
%                   0 if not.  Defaults to 0.
%       HardCopy = 1 if you want to print a hardcopy.
%               Defaults to 0
%

global MONKEYDIR

if nargin < 4 || isempty(Overwrite); Overwrite = 0; end
if nargin < 5; HardCopy  = 0; end

SessionType = getSessionType(Session);
SessionNumberString = getSessionNumberString(Session);

PanelNameString = getPanelNameString(CondParams);
fileEPS = fullfile(MONKEYDIR,'fig',SessionType,['Panel.' PanelNameString '.' SessionNumberString '.eps']);
filePDF = fullfile(MONKEYDIR,'fig',SessionType,['Panel.' PanelNameString '.' SessionNumberString '.pdf']);
fileJPG = fullfile(MONKEYDIR,'fig',SessionType,['Panel.' PanelNameString '.' SessionNumberString '.jpg']);

if Overwrite || ~exist(fileJPG,'file')
    plotSavedPanels(Session, CondParams, AnalParams);

    set(gcf,'PaperOrientation','landscape');
    set(gcf,'PaperPosition',[1.5 1.25 8 6]);
    %PanelName = CondParams(1,1).Name;

    if HardCopy; print -PHonk; end
    set(gcf,'PaperOrientation','portrait');

    saveas(gcf,fileJPG,'jpg')
    print(gcf, '-depsc2', fileEPS);
    cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
    unix(cmd);
else
    disp([fileJPG ' already exists']);
end