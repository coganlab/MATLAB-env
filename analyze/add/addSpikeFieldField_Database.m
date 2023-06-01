function Session = addSpikeFieldField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Session = addSpikeFieldField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Putting in restriction that SessNum2 > SessNum3

global MONKEYDIR

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3; SessNum3 = []; end
if nargin < 4
    disp('Loading SpikeFieldField_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeFieldField_Session.mat'])
        Session = loadSpikeFieldField_Database;
    else
        Session = [];
    end
end

FieldSessions = loadField_Database;
SpikeSessions = loadSpike_Database;

NumField = length(FieldSessions);
NumSpike = length(SpikeSessions);

if isempty(SessNum2) && ~isempty(SessNum3)
    SessNum2 = SessNum3;
    SessNum3 = [];
end

if ~isempty(SessNum1) && ~isempty(SessNum2) && ~isempty(SessNum3)
    SpikeSess = SpikeSessions{SessNum1};
    FieldSess1 = FieldSessions{SessNum2};
    FieldSess2 = FieldSessions{SessNum3};
    [flag,ind] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session);
    if ~flag
        if isSpikeFieldField(SpikeSess,FieldSess1,FieldSess2);
            tmpSession = createSpikeFieldField_Session(SpikeSess,FieldSess1,FieldSess2);
            Ind = length(Session)+1;
            disp(['Adding SFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
            SaveFlag = 1;
        end
    else
        tmpSession = createSpikeFieldField_Session(SpikeSess,FieldSess1,FieldSess2);
        disp(['Adding SFF Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
        SaveFlag = 1;
    end
elseif ~isempty(SessNum2) && isempty(SessNum1) && isempty(SessNum3)
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    FieldSess1 = FieldSessions{SessNum2};
    Day = FieldSess1{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DaySpike));
        ind2 = find(strcmp(Day,DayField));
        ind2 = setdiff(ind2,SessNum2);
        if ~isempty(ind) && ~isempty(ind2)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
                SpikeSess = SpikeSessions{ind(iInd)};
                for iInd2 = 1:length(ind2)
                    FieldSess2 = FieldSessions{ind2(iInd2)};
                    [flag,SFFind] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session);
                    if ~flag
                        if isSpikeFieldField(SpikeSess,FieldSess1,FieldSess2)
                            tmpSession = createSpikeFieldField_Session(SpikeSess,FieldSess1,FieldSess2);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding SFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createSpikeFieldField_Session(SpikeSess,FieldSess1,FieldSess2);
                        disp(['Replacing SFF Session ' num2str(tmpSession{6}) ' at position ' num2str(SFFind)]);
                        Session{SFFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum1) && isempty(SessNum2) && isempty(SessNum3)
    disp(['Processing all Spike Session ' num2str(SessNum1)]);
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    SpikeSess = SpikeSessions{SessNum1};
    Day = SpikeSess{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayField));
        if length(ind) > 1
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Field Sessions to loop over']);
                FieldSess1 = FieldSessions{ind(iInd)};
                ind2 = ind(ind>ind(iInd));
                for iInd2 = 1:length(ind2)
                    FieldSess2 = FieldSessions{ind2(iInd2)};
                    [flag,SFFind] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session);
                    if ~flag
                        flag2 = isSpikeFieldField(SpikeSess,FieldSess1,FieldSess2);
                        if flag2
                            % pause
                            tmpSession = createSpikeFieldField_Session(SpikeSess,FieldSess1,FieldSess2);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding SFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createSpikeFieldField_Session(SpikeSess,FieldSess1,FieldSess2);
                        disp(['Replacing SFF Session ' num2str(tmpSession{6}) ' at position ' num2str(SFFind)]);
                        Session{SFFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum1) && ~isempty(SessNum2) && isempty(SessNum3)
    disp(['Processing all Spike Session ' num2str(SessNum1)]);
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    SpikeSess = SpikeSessions{SessNum1};
    FieldSess1 = FieldSessions{SessNum2};
    DayCell = intersect(SpikeSess(1),FieldSess1(1));
    if ~isempty(DayCell)
        Day = DayCell{1}; %Note: this cannot deal with multiple days
    else
        Day = 'jkl';
    end
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = setdiff(find(strcmp(Day,DayField)),SessNum2);
        if ~isempty(ind)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Field Sessions to loop over']);
                FieldSess2 = FieldSessions{ind(iInd)};
                [flag,SFFind] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session);
                if ~flag
                    flag2 = isSpikeFieldField(SpikeSess,FieldSess1,FieldSess2);
                    if flag2
                        % pause
                        tmpSession = createSpikeFieldField_Session(SpikeSess,FieldSess1,FieldSess2);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeFieldField_Session(SpikeSess,FieldSess1,FieldSess2);
                    disp(['Replacing SFF Session ' num2str(tmpSession{6}) ' at position ' num2str(SFFind)]);
                    Session{SFFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
elseif ~isempty(SessNum2) && ~isempty(SessNum3) && isempty(SessNum1)
    disp(['Processing all Field Session ' num2str(SessNum2)]);
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    FieldSess1 = FieldSessions{SessNum2};
    FieldSess2 = FieldSessions{SessNum3};
    DayCell = intersect(FieldSess1(1),FieldSess2(1));
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
                SpikeSess = SpikeSessions{ind(iInd)};
                [flag,SFFind] = isInSpikeSpikeField(SpikeSess,FieldSess1,FieldSess2,Session);
                if ~flag
                    flag2 = isSpikeSpikeField(SpikeSess,FieldSess1,FieldSess2);
                    if flag2
                        % pause
                        tmpSession = createSpikeSpikeField_Session(SpikeSess,FieldSess1,FieldSess2);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
                    disp(['Replacing SFF Session ' num2str(tmpSession{6}) ' at position ' num2str(SFFind)]);
                    Session{SFFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
end

if SaveFlag
    disp('Saving SpikeFieldField_Session.mat')
    save([MONKEYDIR '/mat/SpikeFieldField_Session.mat'],'Session');
end

