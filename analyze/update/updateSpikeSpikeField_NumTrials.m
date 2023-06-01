function updateSpikeSpikeField_NumTrials(SpikeSessNum1,SpikeSessNum2,FieldSessNum)
%
%   updateSpikeSpikeField_NumTrials(SessNum)
%
%   Adds NumTrials data structure to SpikeSpikeField_NumTrials file
%
%   Modified to accept sessnum list


global MONKEYDIR

if nargin < 1; SpikeSessNum1 = []; end
if nargin < 2; SpikeSessNum2 = []; end
if nargin < 3; FieldSessNum = []; end

if isempty(SpikeSessNum1) && ~isempty(SpikeSessNum2)
    SpikeSessNum1 = SpikeSessNum2;
    SpikeSessNum2 = [];
end

if isempty(SpikeSessNum1) && isempty(SpikeSessNum2) && isempty(FieldSessNum)
    updateType_NumTrials('SpikeSpikeField');
else
    disp('Loading SpikeSpikeField_Session.mat');
    if isfile([MONKEYDIR '/mat/SpikeSpikeField_Session.mat'])
        Session = loadSpikeSpikeField_Database;
    else
        Session = [];
    end
    FSess = loadField_Database;
    SSess = loadSpike_Database;
    if ~isempty(SpikeSessNum1) && ~isempty(SpikeSessNum2) && ~isempty(FieldSessNum)        
        SpikeSess1 = SSess{SpikeSessNum1};
        SpikeSess2 = SSess{SpikeSessNum2};
        FieldSess = FSess{FieldSessNum};
        [flag,SessNum] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session);
        if flag
            updateType_NumTrials('SpikeSpikeField',SessNum);
        end

    elseif isempty(SpikeSessNum1) && isempty(SpikeSessNum2) && ~isempty(FieldSessNum)
        FieldSess = FSess{FieldSessNum};
        SSessions = FtoS(FieldSess);
        for iInd1 = 1:length(SSessions)
            SpikeSess1 = SSessions{iInd1};
            for iInd2 = 1:length(SSessions)
                SpikeSess2 = SSessions{iInd2};
                [flag,SessNum] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session);
                if flag
                    updateType_NumTrials('SpikeSpikeField',SessNum);
                end
            end
        end
 
    elseif ~isempty(SpikeSessNum1) && isempty(SpikeSessNum2) && isempty(FieldSessNum)
        SpikeSess1 = SSess{SpikeSessNum1};
        FSessions = StoF(SpikeSess1);
        SSess2 = StoS(SpikeSess1);
        for iInd1 = 1:length(FSessions)
            FieldSess = FSessions{iInd1};
            for iInd2 = 1:length(SSess2)
                SpikeSess2 = SSess2{iInd2};
                [flag,SessNum] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session);
                if flag
                    updateType_NumTrials('SpikeSpikeField',SessNum);
                end
            end
        end
        
    elseif ~isempty(SpikeSessNum1) && ~isempty(SpikeSessNum2) && isempty(FieldSessNum)
        SpikeSess1 = SSess{SpikeSessNum1};
        SpikeSess2 = SSess{SpikeSessNum2};
        FSessions = StoF(SpikeSess1);
        for iInd1 = 1:length(FSessions)
            FieldSess = FSessions{iInd1};
            [flag,SessNum] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session);
            if flag
                updateType_NumTrials('SpikeSpikeField',SessNum);
            end
        end
                
    elseif ~isempty(SpikeSessNum1) && isempty(SpikeSessNum2) && ~isempty(FieldSessNum)
        SpikeSess1 = SSess{SpikeSessNum};
        FieldSess = FSess{FieldSessNum};
        SSessions = StoS(SpikeSess1);
        for iSess = 1:length(SSessions)
            SpikeSess2 = SSessions{iSess};
            [flag,SessNum] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session);
            if flag
                updateType_NumTrials('SpikeSpikeField',SessNum);
            end
        end
    end
end

