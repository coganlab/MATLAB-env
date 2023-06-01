function Session = MtoMF(InputSession, Chamber, Ch, Contact, Task, N)
%
%   Session = MtoMF(InputSession,Chamber,Contact,Task,N)
%

global MONKEYDIR

if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end
if nargin < 4; Contact = []; end
if nargin < 5; Task = []; end

Session = loadMultiunitField_Database;

Ind = [];
for iSess = 1:length(Session)
    SN = sessNumber(Session{iSess});
    MultiunitSessNum = SN(1);
    FieldChamber = sessTower(Session{iSess});
    FieldChamber = FieldChamber{2};
    if iscell(FieldChamber); FieldChamber = FieldChamber{1}; end
    Channels = sessElectrode(Session{iSess});
    FieldCh = Channels(2);
    Contacts = sessContact(Session{iSess});
    FieldContact = Contacts(2);
    if ~isempty(Chamber)
        if ~isempty(Ch)
            if ~isempty(Contact)
                if MultiunitSessNum == InputSession{6}(1) ...
                        && (strcmp(FieldChamber,Chamber) || ...
                        (strcmp(FieldChamber(1:2),Chamber(1:2)) && ...
                        strcmp(FieldChamber(end),Chamber(end)))) && ...
                        FieldCh==Ch && FieldContact==Contact
                    Ind = [Ind,iSess];
                end
            else
                if MultiunitSessNum == InputSession{6}(1) ...
                        && (strcmp(FieldChamber,Chamber) || ...
                        (strcmp(FieldChamber(1:2),Chamber(1:2)) && ...
                        strcmp(FieldChamber(end),Chamber(end)))) && ...
                        FieldCh==Ch
                    Ind = [Ind,iSess];
                end
            end
        else
            if MultiunitSessNum == InputSession{6}(1) && ...
                    (strcmp(FieldChamber,Chamber) || ...
                    (strcmp(FieldChamber(1:2),Chamber(1:2)) && ...
                    strcmp(FieldChamber(end),Chamber(end))))
                Ind = [Ind,iSess];
            end
        end
    else
        if MultiunitSessNum == InputSession{6}(1)
            Ind = [Ind,iSess];
        end
    end
end

Session = Session(Ind);

if ~isempty(Session)
    %disp([num2str(length(Session)) ' MultiunitField Sessions']);
    %%%  Does the Task selection
    if ~isempty(Task)
        if ischar(Task); Task = {Task}; end
        load([MONKEYDIR '/mat/MultiunitField/MultiunitField_NumTrials.mat']);
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
        disp([num2str(length(Session)) TaskString ' MultiunitField sessions']);
    else
        disp([num2str(length(Session)) ' MultiunitField sessions']);
    end
else
    disp('No MultiunitField Sessions');
end
