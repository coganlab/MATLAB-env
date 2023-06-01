function Session = MtoSM(InputSession, Chamber, Ch, Contact, Task, N)
%
%   Session = MtoSM(InputSession,Chamber,Ch,Contact,Task,N)
%

global MONKEYDIR

if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end
if nargin < 4; Contact = []; end
if nargin < 5; Task = []; end

Session = loadSpikeMultiunit_Database;

Ind = [];
for iSess = 1:length(Session)
    MultiunitSessNum = Session{iSess}{6}(2);
    SpikeChamber = sessTower(Session{iSess});
    SpikeChamber = SpikeChamber{1};
    if iscell(SpikeChamber); SpikeChamber = SpikeChamber{1}; end
    Channels = sessElectrode(Session{iSess});
    SpikeCh = Channels(1);
    Contacts = sessContact(Session{iSess});
    SpikeContact = Contacts(1);
    if ~isempty(Chamber)
        if ~isempty(Ch)
            if ~isempty(Contact)
                if MultiunitSessNum == InputSession{6}(2) && ...
                        (strcmp(SpikeChamber,Chamber) || ...
                        (strcmp(SpikeChamber(1:2),Chamber(1:2)) && ...
                        strcmp(SpikeChamber(end),Chamber(end)))) && ...
                        SpikeCh==Ch && SpikeContact==Contact
                    Ind = [Ind,iSess];
                end
            else
                if MultiunitSessNum == InputSession{6}(2) && ...
                        (strcmp(SpikeChamber,Chamber) || ...
                        (strcmp(SpikeChamber(1:2),Chamber(1:2)) && ...
                        strcmp(SpikeChamber(end),Chamber(end)))) && ...
                        SpikeCh==Ch
                    Ind = [Ind,iSess];
                end
            end
        else
            if MultiunitSessNum == InputSession{6}(2) && ...
                    (strcmp(SpikeChamber,Chamber) || ...
                    (strcmp(SpikeChamber(1:2),Chamber(1:2)) && ...
                    strcmp(SpikeChamber(end),Chamber(end))))
                Ind = [Ind,iSess];
            end
        end
    else
        if MultiunitSessNum == InputSession{6}
            Ind = [Ind,iSess];
        end
    end
end

Session = Session(Ind);

if ~isempty(Session)
    %disp([num2str(length(Session)) ' SpikeMultiunit Sessions']);
    %%%  Does the Task selection
    if ~isempty(Task)
        if ischar(Task); Task = {Task}; end
        load([MONKEYDIR '/mat/SpikeMultiunit/SpikeMultiunit_NumTrials.mat']);
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
        disp([num2str(length(Session)) TaskString ' SpikeMultiunit sessions']);
    else
        disp([num2str(length(Session)) ' SpikeMultiunit sessions']);
    end
else
    disp('No SpikeMultiunit Sessions');
end
