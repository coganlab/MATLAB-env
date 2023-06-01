function Session = StoSSF(InputSession, Chamber1, Ch1, Contact1, Chamber2, Ch2, Contact2, Task, N)
%
%   Session = StoSFF(InputSession,Chamber1,Ch1,Task,N)
%
%  Needs to be updated to allow contact inputs

global MONKEYDIR

if nargin < 2; Chamber1 = []; end
if nargin < 3; Ch1 = []; end
if nargin < 4; Contact1 = []; end
if nargin < 5; Chamber2 = []; end
if nargin < 6; Ch2 = []; end
if nargin < 4; Contact2 = []; end
if nargin < 8; Task = []; end

Session = loadSpikeSpikeField_Database;

Ind = [];
for iSess = 1:length(Session)
    SpikeSessNum = Session{iSess}{6}(1);
    FieldChamber = sessTower(Session{iSess});
    SpikeChamber1 = FieldChamber{2};
    if iscell(SpikeChamber1); SpikeChamber1 = SpikeChamber1{1}; end
    Channels = sessElectrode(Session{iSess});
    SpikeCh1 = Channels(2);
    FieldChamber2 = FieldChamber{3};
    if iscell(FieldChamber2); FieldChamber2 = FieldChamber2{1}; end
    FieldCh2 = Channels(3);
    Contacts = sessContact(Session{iSess});
    SpikeContact1 = Contacts{2};
    FieldContact2 = Contacts{3};
    if ~isempty(Chamber2)
        if ~isempty(Ch2)
            if ~isempty(Chamber2)
                if ~isempty(Contact2)
                    if ~isempty(Ch1)
                        if ~isempty(Contact1)
                            if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                                    (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                                    strcmp(SpikeChamber1(end),Chamber1(end)))) && SpikeCh1==Ch1 && SpikeContact1==Contact1 && ...
                                    (strcmp(SpikeChamber1,Chamber1) || ...
                                    (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                                    strcmp(FieldChamber2(end),Chamber2(end)))) && FieldCh2==Ch2 && FieldContact2==Contact2;
                                Ind = [Ind,iSess];
                            end
                        else
                            if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                                    (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                                    strcmp(SpikeChamber1(end),Chamber1(end)))) && SpikeCh1==Ch1 && ...
                                    (strcmp(SpikeChamber1,Chamber1) || ...
                                    (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                                    strcmp(FieldChamber2(end),Chamber2(end)))) && FieldCh2==Ch2 && FieldContact2==Contact2;
                                Ind = [Ind,iSess];
                            end
                            
                        end
                    else
                        if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                                (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                                strcmp(SpikeChamber1(end),Chamber1(end)))) && ...
                                (strcmp(SpikeChamber1,Chamber1) || ...
                                (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                                strcmp(FieldChamber2(end),Chamber2(end)))) && FieldCh2==Ch2 && FieldContact2==Contact2;
                            Ind = [Ind,iSess];
                        end
                    end
                else
                    if ~isempty(Ch1)
                        if ~isempty(Contact1)
                            if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                                    (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                                    strcmp(SpikeChamber1(end),Chamber1(end)))) && SpikeCh1==Ch1 && SpikeContact1==Contact1 && ...
                                    (strcmp(SpikeChamber1,Chamber1) || ...
                                    (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                                    strcmp(FieldChamber2(end),Chamber2(end)))) && FieldCh2==Ch2;
                                Ind = [Ind,iSess];
                            end
                        else
                            if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                                    (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                                    strcmp(SpikeChamber1(end),Chamber1(end)))) && SpikeCh1==Ch1 && ...
                                    (strcmp(SpikeChamber1,Chamber1) || ...
                                    (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                                    strcmp(FieldChamber2(end),Chamber2(end)))) && FieldCh2==Ch2;
                                Ind = [Ind,iSess];
                            end
                            
                        end
                    else
                        if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                                (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                                strcmp(SpikeChamber1(end),Chamber1(end)))) && ...
                                (strcmp(SpikeChamber1,Chamber1) || ...
                                (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                                strcmp(FieldChamber2(end),Chamber2(end)))) && FieldCh2==Ch2;
                            Ind = [Ind,iSess];
                        end
                    end
                end
            else
                if SpikeSessNum == InputSession{6}(1) && (strcmp(FieldChamber2,Chamber2) || ...
                        (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                        strcmp(FieldChamber2(end),Chamber2(end)))) && FieldCh2==Ch2;
                    Ind = [Ind,iSess];
                end
            end
        else
            if ~isempty(Chamber1)
                if ~isempty(Ch1)
                    if ~isempty(Contact1)
                        if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                                (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                                strcmp(SpikeChamber1(end),Chamber1(end)))) && SpikeCh1==Ch1 && SpikeContact1==Contact1 && ...
                                (strcmp(SpikeChamber1,Chamber1) || ...
                                (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                                strcmp(FieldChamber2(end),Chamber2(end))));
                            Ind = [Ind,iSess];
                        end
                    else
                        if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                                (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                                strcmp(SpikeChamber1(end),Chamber1(end)))) && SpikeCh1==Ch1 && ...
                                (strcmp(SpikeChamber1,Chamber1) || ...
                                (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                                strcmp(FieldChamber2(end),Chamber2(end))));
                            Ind = [Ind,iSess];
                        end
                    end
                else
                    if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                            (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                            strcmp(SpikeChamber1(end),Chamber1(end)))) && ...
                            (strcmp(SpikeChamber1,Chamber1) || ...
                            (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                            strcmp(FieldChamber2(end),Chamber2(end))));
                        Ind = [Ind,iSess];
                    end
                end
            else
                if SpikeSessNum == InputSession{6}(1) && (strcmp(FieldChamber2,Chamber2) || ...
                        (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                        strcmp(FieldChamber2(end),Chamber2(end))));
                    Ind = [Ind,iSess];
                end
            end
        end
    else
        if ~isempty(Chamber1)
            if ~isempty(Ch1)
                if ~isempty(Contact1)
                    if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                            (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                            strcmp(SpikeChamber1(end),Chamber1(end)))) && SpikeCh1==Ch1 && SpikeContact1==Contact1
                        Ind = [Ind,iSess];
                    end
                else
                    if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                            (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                            strcmp(SpikeChamber1(end),Chamber1(end)))) && SpikeCh1==Ch1
                        Ind = [Ind,iSess];
                    end
                end
            else
                if SpikeSessNum == InputSession{6}(1) && (strcmp(SpikeChamber1,Chamber1) || ...
                        (strcmp(SpikeChamber1(1:2),Chamber1(1:2)) && ...
                        strcmp(SpikeChamber1(end),Chamber1(end))))
                    Ind = [Ind,iSess];
                end
            end
        else
            if SpikeSessNum == InputSession{6}(1)
                Ind = [Ind,iSess];
            end
        end
    end
end

Session = Session(Ind);

if ~isempty(Session)
    disp([num2str(length(Session)) ' SpikeSpikeField Sessions']);
    %%%  Does the Task selection
    if ~isempty(Task)
        if ischar(Task); Task = {Task}; end
        load([MONKEYDIR '/mat/SpikeSpikeField/SpikeSpikeField_NumTrials.mat']);
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
        disp([num2str(length(Session)) TaskString ' SpikeSpikeField sessions']);
    else
        disp([num2str(length(Session)) ' SpikeSpikeField sessions']);
    end
else
    disp('No SpikeSpikeField Sessions');
end
