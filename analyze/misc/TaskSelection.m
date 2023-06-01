function [Session,TaskString,TaskN] = TaskSelection(Session,Task,N,NumTrials,Conds,NumTrialsConds)
%
%   [Session,TaskString,TaskN] = TaskSelection(Session,Task,N,NumTrials,Conds,NumTrialsConds);
%
%
%   TASK        =   Cell/String array giving task
%                           pooling/comparison
%                           {{'Task1','Task2'}} pools over both tasks.
%                           {'Task1';'Task2'} compares both tasks
%
%   CONDS       =   Cell array giving conditions to select and pool
%                       Conds{1} = First condition to pool
%                       Conds{2} = Second condition to pool
%
%                       Format for Conds{1,:} = {[3],[3],[3]} {[SE],[SH],[RE]}
%                       Conds{1} = {[1:8]} is a shorthand for
%                           Conds{1,:} = {[3],[3],[1]}; Conds{2,:} = {[3],[3],[2]}; etc
%


if nargin > 4
    NewConds = cell(1,3);
    if iscell(Conds) && length(Conds)==1
        for iCondPool = 1:length(Conds{1})
            NewConds(iCondPool,:) = {3,3,Conds{1}(iCondPool)};
        end
    end
    Conds = NewConds;
end

if ischar(Task) && ~isempty(Task)
    NewTask{1} = {Task}; Task = NewTask;
elseif iscell(Task)
    for iTaskComp = 1:length(Task)
        if ~iscell(Task{iTaskComp})
            NewTask(iTaskComp) = {Task(iTaskComp)};
        else
            NewTask(iTaskComp) = Task(iTaskComp);
        end
    end
    Task = NewTask;
end

if nargin < 5 || isempty(Conds{1})  %%  Pool over all conditions
    %%  Get the TaskN numbers
    TaskN = zeros(length(Session),size(Task,2));
    for iSess = 1:length(Session)
        SessionNumTrials = matchNumTrialsSession(NumTrials,Session{iSess});
        if ~isempty(SessionNumTrials)
        for iTaskComp = 1:length(Task)
            for iTaskPool = 1:length(Task{iTaskComp})
                if isfield(SessionNumTrials,Task{iTaskComp}{iTaskPool})
                    TaskN(iSess,iTaskComp) = TaskN(iSess,iTaskComp) + ...
                        SessionNumTrials.(Task{iTaskComp}{iTaskPool});
                end
            end
        end
        else
            TaskN(iSess,iTaskComp) = 0;
        end
    end

    ind = zeros(size(Task,2),length(Session));
    for iTaskComp = 1:size(Task,2)
        a = find(TaskN(:,iTaskComp)>N(iTaskComp));
        ind(iTaskComp,a)=1;
    end
    ind = sum(ind,1);
    Ind = find(ind == size(Task,2));
    Session = Session(Ind);
    TaskString = '';
    for iTaskComp = 1:length(Task)
        for iTaskPool = 1:length(Task{iTaskComp})
            TaskString = [TaskString ' ' Task{iTaskComp}{iTaskPool}];
        end
    end
else
    %%  Get the TaskCondsN numbers
    TaskCondsN = zeros(length(Session),size(Task,2));
    for iSess = 1:length(Session)
        SessionNumTrialsConds = matchNumTrialsSession(NumTrialsConds,Session{iSess});
        for iTaskComp = 1:length(Task)
            for iTaskPool = 1:length(Task{iTaskComp})
                for iCondPool = 1:size(Conds,1)
                    CurrentConds = Conds(iCondPool,:);
                    NumConds = SessionNumTrialsConds.(Task{iTaskComp}{iTaskPool});
                    if ~isempty(NumConds)
                        TaskCondsN(iSess,iTaskComp) = TaskCondsN(iSess,iTaskComp) + ...
                            NumConds(CurrentConds{1},CurrentConds{2},CurrentConds{3});
                    end
                end
            end
        end
    end

    ind = zeros(size(Task,2),length(Session));
    for iTaskComp = 1:size(Task,2)
        ind(iTaskComp,TaskCondsN(:,iTaskComp) > N(iTaskComp))=1;
    end
    ind = sum(ind,1);
    Ind = find(ind == size(Task,2));
    Session = Session(Ind);
    TaskString = '';
    for iTaskComp = 1:length(Task)
        for iTaskPool = 1:length(Task{iTaskComp})
            TaskString = [TaskString ' ' Task{iTaskComp}{iTaskPool}];
        end
    end
    TaskN = TaskCondsN;

end

