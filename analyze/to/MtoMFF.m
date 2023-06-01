function Session = MtoMFF(InputSession, Chamber1, Ch1, Chamber2, Ch2, Task, N)
%
%   Session = MtoMFF(InputSession,Chamber1,Ch1,Task,N)
%
%  Needs to be updated to allow contacts to be specified

global MONKEYDIR

if nargin < 2; Chamber1 = []; end
if nargin < 3; Ch1 = []; end
if nargin < 4; Chamber2 = []; end
if nargin < 5; Ch2 = []; end
if nargin < 6; Task = []; end

ProjectDir = sessProjectDir(InputSession);

Session = loadMultiunitFieldField_Database(ProjectDir);

Ind = [];
for iSess = 1:length(Session)
    MultiunitSessNum = Session{iSess}{6}(1);
    FieldChamber = sessTower(Session{iSess});
    FieldChamber1 = FieldChamber{2};
    if iscell(FieldChamber1); FieldChamber1 = FieldChamber1{1}; end
    Channels = sessElectrode(Session{iSess});
    FieldCh1 = Channels(2);
    FieldChamber2 = FieldChamber{3};
    if iscell(FieldChamber2); FieldChamber2 = FieldChamber2{1}; end
    FieldCh2 = Channels(3);
    if ~isempty(Chamber2)
        if ~isempty(Ch2)
            if ~isempty(Chamber1)
                if ~isempty(Ch1)
                    if MultiunitSessNum == InputSession{6}(1) && (strcmp(FieldChamber1,Chamber1) || ...
                            (strcmp(FieldChamber1(1:2),Chamber1(1:2)) && ...
                            strcmp(FieldChamber1(end),Chamber1(end)))) && FieldCh1==Ch1 && ...
                            (strcmp(FieldChamber1,Chamber1) || ...
                            (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                            strcmp(FieldChamber2(end),Chamber2(end)))) && FieldCh2==Ch2;
                        Ind = [Ind,iSess];
                    end
                else
                    if MultiunitSessNum == InputSession{6}(1) && (strcmp(FieldChamber1,Chamber1) || ...
                            (strcmp(FieldChamber1(1:2),Chamber1(1:2)) && ...
                            strcmp(FieldChamber1(end),Chamber1(end)))) && ...
                            (strcmp(FieldChamber1,Chamber1) || ...
                            (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                            strcmp(FieldChamber2(end),Chamber2(end)))) && FieldCh2==Ch2;
                        Ind = [Ind,iSess];
                    end
                end
            else
                if MultiunitSessNum == InputSession{6}(1) && (strcmp(FieldChamber2,Chamber2) || ...
                        (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                        strcmp(FieldChamber2(end),Chamber2(end)))) && FieldCh2==Ch2;
                    Ind = [Ind,iSess];
                end
            end
        else
            if ~isempty(Chamber1)
                if ~isempty(Ch1)
                    if MultiunitSessNum == InputSession{6}(1) && (strcmp(FieldChamber1,Chamber1) || ...
                            (strcmp(FieldChamber1(1:2),Chamber1(1:2)) && ...
                            strcmp(FieldChamber1(end),Chamber1(end)))) && FieldCh1==Ch1 && ...
                            (strcmp(FieldChamber1,Chamber1) || ...
                            (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                            strcmp(FieldChamber2(end),Chamber2(end))));
                        Ind = [Ind,iSess];
                    end
                else
                    if MultiunitSessNum == InputSession{6}(1) && (strcmp(FieldChamber1,Chamber1) || ...
                            (strcmp(FieldChamber1(1:2),Chamber1(1:2)) && ...
                            strcmp(FieldChamber1(end),Chamber1(end)))) && ...
                            (strcmp(FieldChamber1,Chamber1) || ...
                            (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                            strcmp(FieldChamber2(end),Chamber2(end))));
                        Ind = [Ind,iSess];
                    end
                end
            else
                if MultiunitSessNum == InputSession{6}(1) && (strcmp(FieldChamber2,Chamber2) || ...
                        (strcmp(FieldChamber2(1:2),Chamber2(1:2)) && ...
                        strcmp(FieldChamber2(end),Chamber2(end))));
                    Ind = [Ind,iSess];
                end
            end
        end
    else
        if ~isempty(Chamber1)
            if ~isempty(Ch1)
                if MultiunitSessNum == InputSession{6}(1) && (strcmp(FieldChamber1,Chamber1) || ...
                        (strcmp(FieldChamber1(1:2),Chamber1(1:2)) && ...
                        strcmp(FieldChamber1(end),Chamber1(end)))) && FieldCh1==Ch1
                    Ind = [Ind,iSess];
                end
            else
                if MultiunitSessNum == InputSession{6}(1) && (strcmp(FieldChamber1,Chamber1) || ...
                        (strcmp(FieldChamber1(1:2),Chamber1(1:2)) && ...
                        strcmp(FieldChamber1(end),Chamber1(end))))
                    Ind = [Ind,iSess];
                end
            end
        else
            if MultiunitSessNum == InputSession{6}(1)
                Ind = [Ind,iSess];
            end
        end
    end
end

Session = Session(Ind);

if ~isempty(Session)
    disp([num2str(length(Session)) ' MultiunitFieldField Sessions']);
    %%%  Does the Task selection
    if ~isempty(Task)
        if ischar(Task); Task = {Task}; end
        load([ProjectDir '/mat/MultiunitFieldField/MultiunitFieldField_NumTrials.mat']);
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
        disp([num2str(length(Session)) TaskString ' MultiunitFieldField sessions']);
    else
        disp([num2str(length(Session)) ' MultiunitFieldField sessions']);
    end
else
    disp('No MultiunitFieldField Sessions');
end
