function Session = addMultiunitField_Database(SessNum1,SessNum2,Session)
%
% Session = addMultiunitField_Database(SessNum1,SessNum2,Session)
%

global MONKEYDIR

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3
    disp('Loading MultiunitField_Session.mat');
    if isfile([MONKEYDIR '/mat/MultiunitField_Session.mat'])
        Session = loadMultiunitField_Database;
    else
        Session = [];
    end
end

FieldSessions = loadField_Database;
MultiunitSessions = loadMultiunit_Database;

NumField = length(FieldSessions);
NumMultiunit = length(MultiunitSessions);

if ~isempty(SessNum1) && ~isempty(SessNum2)
    MultiunitSess = MultiunitSessions{SessNum1};
    FieldSess = FieldSessions{SessNum2};
    [flag,ind] = isInMultiunitField(MultiunitSess,FieldSess,Session);
    if ~flag
        if isMultiunitField(MultiunitSess,FieldSess);
            tmpSession = createMultiunitField_Session(MultiunitSess,FieldSess);
            Ind = length(Session)+1;
            disp(['Adding MF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
            SaveFlag = 1;
        end
    else
        tmpSession = createMultiunitField_Session(MultiunitSess,FieldSess);
        disp(['Adding MF Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
        SaveFlag = 1;
    end
elseif ~isempty(SessNum2) && isempty(SessNum1)
    DayMultiunit = cell(1,NumMultiunit);
    for iMultiunit = 1:NumMultiunit
        DayMultiunit{iMultiunit} = MultiunitSessions{iMultiunit}{1};
    end
    FieldSess = FieldSessions{SessNum2};
    Day = FieldSess{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayMultiunit));
        if ~isempty(ind)
            %DayTrials = dbSelectTrials(Day);
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Multiunit Sessions to loop over']);
                MultiunitSess = MultiunitSessions{ind(iInd)};
                [flag,MFind] = isInMultiunitField(MultiunitSess,FieldSess,Session);
                if ~flag
                    if isMultiunitField(MultiunitSess,FieldSess)
                        tmpSession = createMultiunitField_Session(MultiunitSess,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding MF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createMultiunitField_Session(MultiunitSess,FieldSess);
                    disp(['Replacing MF Session ' num2str(tmpSession{6}) ' at position ' num2str(MFind)]);
                    Session{MFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
elseif ~isempty(SessNum1) && isempty(SessNum2)
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
        if ~isempty(ind)
            %DayTrials = dbSelectTrials(Day);
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Field Sessions to loop over']);
                FieldSess = FieldSessions{ind(iInd)};
                [flag,MFind] = isInMultiunitField(MultiunitSess,FieldSess,Session);
                if ~flag
                    flag2 = isMultiunitField(MultiunitSess,FieldSess)
                    if flag2
                       % pause
                        tmpSession = createMultiunitField_Session(MultiunitSess,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding MF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createMultiunitField_Session(MultiunitSess,FieldSess);
                    disp(['Replacing MF Session ' num2str(tmpSession{6}) ' at position ' num2str(MFind)]);
                    Session{MFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
end

if SaveFlag
    disp('Saving MultiunitField_Session.mat')
    save([MONKEYDIR '/mat/MultiunitField_Session.mat'],'Session');
end
