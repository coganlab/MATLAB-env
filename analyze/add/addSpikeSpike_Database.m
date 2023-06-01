function addSpikeSpike_Database(SessNum1,SessNum2)
%
% addSpikeSpike_Database(SessNum1,SessNum2)
%

global MONKEYDIR 

SaveFlag = 0;
if nargin < 2; SessNum2 = []; end
if nargin < 3
    disp('Loading SpikeSpike_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeSpike_Session.mat'])
        Session = loadSpikeSpike_Database;
    else
        Session = [];
    end
end

SpikeSessions = loadSpike_Database;
NumSpike = length(SpikeSessions);

if isempty(SessNum1) && ~isempty(SessNum2)
    SessNum1 = SessNum2;
    SessNum2 = [];
end

if ~isempty(SessNum1) && ~isempty(SessNum2)
    SpikeSess1 = SpikeSessions{SessNum1};
    SpikeSess2 = SpikeSessions{SessNum2};
    [flag,ind] = isInSpikeSpike(SpikeSess1,SpikeSess2,Session);
    if ~flag
        if isSpikeSpike(SpikeSess1,SpikeSess2);
            tmpSession = createSpikeSpike_Session(SpikeSess1,SpikeSess2);
            Ind = length(Session)+1;
            disp(['Adding SpikeSpike Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
            Session{Ind} = tmpSession;
	    SaveFlag = 1;
        end
    else
        tmpSession = createSpikeSpike_Session(SpikeSess1,SpikeSess2);
        disp(['Adding SpikeSpike Session ' num2str(tmpSession{6}) ' to position ' num2str(ind)]);
        Session{ind} = tmpSession;
	SaveFlag = 1;
    end
elseif ~isempty(SessNum1) && isempty(SessNum2)     
    disp(['Processing all Spike Sessions ' num2str(SessNum1)]);
    for iSpike = 1:NumSpike
        DaySpike{iSpike} = SpikeSessions{iSpike}{1};
    end
    SpikeSess1 = SpikeSessions{SessNum1};
    Day = SpikeSess1{1};
    a = dir([MONKEYDIR '/' Day]);
    if ~isempty(a)
        ind = find(strcmp(Day,DaySpike));
        %DayTrials = dbSelectTrials(Day);
        for iInd = 1:length(ind)
            disp([num2str(iInd) ' of ' num2str(length(ind)) ' Spike Sessions to loop over']);
            SpikeSess2 = SpikeSessions{ind(iInd)};
            [flag,Spikeind] = isInSpikeSpike(SpikeSess1,SpikeSess2,Session);
            if ~flag
                if isSpikeSpike(SpikeSess1,SpikeSess2)
                    tmpSession = createSpikeSpike_Session(SpikeSess1,SpikeSess2);
                    Ind = length(Session)+1;
                    disp(['Not in database: Adding SpikeSpike Session ' num2str(tmpSession{6}) ' to position ' num2str(Ind)]);
                    Session{Ind} = tmpSession;
                    SaveFlag = 1;
                end
            else
                tmpSession = createSpikeSpike_Session(SpikeSess1,SpikeSess2);
                disp(['Replacing SpikeSpike Session ' num2str(tmpSession{6}) ' at position ' num2str(Spikeind)]);
                Session{Spikeind} = tmpSession;
                SaveFlag = 1;
            end
        end
    end
end

if SaveFlag
  disp('Saving SpikeSpike_Session.mat');
  save([MONKEYDIR '/mat/SpikeSpike_Session.mat'],'Session');
end
