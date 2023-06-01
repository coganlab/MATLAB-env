function printSelectionHelper(FigureHandle, Type, Onset)
%
%  printSelectionHelper(FigureHandle, Type, Onset)
%

global MONKEYDIR

Params = Onset(1).Params;

TaskString = [];
if iscell(Params.Task)
    for iTask = 1:length(Params.Task)
        TaskString = [TaskString '_' Params.Task{iTask}];
    end
    TaskString = TaskString(2:end);
else
    TaskString = Params.Task;
end

Session = Onset.Session;

SessionType = [];
for iType = 1:length(Onset.Results)
  SessionType = [SessionType Onset.Results(iType).Type];
end

SessNumString = [];
for iSess = 1:length(Session{6})
    SessNumString = [SessNumString '.' num2str(Session{6}(iSess))];
end
SessNumString = SessNumString(2:end);

PDFFilename = [MONKEYDIR '/fig/' SessionType '/' SessionType '_' Type '.' Params.Selection ...
    'Onset.' Params.Type '.' TaskString '.' SessNumString '.pdf'];
FIGFilename = [MONKEYDIR '/fig/' SessionType '/' SessionType '_' Type '.' Params.Selection ...
    'Onset.' Params.Type '.' TaskString '.' SessNumString '.fig'];
JPGFilename = [MONKEYDIR '/fig/' SessionType '/' SessionType '_' Type '.' Params.Selection ...
    'Onset.' Params.Type '.' TaskString '.' SessNumString '.jpg'];

disp(['Printing to PDF - ' PDFFilename]);
print(FigureHandle,'-depsc2','~/ARandomFilename');
%orient(fignum,oldorient);
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' PDFFilename ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

disp(['Printing to JPG - ' JPGFilename]);
saveas(FigureHandle,JPGFilename,'jpg');
disp(['Printing to FIG - ' FIGFilename]);
saveas(FigureHandle,FIGFilename,'fig');
