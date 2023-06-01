function addSpikeMultiunit_Database(SessNum1,SessNum2,Session)
%
% addSpikeMultiunit_Database(SessNum1,SessNum2,Session)
%

global MONKEYDIR 

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3
    disp('Loading SpikeMultiunit_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeMultiunit_Session.mat'])
        Session = loadSpikeMultiunit_Database;
    else
        Session = [];
    end
end

SpikeSessions = loadSpike_Database;
MultiunitSessions = loadMultiunit_Database;

NumSpike = length(SpikeSessions);
NumMultiunit = length(MultiunitSessions);

if ~isempty(SessNum1) && ~isempty(SessNum2)
    SpikeSess = SpikeSessions{SessNum1};
    MultiunitSess = MultiunitSessions{SessNum2};
    [flag,ind] = isInSpikeMultiunit(SpikeSess,MultiunitSess,Session);
    if ~flag
        if isSpikeMultiunit(SpikeSess,MultiunitSess);
            tmpSession = createSpikeMultiunit_Session(SpikeSess,MultiunitSess);
            Ind = length(Session)+1;
            disp(['Adding SpikeMultiunit Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
	    SaveFlag = 1;
        end
    else
        tmpSession = createSpikeMultiunit_Session(SpikeSess,MultiunitSess);
        disp(['Adding SpikeMultiunit Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
	SaveFlag = 1;
    end
elseif ~isempty(SessNum2) && isempty(SessNum1)
    DaySpike = cell(1,NumSpike);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    MultiunitSess = MultiunitSessions{SessNum2};
    Day = MultiunitSess{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DaySpike));
        if ~isempty(ind)
            %DayTrials = dbSelectTrials(Day);
            for iInd = 1:length(ind)
                disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
                SpikeSess = SpikeSessions{ind(iInd)};
                [flag,SMind] = isInSpikeMultiunit(SpikeSess,MultiunitSess,Session);
                if ~flag
                    if isSpikeMultiunit(SpikeSess,MultiunitSess)
                        tmpSession = createSpikeMultiunit_Session(SpikeSess,MultiunitSess);
                        Ind = length(Session)+1;
                        disp(['Not in database: Adding SpikeMultiunit Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                        Session{Ind} = tmpSession;
                        SaveFlag = 1;
                    end
                else
                    tmpSession = createSpikeMultiunit_Session(SpikeSess,MultiunitSess);
                    disp(['Replacing SpikeMultiunit Session ' num2str(tmpSession{6}) ' at position ' num2str(SMind)]);
                    Session{SMind} = tmpSession;
                    SaveFlag = 1;
                end
            end
        end
    end
elseif ~isempty(SessNum1) && isempty(SessNum2)
    DayMultiunit = cell(1,NumMultiunit);
    for iMultiunit = 1:NumMultiunit
        DayMultiunit{iMultiunit} = MultiunitSessions{iMultiunit}{1};
    end
    SpikeSess = SpikeSessions{SessNum1};
    Day = SpikeSess{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DayMultiunit));
        %DayTrials = dbSelectTrials(Day);
        for iInd = 1:length(ind)
            disp([num2str(iInd) ' of ' num2str(length(ind)) ' Multiunit Sessions to loop over']);
            MultiunitSess = MultiunitSessions{ind(iInd)};
            [flag,SMind] = isInSpikeMultiunit(SpikeSess,MultiunitSess,Session);
            if ~flag
                flag2 = isSpikeMultiunit(SpikeSess,MultiunitSess);
                    if flag2
                       % pause
                    tmpSession = createSpikeMultiunit_Session(SpikeSess,MultiunitSess);
                    Ind = length(Session)+1;
                    disp(['Not in database: Adding SpikeMultiunit Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                    Session{Ind} = tmpSession;
                    SaveFlag = 1;
                end
            else
                tmpSession = createSpikeMultiunit_Session(SpikeSess,MultiunitSess);
                disp(['Replacing SpikeMultiunit Session ' num2str(tmpSession{6}) ' at position ' num2str(SMind)]);
                Session{SMind} = tmpSession;
                SaveFlag = 1;
            end
        end
    end
end

if SaveFlag
  disp('Saving SpikeMultiunit_Session.mat');
  save([MONKEYDIR '/mat/SpikeMultiunit_Session.mat'],'Session');
end






