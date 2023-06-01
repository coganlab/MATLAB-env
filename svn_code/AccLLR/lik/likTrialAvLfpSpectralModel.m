function TrialAv = ...
    likTrialAvLfpSpectralModel(LfpEvent, LfpNull, InputParams, LfpParams)
%
% TrialAv = likTrialAvLfpSpectralModel(LfpEvent, LfpNull, InputParams, LfpParams)
%
%   Inputs:
%
%   Outputs:
%       TrialAv.LREvent
%       TrialAv.LRNull
%       TrialAv.EventModel
%       TrialAv.NullModel

tapers = LfpParams.Tapers;
dn = LfpParams.Dn;
fk = LfpParams.Fk;
if length(fk)==1; fk = [0,fk]; end
df = LfpParams.Df;

K = floor(2*tapers(1).*tapers(2) - 1);

if(iscell(LfpEvent))
    nSess = length(LfpEvent);
else
    nSess = 1;
    myLfpNull{1} = LfpNull;
    myLfpEvent{1} = LfpEvent;
    LfpNull = myLfpNull; LfpEvent = myLfpEvent;
end

NumTrials = InputParams.TrialAvNumTrials;
nTestReps = InputParams.TrialAvIterations;

%find minimum number of trials
minNumTrials = length(NumTrials{1});
if nSess > 1
    for iSess = 2:nSess
        minNumTrials = min(minNumTrials,length(NumTrials{iSess}));
    end
end

SpecEvent = cell(1,nSess);
SpecNull = cell(1,nSess);
SpecMeanEvent = cell(1,nSess);
SpecMeanNull = cell(1,nSess);
nTrEvent = zeros(1,nSess);
nTrNull = zeros(1,nSess);
for iSess = 1:nSess
    SpecEvent_tmp = log(tfspec(LfpEvent{iSess},tapers,1e3,dn,fk));
    SpecNull_tmp = log(tfspec(LfpNull{iSess},tapers,1e3,dn,fk));
    
    dftobn = round(df.*size(SpecEvent_tmp,3)./diff(fk));
    SpecEvent{iSess} = SpecEvent_tmp(:,:,1:dftobn:end);
    SpecNull{iSess} = SpecNull_tmp(:,:,1:dftobn:end);
    
    SpecMeanEvent{iSess} = sq(mean(SpecEvent{iSess},1));
    SpecMeanNull{iSess} = sq(mean(SpecNull{iSess},1));
    
    nTrEvent(iSess) = size(LfpEvent{iSess},1);
    nTrNull(iSess) = size(LfpNull{iSess},1);
    nT = size(SpecMeanEvent{iSess},1);
end

NumTrials = InputParams.TrialAvNumTrials;
nTestReps = InputParams.TrialAvIterations;

%find minimum number of trials
minNumTrials = length(NumTrials{1});
if nSess > 1
    for iSess = 2:nSess
        minNumTrials = min(minNumTrials,length(NumTrials{iSess}));
    end
end

total_LRLfpEvent = cell(1,minNumTrials);
total_LRLfpNull = cell(1,minNumTrials);
for iNumTrials = 1:minNumTrials
    
    LRLfpEvent = cell(1,nSess);
    for iSess = 1:nSess
        LRLfpEvent_tmp = zeros(nTestReps(iNumTrials),nT);
        for iRep = 1:nTestReps(iNumTrials)
            TrialPerm = randperm(nTrEvent(iSess));
            TrainTrials = TrialPerm(1:end-NumTrials{iSess}(iNumTrials));
            TestTrials = TrialPerm(end-NumTrials{iSess}(iNumTrials)+1:end);
            SpecMeanEventTr = sq(sum(SpecEvent{iSess}(TrainTrials,:,:)))./length(TrainTrials);
            LRtmp = ...
                likLR_Spectral(sq(mean(SpecEvent{iSess}(TestTrials,:,:))), SpecMeanEventTr, ...
                SpecMeanNull{iSess}, K*NumTrials{iSess}(iNumTrials));
            LRLfpEvent_tmp(iRep,:) = LRtmp;
        end
        LRLfpEvent{iSess} = LRLfpEvent_tmp;
    end
    total_LRLfpEvent{iNumTrials} = LRLfpEvent;
    
    LRLfpNull = cell(1,nSess);
    for iSess = 1:nSess
        LRLfpNull_tmp = zeros(nTestReps(iNumTrials),nT);
        for iRep = 1:nTestReps(iNumTrials)
            TrialPerm = randperm(nTrNull(iSess));
            TrainTrials = TrialPerm(1:end - NumTrials{iSess}(iNumTrials));
            TestTrials = TrialPerm(end - NumTrials{iSess}(iNumTrials) + 1:end);
            SpecMeanNullTr = sq(sum(SpecNull{iSess}(TrainTrials,:,:)))./length(TrainTrials);
            LRtmp = ...
                likLR_Spectral(sq(mean(SpecNull{iSess}(TestTrials,:,:))), SpecMeanEvent{iSess}, ...
                SpecMeanNullTr, K*NumTrials{iSess}(iNumTrials));
            LRLfpNull_tmp(iRep,:) = LRtmp;
        end
        LRLfpNull{iSess} = LRLfpNull_tmp;
    end
    total_LRLfpNull{iNumTrials} = LRLfpNull;
    
end


% Average across the sessions
for iNumTrials = 1:minNumTrials
    total_LRLfpEvent{iNumTrials} = averageLR(total_LRLfpEvent{iNumTrials});
    total_LRLfpNull{iNumTrials} = averageLR(total_LRLfpNull{iNumTrials});
end
TrialAv.LREvent = total_LRLfpEvent;
TrialAv.LRNull = total_LRLfpNull;


if nSess > 1
    TrialAv.EventModel.Mean = SpecMeanEvent;
    TrialAv.NullModel.Mean = SpecMeanNull;
else
    TrialAv.EventModel.Mean = SpecMeanEvent{1};
    TrialAv.NullModel.Mean = SpecMeanNull{1};
end


