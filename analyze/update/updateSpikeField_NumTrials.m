function updateSpikeField_NumTrials(SpikeSessNum,FieldSessNum)
%
%   updateSpikeField_NumTrials(SpikeSessNum,FieldSessNum)
%
%   Adds NumTrials data structure to SpikeField_NumTrials file
%
%   Modified to accept sessnum list

global MONKEYDIR

if nargin < 1; SpikeSessNum = []; end
if nargin < 2; FieldSessNum = []; end

if isempty(SpikeSessNum) && isempty(FieldSessNum)
    updateType_NumTrials('SpikeField');
else
    disp('Loading SpikeField_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeField_Session.mat'])
        Session = loadSpikeField_Database;
    else
        Session = [];
    end
    FSess = loadField_Database;
    SSess = loadSpike_Database;
    if ~isempty(SpikeSessNum) && ~isempty(FieldSessNum)
        FieldSess = FSess{FieldSessNum};
        SpikeSess = SSess{SpikeSessNum};
        [flag,SessNum] = isInSpikeField(SpikeSess,FieldSess,Session);
        if flag
            updateType_NumTrials('SpikeField',SessNum);
        end
    elseif isempty(SpikeSessNum) && ~isempty(FieldSessNum)
        FieldSess = FSess{FieldSessNum};
        SSessions = FtoS(FieldSess);
        for iSess = 1:length(SSessions)
            SpikeSess = SSessions{iSess};
            [flag,SessNum] = isInSpikeField(SpikeSess,FieldSess,Session);
            if flag
                updateType_NumTrials('SpikeField',SessNum);
            end
        end
    elseif ~isempty(SpikeSessNum) && isempty(FieldSessNum)
        SpikeSess = SSess{SpikeSessNum};
        FSessions = StoF(SpikeSess);
        for iSess = 1:length(FSessions)
            FieldSess = FSessions{iSess};
            [flag,SessNum] = isInSpikeField(SpikeSess,FieldSess,Session);
            if flag
                updateType_NumTrials('SpikeField',SessNum);
            end
        end
    end
end

