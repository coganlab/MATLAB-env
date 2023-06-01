function updateMultiunitFieldField_NumTrials(MultiunitSessNum,FieldSessNum1,FieldSessNum2)
%
%   updateMultiunitFieldField_NumTrials(MultiunitSessNum,FieldSessNum1,FieldSessNum2)
%
%   Adds NumTrials data structure to MultiunitFieldField_NumTrials file
%
%   Modified to accept sessnum list

global MONKEYDIR

if nargin < 1; MultiunitSessNum = []; end
if nargin < 2; FieldSessNum1 = []; end
if nargin < 3; FieldSessNum2 = []; end

if isempty(FieldSessNum1) && ~isempty(FieldSessNum2)
    FieldSessNum1 = FieldSessNum2;
    FieldSessNum2 = [];
end

if isempty(MultiunitSessNum) && isempty(FieldSessNum1) && isempty(FieldSessNum2)
    updateType_NumTrials('MultiunitFieldField');
else
    disp('Loading MultiunitFieldField_Session.mat');
    if isfile([MONKEYDIR '/mat/MultiunitFieldField_Session.mat'])
        Session = loadMultiunitFieldField_Database;
    else
        Session = [];
    end
    FSess = loadField_Database;
    MSess = loadMultiunit_Database;
    if ~isempty(MultiunitSessNum) && ~isempty(FieldSessNum1) && ~isempty(FieldSessNum2)        
        MultiunitSess = MSess{MultiunitSessNum};
        FieldSess1 = FSess{FieldSessNum1};
        FieldSess2 = FSess{FieldSessNum2};
        [flag,SessNum] = isInMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2,Session);
        if flag
            updateType_NumTrials('MultiunitFieldField',SessNum);
        end

    elseif isempty(MultiunitSessNum) && ~isempty(FieldSessNum1) && isempty(FieldSessNum2)
        FieldSess1 = FSess{FieldSessNum1};
        MSessions = FtoM(FieldSess1);
        FSess2 = FtoF(FieldSess1);
        for iInd1 = 1:length(MSessions)
            MultiunitSess = MSessions{iInd1};
            for iInd2 = 1:length(FSess2)
                FieldSess2 = FSess2{iInd2};
                [flag,SessNum] = isInMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2,Session);
                if flag
                    updateType_NumTrials('MultiunitFieldField',SessNum);
                end
            end
        end
 
    elseif ~isempty(MultiunitSessNum) && isempty(FieldSessNum1) && isempty(FieldSessNum2)
        MultiunitSess = MSess{MultiunitSessNum};
        FSessions = MtoF(MultiunitSess);
        for iInd1 = 1:length(FSessions)
            FieldSess1 = FSessions{iInd1};
            for iInd2 = iInd1+1:length(FSessions)
                FieldSess2 = FSessions{iInd2};
                [flag,SessNum] = isInMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2,Session);
                if flag
                    updateType_NumTrials('MultiunitFieldField',SessNum);
                end
            end
        end
        
    elseif ~isempty(MultiunitSessNum) && ~isempty(FieldSessNum1) && isempty(FieldSessNum2)
        MultiunitSess = MSess{MultiunitSessNum};
        FieldSess1 = FSess{FieldSessNum1};
        FSessions = MtoF(MultiunitSess);
        for iInd1 = 1:length(FSessions)
            FieldSess2 = FSessions{iInd1};
            [flag,SessNum] = isInMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2,Session);
            if flag
                updateType_NumTrials('MultiunitFieldField',SessNum);
            end
        end
                
    elseif isempty(MultiunitSessNum) && ~isempty(FieldSessNum1) && ~isempty(FieldSessNum2)
        FieldSess1 = FSess{FieldSessNum1};
        FieldSess2 = FSess{FieldSessNum2};
        MSessions = FtoM(FieldSess1);
        for iSess = 1:length(MSessions)
            MultiunitSess = MSessions{iSess};
            [flag,SessNum] = isInMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2,Session);
            if flag
                updateType_NumTrials('MultiunitFieldField',SessNum);
            end
        end
    end
end


