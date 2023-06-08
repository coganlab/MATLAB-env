function addMultiunitMultiunit_Database(SessNum1,SessNum2,Session)
%
% addMultiunitMultiunit_Database(SessNum1,SessNum2)
%

global MONKEYDIR 

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3
    disp('Loading MultiunitMultiunit_Session.mat');
    if isfile([MONKEYDIR '/mat/MultiunitMultiunit_Session.mat'])
        Session = loadMultiunitMultiunit_Database;
    else
        Session = [];
    end
end

MultiunitSessions = loadMultiunit_Database;
NumMultiunit = length(MultiunitSessions);

if isempty(SessNum1) && ~isempty(SessNum2)
    SessNum1 = SessNum2;
    SessNum2 = [];
end

if ~isempty(SessNum1) && ~isempty(SessNum2)
    MultiunitSess1 = MultiunitSessions{SessNum1};
    MultiunitSess2 = MultiunitSessions{SessNum2};
    [flag,ind] = isInMultiunitMultiunit(MultiunitSess1,MultiunitSess2,Session);
    if ~flag
        if isMultiunitMultiunit(MultiunitSess1,MultiunitSess2);
            tmpSession = createMultiunitMultiunit_Session(MultiunitSess1,MultiunitSess2);
            Ind = length(Session)+1;
            disp(['Adding MultiunitMultiunit Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
	    SaveFlag = 1;
        end
    else
        tmpSession = createMultiunitMultiunit_Session(MultiunitSess1,MultiunitSess2);
        disp(['Adding MultiunitMultiunit Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
	SaveFlag = 1;
    end
elseif ~isempty(SessNum1) && isempty(SessNum2)  
    disp(['Processing all Multiunit Sessions ' num2str(SessNum1)]);
    for iMultiunit = 1:NumMultiunit
        DayMultiunit{iMultiunit} = MultiunitSessions{iMultiunit}{1};
    end
    MultiunitSess1 = MultiunitSessions{SessNum1};
    Day = MultiunitSess1{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayMultiunit));
        %DayTrials = dbSelectTrials(Day);
        for iInd = 1:length(ind)
            disp([num2str(iInd) ' of ' num2str(length(ind)) ' Multiunit Sessions to loop over']);
            MultiunitSess2 = MultiunitSessions{ind(iInd)};
            [flag,Multiunitind] = isInMultiunitMultiunit(MultiunitSess1,MultiunitSess2,Session);
            if ~flag
                if isMultiunitMultiunit(MultiunitSess1,MultiunitSess2)
                    tmpSession = createMultiunitMultiunit_Session(MultiunitSess1,MultiunitSess2);
                    Ind = length(Session)+1;
                    disp(['Not in database: Adding MultiunitMultiunit Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                    Session{Ind} = tmpSession;
                    SaveFlag = 1;
                end
            else
                tmpSession = createMultiunitMultiunit_Session(MultiunitSess1,MultiunitSess2);
                disp(['Replacing MultiunitMultiunit Session ' num2str(tmpSession{6}) ' at position ' num2str(Multiunitind)]);
                Session{Multiunitind} = tmpSession;
                SaveFlag = 1;
            end
        end
    end
end

if SaveFlag
  disp('Saving MultiunitMultiunit_Session.mat');
  save([MONKEYDIR '/mat/MultiunitMultiunit_Session.mat'],'Session');
end
