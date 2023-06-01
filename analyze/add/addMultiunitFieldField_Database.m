function Session = addMultiunitFieldField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Session = addMultiunitFieldField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Putting in restriction that SessNum2 > SessNum3

global MONKEYDIR

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3; SessNum3 = []; end
if nargin < 4
    disp('Loading MultiunitFieldField_Session.mat');
    if isfile([MONKEYDIR '/mat/MultiunitFieldField_Session.mat'])
        Session = loadMultiunitFieldField_Database;
    else
        Session = [];
    end
end

FieldSessions = loadField_Database;
MultiunitSessions = loadMultiunit_Database;

NumField = length(FieldSessions);
NumMultiunit = length(MultiunitSessions);

if isempty(SessNum2) && ~isempty(SessNum3)
    SessNum2 = SessNum3;
    SessNum3 = [];
end

if ~isempty(SessNum1) && ~isempty(SessNum2) && ~isempty(SessNum3)
    MultiunitSess = MultiunitSessions{SessNum1};
    FieldSess1 = FieldSessions{SessNum2};
    FieldSess2 = FieldSessions{SessNum3};
    [flag,ind] = isInMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2,Session);
    if ~flag
        if isMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2);
            tmpSession = createMultiunitFieldField_Session(MultiunitSess,FieldSess1,FieldSess2);
            Ind = length(Session)+1;
            disp(['Adding MFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
            SaveFlag = 1;
        end
    else
        tmpSession = createMultiunitFieldField_Session(MultiunitSess,FieldSess1,FieldSess2);
        disp(['Adding MFF Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
        SaveFlag = 1;
    end
elseif ~isempty(SessNum2) && isempty(SessNum1) && isempty(SessNum3)
    DayMultiunit = cell(1,NumMultiunit);
    for iMultiunit = 1:NumMultiunit
        DayMultiunit{iMultiunit} = MultiunitSessions{iMultiunit}{1};
    end
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    FieldSess1 = FieldSessions{SessNum2};
    Day = FieldSess1{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayMultiunit));
        ind2 = find(strcmp(Day,DayField));
        ind2 = setdiff(ind2,SessNum2);
        if ~isempty(ind) && ~isempty(ind2)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Multiunit Sessions to loop over']);
                MultiunitSess = MultiunitSessions{ind(iInd)};
                for iInd2 = 1:length(ind2)
                    FieldSess2 = FieldSessions{ind2(iInd2)};
                    [flag,SFind] = isInMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2,Session);
                    if ~flag
                        if isMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2)
                            tmpSession = createMultiunitFieldField_Session(MultiunitSess,FieldSess1,FieldSess2);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding MFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createMultiunitFieldField_Session(MultiunitSess,FieldSess1,FieldSess2);
                        disp(['Replacing MFF Session ' num2str(tmpSession{6}) ' at position ' num2str(SFind)]);
                        Session{SFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum1) && isempty(SessNum2) && isempty(SessNum3)
    disp(['Processing all Multiunit Session ' num2str(SessNum1)]);
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    MultiunitSess = MultiunitSessions{SessNum1};
    Day = MultiunitSess{1};
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
                    [flag,SFind] = isInMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2,Session);
                    if ~flag
                        flag2 = isMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2);
                        if flag2
                            % pause
                            tmpSession = createMultiunitFieldField_Session(MultiunitSess,FieldSess1,FieldSess2);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding MFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createMultiunitFieldField_Session(MultiunitSess,FieldSess1,FieldSess2);
                        disp(['Replacing MFF Session ' num2str(tmpSession{6}) ' at position ' num2str(SFind)]);
                        Session{SFind} = tmpSession;
                        SaveFlag = 1;
                    end
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
    MultiunitSess = MultiunitSessions{SessNum1};
    FieldSess1 = FieldSessions{SessNum2};
    DayCell = intersect(MultiunitSess(1),FieldSess1(1));
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
                FieldSess1 = FieldSessions{ind(iInd)};
                
                FieldSess2 = FieldSessions{ind(iInd)};
                [flag,SFind] = isInMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2,Session);
                if ~flag
                    flag2 = isMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2);
                    if flag2
                        % pause
                        tmpSession = createMultiunitFieldField_Session(MultiunitSess,FieldSess1,FieldSess2);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding MFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createMultiunitFieldField_Session(MultiunitSess,FieldSess1,FieldSess2);
                    disp(['Replacing MFF Session ' num2str(tmpSession{6}) ' at position ' num2str(SFind)]);
                    Session{SFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
end

if SaveFlag
    disp('Saving MultiunitFieldField_Session.mat')
    save([MONKEYDIR '/mat/MultiunitFieldField_Session.mat'],'Session');
end

