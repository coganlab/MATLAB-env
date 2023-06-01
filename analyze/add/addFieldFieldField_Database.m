function Session = addFieldFieldField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Session = addFieldFieldField_Database(SessNum1,SessNum2,SessNum3,Session)
%
% Putting in restriction that SessNum2 > SessNum3

global MONKEYDIR

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3; SessNum3 = []; end
if nargin < 4
    disp('Loading FieldFieldField_Session.mat');
    if isfile([MONKEYDIR '/mat/FieldFieldField_Session.mat'])
        Session = loadFieldFieldField_Database;
    else
        Session = [];
    end
end

FieldSessions = loadField_Database;

NumField = length(FieldSessions);

if ~isempty(SessNum1) && ~isempty(SessNum2) && ~isempty(SessNum3)
    FieldSess1 = FieldSessions{SessNum1};
    FieldSess2 = FieldSessions{SessNum2};
    FieldSess3 = FieldSessions{SessNum3};
    [flag,ind] = isInFieldFieldField(FieldSess1,FieldSess2,FieldSess3,Session);
    if ~flag
        if isFieldFieldField(FieldSess1,FieldSess2,FieldSess3);
            tmpSession = createFieldFieldField_Session(FieldSess1,FieldSess2,FieldSess3);
            Ind = length(Session)+1;
            disp(['Adding FFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
            SaveFlag = 1;
        end
    else
        tmpSession = createFieldFieldField_Session(FieldSess1,FieldSess2,FieldSess3);
        disp(['Adding FFF Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
        SaveFlag = 1;
    end
elseif ~isempty(SessNum1) && isempty(SessNum2) && isempty(SessNum3)
    %disp(['Processing Field Session ' num2str(SessNum1)]);
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    FieldSess1 = FieldSessions{SessNum1};
    Day = FieldSess1{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayField));
        ind = setdiff(find(strcmp(Day,DayField)),SessNum1); %Set so that you don't include original field
        if length(ind) > 1
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Field Sessions to loop over']);
                FieldSess2 = FieldSessions{ind(iInd)};
                ind2 = ind(ind>ind(iInd));
                for iInd2 = 1:length(ind2)
                    FieldSess3 = FieldSessions{ind2(iInd2)};
                    [flag,FFFind] = isInFieldFieldField(FieldSess1,FieldSess2,FieldSess3,Session);
                    if ~flag
                        flag2 = isFieldFieldField(FieldSess1,FieldSess2,FieldSess3);
                        if flag2
                            % pause
                            tmpSession = createFieldFieldField_Session(FieldSess1,FieldSess2,FieldSess3);
                            Ind = length(Session)+1;
                            disp(['Not in database: Adding FFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                            Session{Ind} = tmpSession;
                            SaveFlag = 1;
                        end
                    else
                        tmpSession = createFieldFieldField_Session(FieldSess1,FieldSess2,FieldSess3);
                        disp(['Replacing FFF Session ' num2str(tmpSession{6}) ' at position ' num2str(FFFind)]);
                        Session{FFFind} = tmpSession;
                        SaveFlag = 1;
                    end
                end
            end
        end
    end
elseif ~isempty(SessNum1) && ~isempty(SessNum2) && isempty(SessNum3)
    %disp(['Processing Field Session ' num2str(SessNum1)]);
    DayField = cell(1,NumField);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    FieldSess1 = FieldSessions{SessNum1};
    FieldSess2 = FieldSessions{SessNum2};
    DayCell = intersect(FieldSess1(1),FieldSess2(1));
    if ~isempty(DayCell)
        Day = DayCell{1}; %Note: this cannot deal with multiple days
    else
        Day = 'jkl';
    end
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = setdiff(find(strcmp(Day,DayField)),SessNum1,SessNum2);
        if ~isempty(ind)
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Field Sessions to loop over']);
                FieldSess3 = FieldSessions{ind(iInd)};
                [flag,FFFind] = isInFieldFieldField(FieldSess1,FieldSess2,FieldSess3,Session);
                if ~flag
                    flag2 = isFieldFieldField(FieldSess1,FieldSess2,FieldSess3);
                    if flag2
                        % pause
                        tmpSession = createFieldFieldField_Session(FieldSess1,FieldSess2,FieldSess3);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding FFF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createFieldFieldField_Session(FieldSess1,FieldSess2,FieldSess3);
                    disp(['Replacing FFF Session ' num2str(tmpSession{6}) ' at position ' num2str(FFFind)]);
                    Session{FFFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
end

if SaveFlag
    disp('Saving FieldFieldField_Session.mat')
    save([MONKEYDIR '/mat/FieldFieldField_Session.mat'],'Session');
end

