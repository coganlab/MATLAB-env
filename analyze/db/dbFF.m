function Session = dbFF(Type,Task,N,conds,ControlTask, ControlField, ControlType, ControlQuantity, ControlLevel)
%
%   Session = dbFF(Type,Task,N,conds,ControlTask, ControlField, ControlType, ControlQuantity, ControlLevel)
%
%   ControlTask:  'DelSaccadeTouch','DelReachSaccade', 'DelReachFix', 'DelSaccade' or 'DelReach'
%   ControlField: 'Cue','Delay','Movement' or 'PostMovement'
%   ControlType:  'Anova' or 'Tuning'
%   ControlQuantity: Any of the fields of Anova and Tuning
%   ControlLevel:  A string to be executed ie '<0.05' or '>1';

global MONKEYDIR


if nargin < 2 Task = []; end
if nargin < 4 conds = {[]}; end
if nargin < 5 ControlTask = []; end

load([MONKEYDIR '/mat/FieldField_Session.mat']);

NumTrialsFlag = 0;
NumTrialsCondsFlag = 0;

load([MONKEYDIR '/mat/FieldField_Session.mat']);
if nargin > 2
    NumTrialsFlag = 1;
    load([MONKEYDIR '/mat/FieldField/FieldField_NumTrials.mat']);
end
if length(conds{1})>0
    NumTrialsCondsFlag = 1;
    load([MONKEYDIR '/mat/FieldField/FieldField_NumTrialsConds.mat']);
end

ind = [];
for iSess = 1:length(Session)
    if isequal(Session{iSess}{3},Type)
        ind = [ind;iSess];
    end
end

Session = Session(ind);

disp([num2str(length(Session)) ' ' Type ' FF sessions']);

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

        disp([num2str(length(Session)) ' ' TaskString ' FF sessions']);

    else
        disp([num2str(length(Session)) '  FF sessions']);
    end



    %  Does the ControlTuning selection
    if ~isempty(ControlTask)
        ind = [];
        for iSess = 1:length(Session)
            SessNum = Session{iSess}{6}(1);
            load([MONKEYDIR '/mat/Field_ControlTuning.' num2str(SessNum) '.mat']);
            a= getfield(ControlTuning,{1},...
                ControlTask,ControlField,ControlType);
            if isfield(a,ControlQuantity)
                a = getfield(ControlTuning,{1},...
                    ControlTask,ControlField,ControlType,ControlQuantity);
                Nmin = getfield(ControlTuning,{1},...
                    ControlTask,ControlField,ControlType,'Nmin');
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
        disp([num2str(length(Session)) ' ' ControlField ' Tuned' TaskString ' FF sessions']);
    end
end
