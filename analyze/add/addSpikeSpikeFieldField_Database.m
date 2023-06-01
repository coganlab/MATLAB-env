function Session = addSpikeSpikeFieldField_Database(SessNum1,SessNum2,SessNum3,SessNum4, Session)
%
% Session = addSpikeSpikeFieldField_Database(SessNum1,SessNum2,SessNum3,SessNum4, Session)
%
% Putting in restriction that SessNum1 > SessNum2

global MONKEYDIR

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3; SessNum3 = []; end
if nargin < 4
    disp('Loading SpikeSpikeFieldField_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeSpikeFieldField_Session.mat'])
        Session = loadSpikeSpikeFieldField_Database;
    else
        Session = [];
    end
end

FieldSessions = loadField_Database;
SpikeSessions = loadSpike_Database;

NumField = length(FieldSessions);
NumSpike = length(SpikeSessions);

if isempty(SessNum1) && ~isempty(SessNum2)
    SessNum1 = SessNum2;
    SessNum2 = [];
end

if isempty(SessNum3) && ~isempty(SessNum4)
    SessNum3 = SessNum4;
    SessNum4 = [];
end

if ~isempty(SessNum1) && ~isempty(SessNum2) && ~isempty(SessNum3) && ~isempty(SessNum4)
    SpikeSess1 = SpikeSessions{SessNum1};
    SpikeSess2 = SpikeSessions{SessNum2};
    FieldSess1 = FieldSessions{SessNum3};
    FieldSess2 = FieldSessions{SessNum4};
    [flag,ind] = isInSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2, Session);
    if ~flag
        if isSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
            tmpSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
            Ind = length(Session)+1;
            disp(['Adding SSFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
            SaveFlag = 1;
        end
    else
        tmpSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
        disp(['Adding SSFF Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
        SaveFlag = 1;
    end
elseif ~isempty(SessNum1) && isempty(SessNum2) && isempty(SessNum3) && isempty(SessNum4)
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    SpikeSess1 = SpikeSessions{SessNum1};
    Day = SpikeSess1{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DaySpike));
        ind = setdiff(ind,SessNum1);
        ind2 = find(strcmp(Day,DayField));
        if ~isempty(ind) && ~isempty(ind2)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
                SpikeSess2 = SpikeSessions{ind(iInd)};
                for iInd2 = 1:length(ind2)
                    FieldSess1 = FieldSessions{ind2(iInd2)};
                    ind3 = setdiff(ind2,ind2(iInd2));
                    for iInd3 = 1:length(ind3)
                        FieldSess2 = FieldSessions{ind3(iInd3)};
                        [flag,SSFFind] = isInSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2,Session);
                        if ~flag
                            if isSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2)
                                tmpSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
                                Ind = length(Session)+1;
                                disp(['Not in database: Adding SSFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                                Session{Ind} = tmpSession;
                                SaveFlag = 1;
                            end
                        else
                            tmpSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
                            disp(['Replacing SSFF Session ' num2str(tmpSession{6}) ' at position ' num2str(SSFFind)]);
                            Session{SSFFind} = tmpSession;
                            SaveFlag = 1;
                        end
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum3) && isempty(SessNum1) && isempty(SessNum2) && isempty(SessNum4)
    disp(['Processing all Field Session ' num2str(SessNum3)]);
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    FieldSess1 = FieldSessions{SessNum3};
    Day = FieldSess1{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DaySpike));
        ind1 = find(strcmp(Day,DayField));
        ind3 = setdiff(ind1,SessNum3);
        if length(ind) > 1
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
                SpikeSess1 = SpikeSessions{ind(iInd)};
                ind2 = ind(ind>ind(iInd));
                for iInd2 = 1:length(ind2)
                    SpikeSess2 = SpikeSessions{ind2(iInd2)};
                    for iInd3 = 1:length(ind3)
                        FieldSess2 = FieldSessions{ind3(iInd3)};
                        [flag,SSFFind] = isInSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2,Session);
                        if ~flag
                            flag2 = isSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
                            if flag2
                                % pause
                                tmpSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
                                Ind = length(Session)+1;
                                disp(['Not in database: Adding SSFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                                Session{Ind} = tmpSession;
                                SaveFlag = 1;
                            end
                        else
                            tmpSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
                            disp(['Replacing SSFF Session ' num2str(tmpSession{6}) ' at position ' num2str(SSFFind)]);
                            Session{SSFFind} = tmpSession;
                            SaveFlag = 1;
                        end
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum1) && ~isempty(SessNum3) && ~isempty(SessNum4) && isempty(SessNum2)
    disp(['Processing all Spike Session ' num2str(SessNum1)]);
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    SpikeSess1 = SpikeSessions{SessNum1};
    FieldSess1 = FieldSessions{SessNum3};
    FieldSess2 = FieldSessions{SessNum4};
    DayCell = intersect(SpikeSess1(1),FieldSess1(1));
    if ~isempty(DayCell)
        Day = DayCell{1}; %Note: this cannot deal with multiple days
    else
        Day = 'jkl';
    end
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = setdiff(find(strcmp(Day,DaySpike)),SessNum2);
        if ~isempty(ind)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
                SpikeSess2 = SpikeSessions{ind(iInd)};
                [flag,SSFFind] = isInSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2,Session);
                if ~flag
                    flag2 = isSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
                    if flag2
                        % pause
                        tmpSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SSFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
                    disp(['Replacing SSFF Session ' num2str(tmpSession{6}) ' at position ' num2str(SSFFind)]);
                    Session{SSFFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
elseif ~isempty(SessNum1) && ~isempty(SessNum2) && ~isempty(SessNum3) && isempty(SessNum4)
    disp(['Processing all Spike Session ' num2str(SessNum1)]);
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    SpikeSess1 = SpikeSessions{SessNum1};
    SpikeSess2 = SpikeSessions{SessNum2};
    FieldSess1 = FieldSessions{SessNum3};
    DayCell = intersect(SpikeSess1(1),SpikeSess2(1));
    if ~isempty(DayCell)
        Day = DayCell{1}; %Note: this cannot deal with multiple days
    else
        Day = 'jkl';
    end
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayField));
        if ~isempty(ind)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Field Sessions to loop over']);
                FieldSess2 = FieldSessions{ind(iInd)};
                [flag,SSFFind] = isInSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2,Session);
                if ~flag
                    flag2 = isSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess);
                    if flag2
                        % pause
                        tmpSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SSFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2);
                    disp(['Replacing SSF Session ' num2str(tmpSession{6}) ' at position ' num2str(SSFFind)]);
                    Session{SSFFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
end

if SaveFlag
    disp('Saving SpikeSpikeFieldField_Session.mat')
    save([MONKEYDIR '/mat/SpikeSpikeFieldField_Session.mat'],'Session');
end

