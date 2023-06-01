function Session = dbF(Sys,Task,N,conds, ControlTask, ControlField, ControlType, ControlQuantity, ControlFreq, ControlLevel)
%
%   Session = dbF(Sys,Task,N,conds, ControlTask, ControlField, ControlType, ControlQuantity, ControlFreq, ControlLevel)
%
%       Field recordings
%
%   SYS 	=   Cell/String.  System
%   TASK        =   Cell/String array giving task
%                           pooling/comparison
%                           {{'Task1','Task2'}} pools over both tasks.
%                           {'Task1';'Task2'} compares both tasks
%
%   ControlTask:  'Sacc','LR1T', or 'Fix1T'
%   ControlField: 'Cue','Delay','Movement' or 'PostMovement'
%                       Defaults to 'Delay'
%   ControlType:  'Anova' or 'Tuning'
%                       Defaults to 'Tuning'
%   ControlQuantity: Any of the fields of Anova and Tuning:
%                       Tuning:  'P','R','Phi','Sel'
%                       Anova:
%                       Defaults to 'P'
%   ControlFreq:   Scalar frequency to select.  In units of 1Hz,11Hz,21Hz etc.
%			Defaults to 5 = 41 Hz.
%   ControlLevel:  A string to be executed ie '<0.05' or '>1'
%                       Defaults '<0.05'
%
global MONKEYDIR

if nargin < 4 || isempty(conds) conds = {[]}; end
if nargin < 5 ControlTask = []; end
if nargin < 6 || isempty(ControlField) ControlField = 'Delay'; end
if nargin < 7 || isempty(ControlType) ControlType = 'Tuning'; end
if nargin < 8 || isempty(ControlQuantity) ControlQuantity = 'P'; end
if nargin < 9 || isempty(ControlFreq) ControlFreq = 5; end
if nargin < 10 || isempty(ControlLevel) ControlLevel = '<0.05'; end


NumTrialsFlag = 0;
NumTrialsCondsFlag = 0;

load([MONKEYDIR '/mat/Field_Session.mat']);
if nargin > 2
    NumTrialsFlag = 1;
    load([MONKEYDIR '/mat/Field/Field_NumTrials.mat']);
end
if length(conds{1})>0
    NumTrialsCondsFlag = 1;
    load([MONKEYDIR '/mat/Field/Field_NumTrialsConds.mat']);
end

if ischar(Sys); Sys = {Sys}; end

ind = [];
for iSess = 1:length(Session)
    if isequal(Session{iSess}{3},Sys)
        ind = [ind;iSess];
    end
end
Session = Session(ind);

Type = Sys{1};
disp([num2str(length(Session)) ' ' Type ' field recordings']);

if nargin > 1
    %%%  Does the Task selection
    if ~isempty(Task)
        if NumTrialsFlag == 1
            if NumTrialsCondsFlag == 1
                [Session,TaskString] = TaskSelection(Session,Task,N,NumTrials,conds,NumTrialsConds);
            else
                [Session,TaskString] = TaskSelection(Session,Task,N,NumTrials,conds);
            end
        else
            [Session,TaskString] = TaskSelection(Session,Task,N,NumTrials);
        end
        disp([num2str(length(Session)) ' ' TaskString ' ' Type ' Field sessions']);
    else
        disp([num2str(length(Session)) ' ' Type ' Field sessions']);
    end

    SessNums = getSessNums(Session);

    %  Does the ControlTuning selection
    if ~isempty(ControlTask)
        ind = [];
        for iSess = 1:length(Session)
            load([MONKEYDIR '/mat/Field/Field_ControlTuning.' num2str(SessNums(iSess)) '.mat']);
            a= getfield(ControlTuning,ControlTask,ControlField,ControlType);
            if isfield(a,ControlQuantity)
                a = getfield(ControlTuning,ControlTask,ControlField,ControlType,ControlQuantity);
                Nmin = getfield(ControlTuning,ControlTask,ControlField,ControlType,'Nmin');
                if Nmin
                    eval(['Quantity(iSess) = a(' num2str(ControlFreq) ');']);
                    ind = [ind iSess];
                end
            end
        end
        Quantity = Quantity(ind);
        Session = Session(ind);
        cmd = ['Ind = find(Quantity' ControlLevel ');'];
        disp(['   ' cmd]);
        eval(cmd);
        Session = Session(Ind);
        disp([num2str(length(Session)) ' ' ControlField ' Tuned' TaskString ' ' Type ' Field sessions']);
    end
end
