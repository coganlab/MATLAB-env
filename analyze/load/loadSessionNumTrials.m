function NumTrials = loadSessionNumTrials(Session, Task, conds, SessionNumTrials, SessionDatabase)
%
%  NumTrials = loadSessionNumTrials(Session, Task, conds, SessionNumTrials, SessionDatabase)
%
%  loads Number of Trials for Session in
%   MONKEYDIR/mat/SESSTYPE/SESSTYPE_NumTrials.mat

global MONKEYDIR  TASKLIST

if nargin < 2; Task = ''; end

SessionType = sessType(Session);
SessionNumber = getSessionNumbers(Session);
switch SessionType
    case {'Spike','Multiunit','Field'}
        SessionIndex = SessionNumber;
    %case {'SpikeField','MultiunitField','FieldField', 'SpikeSpike', 'MultiunitMultiunit'}
    otherwise
        if nargin < 5 || isempty(SessionDatabase)
            eval(['TempSession =load' SessionType '_Database;']);
        end
        TempSessionNumber = getSessionNumbers(SessionDatabase);
        [dum, SessionIndex] = intersect(TempSessionNumber,SessionNumber,'rows'); 
end
%SessionNumberString = getSessionNumberString(Session);
if nargin < 3 || isempty(conds)
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrials.mat'];

    if nargin < 4
        if exist(Filename,'file')
            Session = load(Filename);
        end
        SessNumTrials = Session.NumTrials(SessionIndex);
    else
        SessNumTrials = SessionNumTrials(SessionIndex);
    end

    if ischar(Task) && ~isempty(Task)
        NumTrials = SessNumTrials.(Task);
    elseif iscell(Task)
        NumTrials = zeros(1,length(Task));
        for iTaskComp = 1:length(Task)
            if ~iscell(Task{iTaskComp})
                NumTrials(iTaskComp) = SessNumTrials.(Task{iTaskComp});
            else
                for iTaskPool = 1:length(Task{iTaskComp})
                    NumTrials(iTaskComp) = NumTrials(iTaskComp) + SessNumTrials.(Task{iTaskComp}{iTaskPool});
                end
            end
        end
    else
        NumTrials = 0;
        for iTask = 1:length(TASKLIST)
            NumTrials = NumTrials + SessNumTrials.(TASKLIST{iTask});
        end
    end

else
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_NumTrialsConds.mat'];
    disp('Not implemented yet');
end