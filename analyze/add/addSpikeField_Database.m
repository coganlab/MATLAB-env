function Session = addSpikeField_Database(SessNum1,SessNum2,Session)
%
% Session = addSpikeField_Database(SessNum1,SessNum2,Session)
%
%   Inputs: SessNum1 = Scalar.  Spike session number to be added
%           SessNum2 = Scalar.  Field session number to be added
%           Session = Cell array.  Original SpikeField Session info to save being
%                       loaded
%
%   Outputs: Session = Cell array.  New SpikeField Session info.
%

global MONKEYDIR

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3
    disp('Loading SpikeField_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeField_Session.mat'])
        Session = loadSpikeField_Database;
    else
        Session = [];
    end
end

FieldSessions = loadField_Database;
SpikeSessions = loadSpike_Database;

NumField = length(FieldSessions);
NumSpike = length(SpikeSessions);

if ~isempty(SessNum1) && ~isempty(SessNum2)
    SpikeSess = SpikeSessions{SessNum1};
    FieldSess = FieldSessions{SessNum2};
    [flag,ind] = isInSpikeField(SpikeSess,FieldSess,Session);
    if ~flag
        if isSpikeField(SpikeSess,FieldSess);
            tmpSession = createSpikeField_Session(SpikeSess,FieldSess);
            Ind = length(Session)+1;
            disp(['Adding SF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
            SaveFlag = 1;
        end
    else
        tmpSession = createSpikeField_Session(SpikeSess,FieldSess);
        disp(['Adding SF Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
        SaveFlag = 1;
    end
elseif ~isempty(SessNum2) && isempty(SessNum1)
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    FieldSess = FieldSessions{SessNum2};
    Day = FieldSess{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DaySpike));
        if ~isempty(ind)
            %DayTrials = dbSelectTrials(Day);
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
                SpikeSess = SpikeSessions{ind(iInd)};
                [flag,SFind] = isInSpikeField(SpikeSess,FieldSess,Session);
                if ~flag
                    if isSpikeField(SpikeSess,FieldSess)
                        tmpSession = createSpikeField_Session(SpikeSess,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeField_Session(SpikeSess,FieldSess);
                    disp(['Replacing SF Session ' num2str(tmpSession{6}) ' at position ' num2str(SFind)]);
                    Session{SFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
elseif ~isempty(SessNum1) && isempty(SessNum2)
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
        if ~isempty(ind)
            %DayTrials = dbSelectTrials(Day);
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Field Sessions to loop over']);
                FieldSess = FieldSessions{ind(iInd)};
                [flag,SFind] = isInSpikeField(SpikeSess,FieldSess,Session);
                if ~flag
                    flag2 = isSpikeField(SpikeSess,FieldSess);
                    if flag2
                       % pause
                        tmpSession = createSpikeField_Session(SpikeSess,FieldSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SF Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeField_Session(SpikeSess,FieldSess);
                    disp(['Replacing SF Session ' num2str(tmpSession{6}) ' at position ' num2str(SFind)]);
                    Session{SFind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
end

if SaveFlag
    disp('Saving SpikeField_Session.mat')
    save([MONKEYDIR '/mat/SpikeField_Session.mat'],'Session');
end
