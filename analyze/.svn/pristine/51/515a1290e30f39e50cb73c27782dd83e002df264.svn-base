function Session = addMultiunitMultiunitField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Session = addMultiunitMultiunitField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Putting in restriction that SessNum1 > SessNum2

global MONKEYDIR

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3; SessNum3 = []; end
if nargin < 4
    disp('Loading MultiunitMultiunitField_Session.mat');
    if isfile([MONKEYDIR '/mat/MultiunitMultiunitField_Session.mat'])
        Session = loadMultiunitMultiunitField_Database;
    else
        Session = [];
    end
end

FieldSessions = loadField_Database;
MultiunitSessions = loadMultiunit_Database;

NumField = length(FieldSessions);
NumMultiunit = length(MultiunitSessions);

if isempty(SessNum1) && ~isempty(SessNum2)
    SessNum1 = SessNum2;
    SessNum2 = [];
end

if ~isempty(SessNum1) && ~isempty(SessNum2) && ~isempty(SessNum3)
    MultiunitSess1 = MultiunitSessions{SessNum1};
    MultiunitSess2 = MultiunitSessions{SessNum2};
    FieldSess = FieldSessions{SessNum3};
    [flag,ind] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session);
    if ~flag
        if isMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess);
            tmpSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess);
            Ind = length(Session)+1;
            disp(['Adding MMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
            SaveFlag = 1;
        end
    else
        tmpSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess);
        disp(['Adding MMF Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
        SaveFlag = 1;
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
    MultiunitSess1 = MultiunitSessions{SessNum1};
    Day = MultiunitSess1{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayMultiunit));
        ind = setdiff(ind,SessNum1);
        ind2 = find(strcmp(Day,DayField));
        if ~isempty(ind) && ~isempty(ind2)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Multiunit Sessions to loop over']);
                MultiunitSess2 = MultiunitSessions{ind(iInd)};
                for iInd2 = 1:length(ind2)
                    FieldSess = FieldSessions{ind2(iInd2)};
                    [flag,MMFind] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session);
                    if ~flag
                        if isMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess)
                            tmpSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding MMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess);
                        disp(['Replacing MMF Session ' num2str(tmpSession{6}) ' at position ' num2str(MMFind)]);
                        Session{MMFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum3) && isempty(SessNum1) && isempty(SessNum2)
    disp(['Processing all Field Session ' num2str(SessNum1)]);
    DayMultiunit = cell(1,NumMultiunit);
    for iMultiunit = 1:NumMultiunit
        DayMultiunit{iMultiunit} = MultiunitSessions{iMultiunit}{1};
    end
    FieldSess = FieldSessions{SessNum3};
    Day = FieldSess{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayMultiunit));
        if length(ind) > 1
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Multiunit Sessions to loop over']);
                MultiunitSess1 = MultiunitSessions{ind(iInd)};
                ind2 = ind(ind>ind(iInd));
                for iInd2 = 1:length(ind2)
                    MultiunitSess2 = MultiunitSessions{ind2(iInd2)};
                    [flag,MMFind] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session);
                    if ~flag
                        flag2 = isMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess);
                        if flag2
                            % pause
                            tmpSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding MMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess);
                        disp(['Replacing MMF Session ' num2str(tmpSession{6}) ' at position ' num2str(MMFind)]);
                        Session{MMFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum1) && ~isempty(SessNum3) && isempty(SessNum2)
    disp(['Processing all Multiunit Session ' num2str(SessNum1)]);
    DayMultiunit = cell(1,NumMultiunit);
    for iMultiunit = 1:NumMultiunit
        DayMultiunit{iMultiunit} = MultiunitSessions{iMultiunit}{1};
    end
    MultiunitSess1 = MultiunitSessions{SessNum1};
    FieldSess = FieldSessions{SessNum3};
    DayCell = intersect(MultiunitSess1(1),FieldSess(1));
    if ~isempty(DayCell)
        Day = DayCell{1}; %Note: this cannot deal with multiple days
    else
        Day = 'jkl';
    end
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = setdiff(find(strcmp(Day,DayMultiunit)),SessNum2);
        if ~isempty(ind)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Multiunit Sessions to loop over']);
                MultiunitSess2 = MultiunitSessions{ind(iInd)};
                [flag,MMFind] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session);
                if ~flag
                    flag2 = isMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess);
                    if flag2
                        % pause
                        tmpSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding MMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess);
                    disp(['Replacing MMF Session ' num2str(tmpSession{6}) ' at position ' num2str(MMFind)]);
                    Session{MMFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
elseif ~isempty(SessNum1) && ~isempty(SessNum2) && isempty(SessNum3)
    disp(['Processing all Multiunit Session ' num2str(SessNum1)]);
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    MultiunitSess1 = MultiunitSessions{SessNum1};
    MultiunitSess2 = MultiunitSessions{SessNum2};
    DayCell = intersect(MultiunitSess1(1),MultiunitSess2(1));
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
                [flag,MMFind] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session);
                if ~flag
                    flag2 = isMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess);
                    if flag2
                        % pause
                        tmpSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding MMF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess);
                    disp(['Replacing MMF Session ' num2str(tmpSession{6}) ' at position ' num2str(MMFind)]);
                    Session{MMFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
end

if SaveFlag
    disp('Saving MultiunitMultiunitField_Session.mat')
    save([MONKEYDIR '/mat/MultiunitMultiunitField_Session.mat'],'Session');
end

