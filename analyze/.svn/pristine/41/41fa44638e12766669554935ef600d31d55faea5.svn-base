function Session = addSpikeMultiunitField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Session = addSpikeMultiunitField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Putting in restriction that SessNum1 > SessNum2

global MONKEYDIR

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3; SessNum3 = []; end
if nargin < 4
    disp('Loading SpikeMultiunitField_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeMultiunitField_Session.mat'])
        Session = loadSpikeMultiunitField_Database;
    else
        Session = [];
    end
end

FieldSessions = loadField_Database;
SpikeSessions = loadSpike_Database;
MultiunitSessions = loadMultiunit_Database;

NumField = length(FieldSessions);
NumSpike = length(SpikeSessions);
NumMultiunit = length(MultiunitSessions);


if ~isempty(SessNum1) && ~isempty(SessNum2) && ~isempty(SessNum3)
    SpikeSess = MultiunitSessions{SessNum1};
    MultiunitSess = MultiunitSessions{SessNum2};
    FieldSess = FieldSessions{SessNum3};
    [flag,ind] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
    if ~flag
        if isSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess);
            tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
            Ind = length(Session)+1;
            disp(['Adding SMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
            SaveFlag = 1;
        end
    else
        tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
        disp(['Adding SMF Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
        SaveFlag = 1;
    end
elseif ~isempty(SessNum1) && ~isempty(SessNum2) && isempty(SessNum3)
    disp(['Processing all Spike Session ' num2str(SessNum1)]);
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    SpikeSess = SpikeSessions{SessNum1};
    MultiunitSess = MultiunitSessions{SessNum2};
    DayCell = intersect(SpikeSess(1),MultiunitSess(1));
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
                [flag,SMFind] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
                if ~flag
                    flag2 = isSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess);
                    if flag2
                        % pause
                        tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                    disp(['Replacing SMF Session ' num2str(tmpSession{6}) ' at position ' num2str(SMFind)]);
                    Session{SMFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
elseif ~isempty(SessNum1) && ~isempty(SessNum3) && isempty(SessNum2)
    disp(['Processing all Spike Session ' num2str(SessNum1)]);
    DayMultiunit = cell(1,NumMultiunit);
    for iMultiunit = 1:NumMultiunit
        DayMultiunit{iMultiunit} = MultiunitSessions{iMultiunit}{1};
    end
    SpikeSess = SpikeSessions{SessNum1};
    FieldSess = FieldSessions{SessNum3};
    DayCell = intersect(SpikeSess(1),FieldSess(1));
    if ~isempty(DayCell)
        Day = DayCell{1}; %Note: this cannot deal with multiple days
    else
        Day = 'jkl';
    end
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayMultiunit));
        if ~isempty(ind)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Multiunit Sessions to loop over']);
                MultiunitSess = MultiunitSessions{ind(iInd)};
                [flag,SMFind] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
                if ~flag
                    flag2 = isSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess);
                    if flag2
                        % pause
                        tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                    disp(['Replacing SMF Session ' num2str(tmpSession{6}) ' at position ' num2str(SMFind)]);
                    Session{SMFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
elseif ~isempty(SessNum2) && ~isempty(SessNum3) && isempty(SessNum1)
    disp(['Processing all Spike Session ' num2str(SessNum1)]);
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    MultiunitSess = MultiunitSessions{SessNum2};
    FieldSess = FieldSessions{SessNum3};
    DayCell = intersect(MultiunitSess(1),FieldSess(1));
    if ~isempty(DayCell)
        Day = DayCell{1}; %Note: this cannot deal with multiple days
    else
        Day = 'jkl';
    end
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DaySpike));
        if ~isempty(ind)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
                SpikeSess = SpikeSessions{ind(iInd)};
                [flag,SMFind] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
                if ~flag
                    flag2 = isSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess);
                    if flag2
                        % pause
                        tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                    disp(['Replacing SMF Session ' num2str(tmpSession{6}) ' at position ' num2str(SMFind)]);
                    Session{SMFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
elseif ~isempty(SessNum1) && isempty(SessNum2) && isempty(SessNum3)
    DayMultiunit = cell(1,NumMultiunit);
    for iMultiunit = 1:NumMultiunit
        DayMultiunit{iMultiunit} = MultiunitSessions{iMultiunit}{1};
    end
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    SpikeSess = SpikeSessions{SessNum1};
    Day = SpikeSess{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayMultiunit));
        ind2 = find(strcmp(Day,DayField));
        if ~isempty(ind) && ~isempty(ind2)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Multiunit Sessions to loop over']);
                MultiunitSess = MultiunitSessions{ind(iInd)};
                for iInd2 = 1:length(ind2)
                    FieldSess = FieldSessions{ind2(iInd2)};
                    [flag,SMFind] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
                    if ~flag
                        if isSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess)
                            tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding SMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                        disp(['Replacing SMF Session ' num2str(tmpSession{6}) ' at position ' num2str(SMFind)]);
                        Session{SMFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
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
    MultiunitSess = MultiunitSessions{SessNum2};
    Day = MultiunitSess{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DaySpike));
        ind2 = find(strcmp(Day,DayField));
        if ~isempty(ind) && ~isempty(ind2)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
                SpikeSess = SpikeSessions{ind(iInd)};
                for iInd2 = 1:length(ind2)
                    FieldSess = FieldSessions{ind2(iInd2)};
                    [flag,SMFind] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
                    if ~flag
                        if isSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess)
                            tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding SMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                        disp(['Replacing SMF Session ' num2str(tmpSession{6}) ' at position ' num2str(SMFind)]);
                        Session{SMFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum3) && isempty(SessNum1) && isempty(SessNum2)
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    DayMultiunit = cell(1,NumMultiunit);
    for iMultiunit = 1:NumMultiunit
        DayMultiunit{iMultiunit} = MultiunitSessions{iMultiunit}{1};
    end
    FieldSess = FieldSessions{SessNum3};
    Day = FieldSess{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DaySpike));
        ind2 = find(strcmp(Day,DayMultiunit));
        if ~isempty(ind) && ~isempty(ind2)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
                SpikeSess = SpikeSessions{ind(iInd)};
                for iInd2 = 1:length(ind2)
                    MultiunitSess = MultiunitSessions{ind2(iInd2)};
                    [flag,SMFind] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
                    if ~flag
                        if isSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess)
                            tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding SMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess);
                        disp(['Replacing SMF Session ' num2str(tmpSession{6}) ' at position ' num2str(SMFind)]);
                        Session{SMFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
    end
end

if SaveFlag
    disp('Saving SpikeMultiunitField_Session.mat')
    save([MONKEYDIR '/mat/SpikeMultiunitField_Session.mat'],'Session');
end

