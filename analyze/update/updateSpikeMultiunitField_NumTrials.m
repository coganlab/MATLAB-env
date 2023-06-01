function updateSpikeMultiunitField_NumTrials(SpikeSessNum,MultiunitSessNum,FieldSessNum)
%
%   updateSpikeMultiunitField_NumTrials(SessNum)
%
%   Adds NumTrials data structure to SpikeMultiunitField_NumTrials file
%
%   Modified to accept sessnum list


global MONKEYDIR

if nargin < 1; SpikeSessNum = []; end
if nargin < 2; MultiunitSessNum = []; end
if nargin < 3; FieldSessNum = []; end


if isempty(SpikeSessNum) && isempty(MultiunitSessNum) && isempty(FieldSessNum)
    updateType_NumTrials('SpikeMultiunitField');
else
    disp('Loading SpikeMultiunitField_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeMultiunitField_Session.mat'])
        Session = loadSpikeMultiunitField_Database;
    else
        Session = [];
    end
    SSess = loadSpike_Database;
    MSess = loadMultiunit_Database;
    FSess = loadField_Database;
    if ~isempty(SpikeSessNum) && ~isempty(MultiunitSessNum) && ~isempty(FieldSessNum)        
        SpikeSess = MSess{SpikeSessNum};
        MultiunitSess = MSess{MultiunitSessNum};
        FieldSess = FSess{FieldSessNum};
        [flag,SessNum] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
        if flag
            updateType_NumTrials('SpikeMultiunitField',SessNum);
        end

    elseif isempty(SpikeSessNum) && isempty(MultiunitSessNum) && ~isempty(FieldSessNum)
        FieldSess = FSess{FieldSessNum};
        SSessions = FtoS(FieldSess);
        MSessions = FtoM(FieldSess);
        for iInd1 = 1:length(SSessions)
            SpikeSess = SSessions{iInd1};
            for iInd2 = 1:length(MSessions)
                MultiunitSess = MSessions{iInd2};
                [flag,SessNum] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
                if flag
                    updateType_NumTrials('SpikeMultiunitField',SessNum);
                end
            end
        end
 
    elseif ~isempty(SpikeSessNum) && isempty(MultiunitSessNum) && isempty(FieldSessNum)
        SpikeSess = SSess{SpikeSessNum};
        FSessions = StoF(SpikeSess);
        MSessions = StoM(SpikeSess);
        for iInd1 = 1:length(FSessions)
            FieldSess = FSessions{iInd1};
            for iInd2 = 1:length(MSessions)
                MultiunitSess = MSessions{iInd2};
                [flag,SessNum] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
                if flag
                    updateType_NumTrials('SpikeMultiunitField',SessNum);
                end
            end
        end
        
    elseif isempty(SpikeSessNum) && ~isempty(MultiunitSessNum) && isempty(FieldSessNum)
        MultiunitSess = MSess{MultiunitSessNum};
        FSessions = MtoF(MultiunitSess);
        SSessions = MtoS(MultiunitSess);
        for iInd1 = 1:length(FSessions)
            FieldSess = FSessions{iInd1};
            for iInd2 = 1:length(SSessions)
                SpikeSess = SSessions{iInd2};
                [flag,SessNum] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
                if flag
                    updateType_NumTrials('SpikeMultiunitField',SessNum);
                end
            end
        end
        
    elseif ~isempty(SpikeSessNum) && ~isempty(MultiunitSessNum) && isempty(FieldSessNum)
        SpikeSess = SSess{SpikeSessNum};
        MultiunitSess = MSess{MultiunitSessNum};
        FSessions = StoF(SpikeSess);
        for iInd1 = 1:length(FSessions)
            FieldSess = FSessions{iInd1};
            [flag,SessNum] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
            if flag
                updateType_NumTrials('SpikeMultiunitField',SessNum);
            end
        end
                
    elseif ~isempty(SpikeSessNum) && isempty(MultiunitSessNum) && ~isempty(FieldSessNum)
        SpikeSess = SSess{SpikeSessNum};
        FieldSess = FSess{FieldSessNum};
        MSessions = StoM(SpikeSess);
        for iSess = 1:length(MSessions)
            MultiunitSess = MSessions{iSess};
            [flag,SessNum] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
            if flag
                updateType_NumTrials('SpikeMultiunitField',SessNum);
            end
        end
        
    elseif isempty(SpikeSessNum) && ~isempty(MultiunitSessNum) && ~isempty(FieldSessNum)
        MultiunitSess = MSess{MultiunitSessNum};
        FieldSess = FSess{FieldSessNum};
        SSessions = MtoS(MultiunitSess);
        for iSess = 1:length(SSessions)
            SpikeSess = SSessions{iSess};
            [flag,SessNum] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session);
            if flag
                updateType_NumTrials('SpikeMultiunitField',SessNum);
            end
        end
    end
end



