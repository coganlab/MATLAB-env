function Session = dbM(Sys,Task,N,conds, ControlTask, ControlField, ControlType, ControlQuantity, ControlLevel)
%
%   Session = dbM(Sys,Task,N,conds, ControlTask, ControlField, ControlType, ControlQuantity, ControlLevel)
%
%       Spike recordings
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
%   ControlLevel:  A string to be executed ie '<0.05' or '>1'
%                       Defaults '<0.05'
%
global MONKEYDIR

if nargin < 4 || isempty(conds) conds = {[]}; end
if nargin < 5 ControlTask = []; end
if nargin < 6 || isempty(ControlField) ControlField = 'Delay'; end
if nargin < 7 || isempty(ControlType) ControlType = 'Tuning'; end
if nargin < 8 || isempty(ControlQuantity) ControlQuantity = 'P'; end
if nargin < 9 || isempty(ControlLevel) ControlLevel = '<0.05'; end

NumTrialsFlag = 0;
NumTrialsCondsFlag = 0;

load([MONKEYDIR '/mat/Multiunit_Session.mat']);
if nargin > 2
    NumTrialsFlag = 1;
    load([MONKEYDIR '/mat/Multiunit/Multiunit_NumTrials.mat']);
end
if length(conds{1})>0
    NumTrialsCondsFlag = 1;
    load([MONKEYDIR '/mat/Multiunit/Multiunit_NumTrialsConds.mat']);
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
disp([num2str(length(Session)) ' ' Type ' multiunit recordings']);

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
        disp([num2str(length(Session)) ' ' TaskString ' ' Type ' Multiunit sessions']);
    else
        disp([num2str(length(Session)) ' ' Type ' Multiunit sessions']);
    end

    SessNums = getSessNums(Session);

    %  Does the ControlTuning selection
    if ~isempty(ControlTask)
        %     load([MONKEYDIR '/mat/Field_ControlTuning.mat']);
        ind = [];
        for iSess = 1:length(Session)
            load([MONKEYDIR '/mat/Multiunit/Multiunit_ControlTuning.' num2str(SessNums(iSess)) '.mat']);
            a= getfield(ControlTuning,ControlTask,ControlField,ControlType);
            if isfield(a,ControlQuantity)
                a = getfield(ControlTuning,ControlTask,ControlField,ControlType,ControlQuantity);
                Nmin = getfield(ControlTuning,ControlTask,ControlField,ControlType,'Nmin');
                if Nmin
                    Quantity(iSess) = a;
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
        disp([num2str(length(Session)) ' ' ControlField ' Tuned' TaskString ' ' Type ' Multiunit sessions']);
    end
end
