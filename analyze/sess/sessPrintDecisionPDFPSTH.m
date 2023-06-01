function [Fig]=sessPrintDecisionPDFPSTH(Sess,Task,Field,bn,sm,CondParams,PDFFilename)
%
%   Fig = sessPrintDecisionPDFPSTH(Sess,Task,Field,bn,sm,CondParams,PDFFilename)
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
CondParams.Task = Task;
CondParams.Field = Field;
CondParams.bn = bn;
CondParams.sm = sm;
sessPrintDecisionPSTH(Sess,CondParams);
fignum = gcf;
oldorient = orient(fignum);

if nargin < 7 || isempty(PDFFilename)
    olddir = pwd;
    pdfpath = fullfile(MONKEYDIR,'fig','PSTHs');
    cd(pdfpath)
    [Filename, Pathname] = uiputfile('*.pdf', 'Save As');
    PDFFilename = fullfile(Pathname,Filename);
    cd(olddir);
end

disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' PDFFilename ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');