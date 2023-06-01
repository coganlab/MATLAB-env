function Session = StoSS(InputSession, Chamber, Ch, Task, N)
%
%   Session = StoSS(InputSession,Chamber,Ch,Task,N)
%


if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end
if nargin < 4; Task = []; end

ProjectDir = sessProjectDir(InputSession);


Session = loadSpikeSpike_Database(ProjectDir);

Ind = [];
for iSess = 1:length(Session)
    Spike1SessNum = Session{iSess}{6}(1);
    Spike2SessNum = Session{iSess}{6}(2);
    Spike1Chamber = Session{iSess}{3}{1};
    Spike2Chamber = Session{iSess}{3}{2};
    Channels = sessElectrode(Session{iSess});
    Spike1Ch = Channels(1);
    Spike2Ch = Channels(2);
    if ~isempty(Chamber)
        if ~isempty(Ch)
            if (Spike1SessNum == InputSession{6}(1) && (strcmp(Spike2Chamber,Chamber) || ...
                    (strcmp(Spike2Chamber(1:2),Chamber(1:2)) && ...
                    strcmp(Spike2Chamber(end),Chamber(end)))) && Spike2Ch==Ch) ...
                    || (Spike2SessNum == InputSession{6}(1) && (strcmp(Spike1Chamber,Chamber) || ...
                    (strcmp(Spike1Chamber(1:2),Chamber(1:2)) && ...
                    strcmp(Spike1Chamber(end),Chamber(end)))) && Spike1Ch==Ch)
                Ind = [Ind,iSess];
            end
        else
            if (Spike1SessNum == InputSession{6}(1) && (strcmp(Spike2Chamber,Chamber) || ...
                    (strcmp(Spike2Chamber(1:2),Chamber(1:2)) && ...
                    strcmp(Spike2Chamber(end),Chamber(end))))) ...
                    || (Spike2SessNum == InputSession{6}(1) && (strcmp(Spike1Chamber,Chamber) || ...
                    (strcmp(Spike1Chamber(1:2),Chamber(1:2)) && ...
                    strcmp(Spike1Chamber(end),Chamber(end)))))
                Ind = [Ind,iSess];
            end
        end
    else
        if Spike1SessNum == InputSession{6}(1) || Spike2SessNum == InputSession{6}(1)
            Ind = [Ind,iSess];
        end
    end
end

Session = Session(Ind);

if ~isempty(Session)
    %disp([num2str(length(Session)) ' SpikeSpike Sessions']);
    %%%  Does the Task selection
    if ~isempty(Task)
        if ischar(Task); Task = {Task}; end
        load([ProjectDir '/mat/SpikeSpike/SpikeSpike_NumTrials.mat']);
        for iSess = 1:length(Session)
            SessionNumTrials = matchNumTrialsSession(NumTrials,Session{iSess});
            for iTask = 1:length(Task)
                TaskN(iSess,iTask) = SessionNumTrials.(Task{iTask});
            end
        end

        ind = zeros(length(Task),length(Session));
        for iTask = 1:length(Task)
            a = find(TaskN(:,iTask)>N(iTask));
            ind(iTask,a)=1;
        end
        ind = sum(ind,1);

        Ind = find(ind == length(Task));
        Session = Session(Ind);

        TaskString = '';
        for iTask = 1:length(Task)
            TaskString = [TaskString ' ' Task{iTask}];
        end
        disp([num2str(length(Session)) TaskString ' SpikeSpike sessions']);
    else
        disp([num2str(length(Session)) ' SpikeSpike sessions']);
    end
else
    disp('No SpikeSpike Sessions');
end
