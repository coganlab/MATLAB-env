function printPanels(Session, CondParams, AnalParams, HardCopy)
%
%  printPanels(Session, CondParams, AnalParams, HardCopy)
%
%       HardCopy = 1 if you want to print a hardcopy.
%               Defaults to 0 saves a file
%

global MONKEYDIR

if nargin < 4 HardCopy  = 0; end

plotPanels(Session, CondParams, AnalParams);

set(gcf,'PaperOrientation','landscape');
set(gcf,'PaperPosition',[1.5 1.25 8 6]);

SessionType = getSessionType(Session);
SessionNumberString = getSessionNumberString(Session);

PanelNameString = getPanelNameString(CondParams);

%PanelName = CondParams(1,1).Name;

if HardCopy; print -PHonk; end
set(gcf,'PaperOrientation','portrait');
fileEPS = fullfile(MONKEYDIR,'fig',SessionType,['Panel.' PanelNameString '.' SessionNumberString '.eps']);
filePDF = fullfile(MONKEYDIR,'fig',SessionType,['Panel.' PanelNameString '.' SessionNumberString '.pdf']);
fileJPG = fullfile(MONKEYDIR,'fig',SessionType,['Panel.' PanelNameString '.' SessionNumberString '.jpg']);
saveas(gcf,fileJPG,'jpg')
print(gcf, '-depsc2', fileEPS);
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' filePDF ' ' fileEPS];
unix(cmd);
