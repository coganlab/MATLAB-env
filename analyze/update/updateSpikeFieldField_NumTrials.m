function updateSpikeFieldField_NumTrials(SpikeSessNum,FieldSessNum1,FieldSessNum2)
%
%   updateSpikeFieldField_NumTrials(SpikeSessNum,FieldSessNum1,FieldSessNum2)
%
%   Adds NumTrials data structure to SpikeFieldField_NumTrials file
%
%   Modified to accept sessnum list

global MONKEYDIR

if nargin < 1; SpikeSessNum = []; end
if nargin < 2; FieldSessNum1 = []; end
if nargin < 3; FieldSessNum2 = []; end

if isempty(FieldSessNum1) && ~isempty(FieldSessNum2)
    FieldSessNum1 = FieldSessNum2;
    FieldSessNum2 = [];
end

if isempty(SpikeSessNum) && isempty(FieldSessNum1) && isempty(FieldSessNum2)
    updateType_NumTrials('SpikeFieldField');
else
    disp('Loading SpikeFieldField_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeFieldField_Session.mat'])
        Session = loadSpikeFieldField_Database;
    else
        Session = [];
    end
    FSess = loadField_Database;
    SSess = loadSpike_Database;
    if ~isempty(SpikeSessNum) && ~isempty(FieldSessNum1) && ~isempty(FieldSessNum2)        
        SpikeSess = SSess{SpikeSessNum};
        FieldSess1 = FSess{FieldSessNum1};
        FieldSess2 = FSess{FieldSessNum2};
        [flag,SessNum] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session);
        if flag
            updateType_NumTrials('SpikeFieldField',SessNum);
        end

    elseif isempty(SpikeSessNum) && ~isempty(FieldSessNum1) && isempty(FieldSessNum2)
        FieldSess1 = FSess{FieldSessNum1};
        SSessions = FtoS(FieldSess1);
        FSess2 = FtoF(FieldSess1);
        for iInd1 = 1:length(SSessions)
            SpikeSess = SSessions{iInd1};
            for iInd2 = 1:length(FSess2)
                FieldSess2 = FSess2{iInd2};
                [flag,SessNum] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session);
                if flag
                    updateType_NumTrials('SpikeFieldField',SessNum);
                end
            end
        end
 
    elseif ~isempty(SpikeSessNum) && isempty(FieldSessNum1) && isempty(FieldSessNum2)
        SpikeSess = SSess{SpikeSessNum};
        FSessions = StoF(SpikeSess);
        for iInd1 = 1:length(FSessions)
            FieldSess1 = FSessions{iInd1};
            for iInd2 = iInd1+1:length(FSessions)
                FieldSess2 = FSessions{iInd2};
                [flag,SessNum] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session);
                if flag
                    updateType_NumTrials('SpikeFieldField',SessNum);
                end
            end
        end
        
    elseif ~isempty(SpikeSessNum) && ~isempty(FieldSessNum1) && isempty(FieldSessNum2)
        SpikeSess = SSess{SpikeSessNum};
        FieldSess1 = FSess{FieldSessNum1};
        FSessions = StoF(SpikeSess);
        for iInd1 = 1:length(FSessions)
            FieldSess2 = FSessions{iInd1};
            [flag,SessNum] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session);
            if flag
                updateType_NumTrials('SpikeFieldField',SessNum);
            end
        end
                
    elseif isempty(SpikeSessNum) && ~isempty(FieldSessNum1) && ~isempty(FieldSessNum2)
        FieldSess1 = FSess{FieldSessNum1};
        FieldSess2 = FSess{FieldSessNum2};
        SSessions = FtoS(FieldSess1);
        for iSess = 1:length(SSessions)
            SpikeSess = SSessions{iSess};
            [flag,SessNum] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session);
            if flag
                updateType_NumTrials('SpikeFieldField',SessNum);
            end
        end
    end
end


