function Session = addSpikeSpikeField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Session = addSpikeSpikeField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Putting in restriction that SessNum1 > SessNum2

global MONKEYDIR

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3; SessNum3 = []; end
if nargin < 4
    disp('Loading SpikeSpikeField_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeSpikeField_Session.mat'])
        Session = loadSpikeSpikeField_Database;
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

if ~isempty(SessNum1) && ~isempty(SessNum2) && ~isempty(SessNum3)
    SpikeSess1 = SpikeSessions{SessNum1};
    SpikeSess2 = SpikeSessions{SessNum2};
    FieldSess = FieldSessions{SessNum3};
    [flag,ind] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session);
    if ~flag
        if isSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess);
            tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
            Ind = length(Session)+1;
            disp(['Adding SSF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
            SaveFlag = 1;
        end
    else
        tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
        disp(['Adding SSF Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
        SaveFlag = 1;
    end
elseif ~isempty(SessNum1) && isempty(SessNum2) && isempty(SessNum3)
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
                    FieldSess = FieldSessions{ind2(iInd2)};
                    [flag,SSFind] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session);
                    if ~flag
                        if isSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess)
                            tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding SSF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
                        disp(['Replacing SSF Session ' num2str(tmpSession{6}) ' at position ' num2str(SSFind)]);
                        Session{SSFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum3) && isempty(SessNum1) && isempty(SessNum2)
    disp(['Processing all Field Session ' num2str(SessNum1)]);
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    FieldSess = FieldSessions{SessNum3};
    Day = FieldSess{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DaySpike));
        if length(ind) > 1
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
                SpikeSess1 = SpikeSessions{ind(iInd)};
                ind2 = ind(ind>ind(iInd));
                for iInd2 = 1:length(ind2)
                    SpikeSess2 = SpikeSessions{ind2(iInd2)};
                    [flag,SSFind] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session);
                    if ~flag
                        flag2 = isSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess);
                        if flag2
                            % pause
                            tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding SSF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
                        disp(['Replacing SSF Session ' num2str(tmpSession{6}) ' at position ' num2str(SSFind)]);
                        Session{SSFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum1) && ~isempty(SessNum3) && isempty(SessNum2)
    disp(['Processing all Spike Session ' num2str(SessNum1)]);
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    SpikeSess1 = SpikeSessions{SessNum1};
    FieldSess = FieldSessions{SessNum3};
    DayCell = intersect(SpikeSess1(1),FieldSess(1));
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
                [flag,SSFind] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session);
                if ~flag
                    flag2 = isSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess);
                    if flag2
                        % pause
                        tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SSF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
                    disp(['Replacing SSF Session ' num2str(tmpSession{6}) ' at position ' num2str(SSFind)]);
                    Session{SSFind} = tmpSession;
                    SaveFlag = 1;
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
    SpikeSess1 = SpikeSessions{SessNum1};
    SpikeSess2 = SpikeSessions{SessNum2};
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
                FieldSess = FieldSessions{ind(iInd)};
                [flag,SSFind] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session);
                if ~flag
                    flag2 = isSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess);
                    if flag2
                        % pause
                        tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SSF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess);
                    disp(['Replacing SSF Session ' num2str(tmpSession{6}) ' at position ' num2str(SSFind)]);
                    Session{SSFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
end

if SaveFlag
    disp('Saving SpikeSpikeField_Session.mat')
    save([MONKEYDIR '/mat/SpikeSpikeField_Session.mat'],'Session');
end

