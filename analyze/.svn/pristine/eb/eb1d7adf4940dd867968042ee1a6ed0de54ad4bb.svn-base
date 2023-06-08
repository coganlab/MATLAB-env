function addFieldField_Database(SessNum1,SessNum2)
%
% addFieldField_Database(SessNum1,SessNum2)
%

global MONKEYDIR

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3
    disp('Loading FieldField_Session.mat');
    if isfile([MONKEYDIR '/mat/FieldField_Session.mat'])
        Session = loadFieldField_Database;
    else
        Session = [];
    end
end

FieldSessions = loadField_Database;
NumField = length(FieldSessions);

if nargin == 2 && ~isempty(SessNum1)
    FieldSess1 = FieldSessions{SessNum1};
    FieldSess2 = FieldSessions{SessNum2};
    [flag,ind] = isInFieldField(FieldSess1,FieldSess2,Session);
    if ~flag
        if isFieldField(FieldSess1,FieldSess2);
            tmpSession = createFieldField_Session(FieldSess1,FieldSess2);
            Ind = length(Session)+1;
            disp(['Adding FF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
	    SaveFlag = 1;
        end
    else
        tmpSession = createFieldField_Session(FieldSess1,FieldSess2);
        disp(['Adding FF Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
	SaveFlag = 1;
    end
elseif nargin == 1 && ~isempty(SessNum1)
    disp(['Processing all Field Sessions ' num2str(SessNum1)]);
    for iField = 1:NumField
        DayField{iField} = FieldSessions{iField}{1};
    end
    FieldSess1 = FieldSessions{SessNum1};
    Day = FieldSess1{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayField));
        %DayTrials = dbSelectTrials(Day);
        for iInd = 1:length(ind)
            disp([num2str(iInd) ' of ' num2str(length(ind)) ' Field Sessions to loop over']);
            FieldSess2 = FieldSessions{ind(iInd)};
            [flag,FFind] = isInFieldField(FieldSess1,FieldSess2,Session);
            if ~flag
                if isFieldField(FieldSess1,FieldSess2)
                    tmpSession = createFieldField_Session(FieldSess1,FieldSess2);
                    Ind = length(Session)+1;
                    disp(['Not in database: Adding FF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                    Session{Ind} = tmpSession;
                    SaveFlag = 1;
                end
            else
                tmpSession = createFieldField_Session(FieldSess1,FieldSess2);
                disp(['Replacing FF Session ' num2str(tmpSession{6}) ' at position ' num2str(FFind)]);
                Session{FFind} = tmpSession;
                SaveFlag = 1;
            end
        end
    end
end

if SaveFlag
  disp('Saving FieldField_Session.mat');
  save([MONKEYDIR '/mat/FieldField_Session.mat'],'Session');
end
