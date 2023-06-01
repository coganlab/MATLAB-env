function updateSpikeSpike_NumTrials(SessNum1,SessNum2)
%
%   updateSpikeSpike_NumTrials(SessNum1,SessNum2)
%
%   Adds NumTrials data structure to SpikeSpike_NumTrials file
%
%   Modified to accept sessnum list

global MONKEYDIR

if nargin < 1; SessNum1 = []; end
if nargin < 2; SessNum2 = []; end

if isempty(SessNum1) && ~isempty(SessNum2)
    SessNum1 = SessNum2;
    SessNum2 = [];
end

if isempty(SessNum1) && isempty(SessNum2)
    updateType_NumTrials('SpikeSpike');
else
    disp('Loading SpikeSpike_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeSpike_Session.mat'])
        Session = loadSpikeSpike_Database;
    else
        Session = [];
    end
    SSess = loadSpike_Database;
    if ~isempty(SessNum1) && ~isempty(SessNum2)
        SpikeSess1 = SSess{SessNum1};
        SpikeSess2 = SSess{SessNum2};
        [flag,SessNum] = isInSpikeSpike(SpikeSess1,SpikeSess2,Session);
        if flag
            updateType_NumTrials('SpikeSpike',SessNum);
        end
    elseif ~isempty(SessNum1) && isempty(SessNum2)
        SpikeSess1 = SSess{SessNum1};
        SSessions = StoS(SpikeSess1);
        for iSess = 1:length(SSessions)
            SpikeSess2 = SSessions{iSess};
            [flag,SessNum] = isInSpikeSpike(SpikeSess1,SpikeSess2,Session);
            if flag
                updateType_NumTrials('SpikeSpike',SessNum);
            end
        end
    end
end

