function [sigVals, sigIdx, sigMax, pValsRaw]=timePerm(aSig,bSig,nPerm,cTime,sAlpha,cFdr,numTails)

% Inputs:
% aSig = Active signal: trials x time
% bSig = Passive signal: trials x time
% nperm = Number of permutations: integer, default = 1000
% cTime = number of consecutive signals for significance: integer, default = 3
% sAlpha = alpha for significance: integer, default = 0.05
% cFdr = perform fdr?, 1= Yes, 0 = No, default = 1
% numTails = number of tails for test (1 or 2), defaults to 2
%
% Outputs:
% sigVals = Time series vector of 1s and 0s for significant time points
% sigIdx = Index of significant values from sigVals
% sigMax = Maximum size of cluster
% pValsRaw = Raw P values from shuffle

if nargin < 2
    display('Not enough inputs')
end

if nargin < 3 || isempty(nPerm)
    nPerm = 1000;
end

if nargin < 4 || isempty(cTime)
    cTime = 3;
end

if nargin < 5 || isempty(sAlpha)
    sAlpha = 0.05;
end

if nargin < 6 || isempty(cFdr)
    cFdr = 1;
end

if nargin < 7 || isempty(numTails)
    numTails = 2;
end

if size(aSig,2) ~= size(bSig,2)
    display('Signals have different time lengths')
end

% compute actual difference, shuffle, and compute pvalues
pValsRaw=zeros(size(aSig,2),1);
for iTime=1:size(aSig,2)
    actdiff=mean(aSig(:,iTime))-mean(bSig(:,iTime));
    combval=cat(1,aSig(:,iTime),bSig(:,iTime));
    permval=zeros(nPerm,1);
    for iPerm=1:nPerm
        sIdx=shuffle(1:size(combval,1));
        permval(iPerm)=mean(combval(sIdx(1:size(aSig,1))))-mean(combval(sIdx(size(aSig,1)+1:length(sIdx))));
    end
    if numTails==1
    pValsRaw(iTime)=length(find(permval>actdiff))./nPerm;
    elseif numTails==2
    pValsRaw(iTime)=length(find(abs(permval)>abs(actdiff)))./nPerm;
    end

end

% correct for multiple comparisons via fdr or don't
if cFdr==1
    [pmask pvalsM]=fdr(pValsRaw,sAlpha);
elseif cFdr==0
    pvalsM=zeros(size(pValsRaw,1),1);
    iiS=find(pValsRaw<sAlpha);
    pvalsM(iiS)=1;
end

% find connected significant activations, compute max size
tmp=bwconncomp(pvalsM);
if size(tmp.PixelIdxList,2)>0
    for ii=1:size(tmp.PixelIdxList,2);
        ii2(ii)=size(tmp.PixelIdxList{ii},1);
    end
    sigMax=max(ii2);
else
    sigMax=0;
end

% compute significant indexes
sigVals=zeros(1,size(aSig,2));
sigIdx=[];
if sigMax>=cTime
    ii3=find(ii2>=cTime);
   
    for ii4=1:length(ii3)
        sigIdx=cat(1,sigIdx,tmp.PixelIdxList{ii3(ii4)});
    end
    sigVals(sigIdx)=1;
end
 