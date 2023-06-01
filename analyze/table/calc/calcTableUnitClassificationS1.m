function Value = calcUnitClassificationS1(Session,CondParams,AnalParams)
%
%  Value = calcUnitClassification(Session,CondParams,AnalParams)
%  Send in several CondParams to check several epochs
%  SaccadeData first

global MONKEYDIR

SSess = splitSession(Session);
Sess = SSess{1};
Type = getSessionType(Sess);
p_limit = 0.02;

dirPath = [MONKEYDIR '/mat/' Type '/RateDiff'];
fNameRoot = ['RateDiff.Sess' num2str(Sess{6}) ];


for iCond = 1:length(CondParams)
    [p,pMax] = getParamFileIndex([dirPath '/' fNameRoot],CondParams{iCond},[]);
    if p > 0
        RateDiff = loadSessRateDiff(Sess,CondParams{iCond});
    else
        RateDiff = saveSessRateDiff(Sess,CondParams{iCond});
    end
    
    % Step 2: Organize p values into a matrix for easy search
    if RateDiff.p < p_limit
        if mean(RateDiff.Rate1) < mean(RateDiff.Rate2)
            pvalMatrix(iCond) = 0;
        else
            pvalMatrix(iCond) = 1;
        end
    else
        pvalMatrix(iCond) = 0.5;
    end
end

% % Step 3: Sort Sessions into groups
tmp1 = find(pvalMatrix == 1);
tmp2 = find(pvalMatrix == 0);

% Reach
if ~isempty(tmp1) && isempty(tmp2)
    Value = 1;
end
%Saccade
if ~isempty(tmp2) && isempty(tmp1)
    Value = 2;
end
%NonSig
if (isempty(tmp1) && isempty(tmp2)) || (~isempty(tmp1) && ~isempty(tmp2))
    Value = 0;
end



