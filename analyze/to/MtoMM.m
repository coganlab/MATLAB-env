function Session = MtoMM(InputSession, Chamber, Ch, Contact, Task, N)
%
%   Session = StoSS(InputSession,Chamber,Ch,Contact,Task,N)
%

global MONKEYDIR

if nargin < 2; Chamber = []; end
if nargin < 3; Ch = []; end
if nargin < 4; Contact = []; end
if nargin < 5; Task = []; end

ProjectDir = sessProjectDir(InputSession);

Session = loadMultiunitMultiunit_Database(ProjectDir);

Ind = [];
for iSess = 1:length(Session)
    Multiunit1SessNum = Session{iSess}{6}(1);
    Multiunit2SessNum = Session{iSess}{6}(2);
    Multiunit1Chamber = Session{iSess}{3}{1};
    Multiunit2Chamber = Session{iSess}{3}{2};
    Channels = sessElectrode(Session{iSess});
    Multiunit1Ch = Channels(1);
    Multiunit2Ch = Channels(2);
    Contacts = sessContact(Session{iSess});
    Multiunit1Contact = Contacts(1);
    Multiunit2Contact = Contacts(2);
    
    if ~isempty(Chamber)
        if ~isempty(Ch)
            if ~isempty(Contact)
                if (Multiunit1SessNum == InputSession{6}(1) && (strcmp(Multiunit2Chamber,Chamber) || ...
                        (strcmp(Multiunit2Chamber(1:2),Chamber(1:2)) && ...
                        strcmp(Multiunit2Chamber(end),Chamber(end)))) && Multiunit2Ch==Ch && Multiunit2Contact==Contact) ...
                        || (Multiunit2SessNum == InputSession{6}(1) && (strcmp(Multiunit1Chamber,Chamber) || ...
                        (strcmp(Multiunit1Chamber(1:2),Chamber(1:2)) && ...
                        strcmp(Multiunit1Chamber(end),Chamber(end)))) && Multiunit1Ch==Ch && Multiunit1Contact==Contact)
                    Ind = [Ind,iSess];
                else
                    if (Multiunit1SessNum == InputSession{6}(1) && (strcmp(Multiunit2Chamber,Chamber) || ...
                            (strcmp(Multiunit2Chamber(1:2),Chamber(1:2)) && ...
                            strcmp(Multiunit2Chamber(end),Chamber(end)))) && Multiunit2Ch==Ch) ...
                            || (Multiunit2SessNum == InputSession{6}(1) && (strcmp(Multiunit1Chamber,Chamber) || ...
                            (strcmp(Multiunit1Chamber(1:2),Chamber(1:2)) && ...
                            strcmp(Multiunit1Chamber(end),Chamber(end)))) && Multiunit1Ch==Ch)
                        Ind = [Ind,iSess];
                    end
                end
            else
                if (Multiunit1SessNum == InputSession{6}(1) && (strcmp(Multiunit2Chamber,Chamber) || ...
                        (strcmp(Multiunit2Chamber(1:2),Chamber(1:2)) && ...
                        strcmp(Multiunit2Chamber(end),Chamber(end))))) ...
                        || (Multiunit2SessNum == InputSession{6}(1) && (strcmp(Multiunit1Chamber,Chamber) || ...
                        (strcmp(Multiunit1Chamber(1:2),Chamber(1:2)) && ...
                        strcmp(Multiunit1Chamber(end),Chamber(end)))))
                    Ind = [Ind,iSess];
                end
            end
        end
    else
        if Multiunit1SessNum == InputSession{6}(1) || Multiunit2SessNum == InputSession{6}(1)
            Ind = [Ind,iSess];
        end
    end
end

Session = Session(Ind);

if ~isempty(Session)
    %disp([num2str(length(Session)) ' MultiunitMultiunit Sessions']);
    %%%  Does the Task selection
    if ~isempty(Task)
        if ischar(Task); Task = {Task}; end
        load([ProjectDir '/mat/MultiunitMultiunit/MultiunitMultiunit_NumTrials.mat']);
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
        disp([num2str(length(Session)) TaskString ' MultiunitMultiunit sessions']);
    else
        disp([num2str(length(Session)) ' MultiunitMultiunit sessions']);
    end
else
    disp('No MultiunitMultiunit Sessions');
end
