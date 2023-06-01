function [Fig]=sessPrintPDFPSTH(Sess,Task,Field,bn,sm,CondParams,PDFFilename)
%
%   Fig = sessPrintPDFPSTH(Sess,Task,Field,bn,sm,CondParams,PDFFilename)
%
%   SESS    =   Cell array.  Session information
%   TASK    =   Cell array of strings. Each row in the cell 
%               array is a new figure, with each cell containing 
%               a task to include for that figure.
%               'DelReachFix'
%               'DelSaccadeTouch'
%               'DelReachSaccade'
%               
%   FIELD   =   String.  Alignment field
%                   Defaults to 'TargsOn'
%   BN      =   Vector.  Analysis interval in ms 
%                   Defaults to [-1e3,1e3]
%   SM      =   Scalar.  Smoothing parameter in ms
%                   Defaults to 40
%   CondParams = Data structure to subset specific timing conditions
%                   CondParams.IntervalName = 'STRING';
%                   CondParams.IntervalDuration = [min,max]
%
%   PDFFilename = String.  Filename for PDF file destination. 
%                   Defaults to dialog box
%

global MONKEYDIR

if (nargin < 2) || isempty(Task);  Task = {'DelReachSaccade'}; end
if (nargin < 3) || isempty(Field);
    if strcmp(Task,'SOA')
        Field = 'SaccStart';
    else
        Field = 'TargsOn';
    end
end
if nargin < 4 || isempty(bn);   bn = [-1e3,2e3]; end
if nargin < 5 || isempty(sm);    sm =  40; end
if nargin < 6 || isempty(CondParams); CondParams = []; end

sessPrintPSTH(Sess,Task,Field,bn,sm,CondParams);
fignum = gcf;
oldorient = orient(fignum);

if nargin < 7 || isempty(PDFFilename)
    olddir = pwd;
    SessionType = sessType(Sess);
    pdfpath = fullfile(MONKEYDIR,'fig',SessionType,'PSTHs');
    if ~exist(pdfpath)
        disp([pdf path ' does not exist.  Creating']);
        mkdir(pdfpath)
    end
    cd(pdfpath)
    [Filename, Pathname] = uiputfile('*.pdf', 'Save As');
    FullPDFFilename = fullfile(Pathname,Filename);
    cd(olddir);
else
    
    noslash = sum(ismember(PDFFilename,'/'));
    if noslash == 0
        SessionType = sessType(Sess);
        pdfpath = fullfile(MONKEYDIR,'fig',SessionType,'PSTHs');
        FullPDFFilename = fullfile(pdfpath,PDFFilename);
    else
        FullPDFFilename = PDFFilename;
    end
end

disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' FullPDFFilename ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');