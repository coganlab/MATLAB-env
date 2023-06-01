function updateSpikeMultiunit_NumTrials(SpikeSessNum,MultiunitSessNum)
%
%   updateSpikeMultiunit_NumTrials(SpikeSessNum,MultiunitSessNum)
%
%   Adds NumTrials data structure to SpikeMultiunit_NumTrials file
%
%   Modified to accept sessnum list


global MONKEYDIR

if nargin < 1; SpikeSessNum = []; end
if nargin < 2; MultiunitSessNum = []; end

if isempty(SpikeSessNum) && isempty(MultiunitSessNum)
    updateType_NumTrials('SpikeMultiunit');
else
    disp('Loading SpikeMultiunit_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeMultiunit_Session.mat'])
        Session = loadSpikeMultiunit_Database;
    else
        Session = [];
    end
    MSess = loadMultiunit_Database;
    SSess = loadSpike_Database;
    if ~isempty(SpikeSessNum) && ~isempty(MultiunitSessNum)
        MultiunitSess = MSess{MultiunitSessNum};
        SpikeSess = SSess{SpikeSessNum};
        [flag,SessNum] = isInSpikeMultiunit(SpikeSess,MultiunitSess,Session);
        if flag
            updateType_NumTrials('SpikeMultiunit',SessNum);
        end
    elseif isempty(SpikeSessNum) && ~isempty(MultiunitSessNum)
        MultiunitSess = MSess{MultiunitSessNum};
        SSessions = MtoS(MultiunitSess);
        for iSess = 1:length(SSessions)
            SpikeSess = SSessions{iSess};
            [flag,SessNum] = isInSpikeMultiunit(SpikeSess,MultiunitSess,Session);
            if flag
                updateType_NumTrials('SpikeMultiunit',SessNum);
            end
        end
    elseif ~isempty(SpikeSessNum) && isempty(MultiunitSessNum)
        SpikeSess = SSess{SpikeSessNum};
        MSessions = StoM(SpikeSess);
        for iSess = 1:length(MSessions)
            MultiunitSess = MSessions{iSess};
            [flag,SessNum] = isInSpikeMultiunit(SpikeSess,MultiunitSess,Session);
            if flag
                updateType_NumTrials('SpikeMultiunit',SessNum);
            end
        end
    end
end



