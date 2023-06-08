function updateMultiunitMultiunitField_NumTrials(MultiunitSessNum1,MultiunitSessNum2,FieldSessNum)
%
%   updateMultiunitMultiunitField_NumTrials(SessNum)
%
%   Adds NumTrials data structure to MultiunitMultiunitField_NumTrials file
%
%   Modified to accept sessnum list


global MONKEYDIR

if nargin < 1; MultiunitSessNum1 = []; end
if nargin < 2; MultiunitSessNum2 = []; end
if nargin < 3; FieldSessNum = []; end

if isempty(MultiunitSessNum1) && ~isempty(MultiunitSessNum2)
    MultiunitSessNum1 = MultiunitSessNum2;
    MultiunitSessNum2 = [];
end

if isempty(MultiunitSessNum1) && isempty(MultiunitSessNum2) && isempty(FieldSessNum)
    updateType_NumTrials('MultiunitMultiunitField');
else
    disp('Loading MultiunitMultiunitField_Session.mat');
    if isfile([MONKEYDIR '/mat/MultiunitMultiunitField_Session.mat'])
        Session = loadMultiunitMultiunitField_Database;
    else
        Session = [];
    end
    FSess = loadField_Database;
    MSess = loadMultiunit_Database;
    if ~isempty(MultiunitSessNum1) && ~isempty(MultiunitSessNum2) && ~isempty(FieldSessNum)        
        MultiunitSess1 = MSess{MultiunitSessNum1};
        MultiunitSess2 = MSess{MultiunitSessNum2};
        FieldSess = FSess{FieldSessNum};
        [flag,SessNum] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session);
        if flag
            updateType_NumTrials('MultiunitMultiunitField',SessNum);
        end

    elseif isempty(MultiunitSessNum1) && isempty(MultiunitSessNum2) && ~isempty(FieldSessNum)
        FieldSess = FSess{FieldSessNum};
        MSessions = FtoM(FieldSess);
        for iInd1 = 1:length(MSessions)
            MultiunitSess1 = MSessions{iInd1};
            for iInd2 = 1:length(MSessions)
                MultiunitSess2 = MSessions{iInd2};
                [flag,SessNum] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session);
                if flag
                    updateType_NumTrials('MultiunitMultiunitField',SessNum);
                end
            end
        end
 
    elseif ~isempty(MultiunitSessNum1) && isempty(MultiunitSessNum2) && isempty(FieldSessNum)
        MultiunitSess1 = MSess{MultiunitSessNum1};
        FSessions = MtoF(MultiunitSess1);
        MSess2 = MtoM(MultiunitSess1);
        for iInd1 = 1:length(FSessions)
            FieldSess = FSessions{iInd1};
            for iInd2 = 1:length(MSess2)
                MultiunitSess2 = MSess2{iInd2};
                [flag,SessNum] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session);
                if flag
                    updateType_NumTrials('MultiunitMultiunitField',SessNum);
                end
            end
        end
        
    elseif ~isempty(MultiunitSessNum1) && ~isempty(MultiunitSessNum2) && isempty(FieldSessNum)
        MultiunitSess1 = MSess{MultiunitSessNum1};
        MultiunitSess2 = MSess{MultiunitSessNum2};
        FSessions = MtoF(MultiunitSess1);
        for iInd1 = 1:length(FSessions)
            FieldSess = FSessions{iInd1};
            [flag,SessNum] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session);
            if flag
                updateType_NumTrials('MultiunitMultiunitField',SessNum);
            end
        end
                
    elseif ~isempty(MultiunitSessNum1) && isempty(MultiunitSessNum2) && ~isempty(FieldSessNum)
        MultiunitSess1 = MSess{MultiunitSessNum};
        FieldSess = FSess{FieldSessNum};
        MSessions = MtoM(MultiunitSess1);
        for iSess = 1:length(MSessions)
            MultiunitSess2 = MSessions{iSess};
            [flag,SessNum] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session);
            if flag
                updateType_NumTrials('MultiunitMultiunitField',SessNum);
            end
        end
    end
end

