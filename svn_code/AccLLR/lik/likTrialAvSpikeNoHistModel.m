function TrialAv = ...
    likTrialAvSpikeNoHistModel(SpikesEvent, SpikesNull, InputParams, SpikeParams)
%
%   likSpikeNoHistModel calls LR_InhPoisson
%
%  [TrialAv] = ...
%    likSpikeNoHistModel(SpikesEvent, SpikesNull, InputParams, OnsetParams)
%
%   Params.Smoothing = Scalar.  Maximum amount of smoothing for PSTH in
%                               ms.  Defaults to 50.
%   Params.Null.bn
%   Params.Event.bn

binnull = InputParams.Null.bn;
binnull(1:2) = binnull(1:2) - binnull(1);
binevent = InputParams.Event.bn;
binevent(1:2) = binevent(1:2) - binevent(1);

if(iscell(SpikesEvent{1}))
    nSess = length(SpikesEvent);
else
    nSess = 1;
    SpikesNull{1} = SpikesNull;
    SpikesEvent{1} = SpikesEvent;
end

% [CVE, optsmNull] = cvesmoothing(MaxSmoothing, SpikesNull, binnull);
optsmNull = SpikeParams.Smoothing;
RateNull = cell(1,nSess);
if SpikeParams.Static
    for iSpikeEvent = 1:nSess
        NSpikes = 0;
        for iTr = 1:length(SpikesNull{iSpikeEvent})
            NSpikes = NSpikes + length(SpikesNull{iSpikeEvent}{iTr});
        end
        tmp_RateNull = NSpikes./((binnull(2)-binnull(1))./1e3)./length(SpikesNull{iSpikeEvent});
        tmp_RateNull = tmp_RateNull(ones(1,binnull(2)-binnull(1)+1));
        RateNull{iSpikeEvent} = tmp_RateNull;
    end
else
    for iSpikeEvent = 1:nSess
        RateNull{iSpikeEvent} = mypsth2(SpikesNull{iSpikeEvent}, binnull, optsmNull);
    end
end
% [CVE, optsmEvent] = vesmoothing(MaxSmoothing, SpikesEvent, binevent);
optsmEvent= SpikeParams.Smoothing;

RateEvent = cell(1,nSess);
nTrEvent = zeros(1,nSess); nTrNull = zeros(1,nSess); nT = zeros(1,nSess);
for iSess = 1:nSess
    RateEvent{iSess} = mypsth2(SpikesEvent{iSess}, binevent, optsmEvent);
    nTrEvent(iSess) = length(SpikesEvent{iSess});
    nTrNull(iSess) = length(SpikesNull{iSess});
    nT(iSess) = length(RateNull{iSess});
end

NumTrials = InputParams.TrialAvNumTrials;
nTestReps = InputParams.TrialAvIterations;

%find minimum number of trials
minNumTrials = length(NumTrials{1});
for i = 2:length(NumTrials)
    minNumTrials = min(minNumTrials,length(NumTrials{i}));
end

total_LRSpikeEvent = cell(1,minNumTrials);
total_LRSpikeNull = cell(1,minNumTrials);

for iNumTrials = 1:minNumTrials
    LRSpikeEvent = cell(1,nSess);
    for iSess = 1:nSess
        %if(length(NumTrials{iSess}) > iNumTrials)
            LRSpikeEvent_tmp = zeros(nTestReps(iSess,iNumTrials),nT(iSess));
            for iRep = 1:nTestReps(iSess,iNumTrials)  %  The number of realizations we want to generate.
                TrialPerm = randperm(nTrEvent(iSess));
                TrainTrials = TrialPerm(1:end - NumTrials{iSess}(iNumTrials));
                TestTrials = TrialPerm(end - NumTrials{iSess}(iNumTrials) + 1:end);
                RateEventTr = mypsth2(SpikesEvent{iSess}(TrainTrials), binevent, optsmEvent);
                nTestTrials = length(TestTrials);
                LRtmp = zeros(nTestTrials,nT(iSess));
                for iTr = 1:nTestTrials
                    LRtmp(iTr,:) = ...
                        LR_InhPoisson(SpikesEvent{iSess}(TestTrials(iTr)), RateEventTr, ...
                        RateNull{iSess}, binevent);
                end
                %ind = find(LRtmp(:)==0); LRtmp(ind)=1;
                LRSpikeEvent_tmp(iRep,:) = mean(LRtmp);
            end
            LRSpikeEvent{iSess} = LRSpikeEvent_tmp;
        %else
        %   LRSpikeEvent{iSess} = nan(nTestReps(iSess,iNumTrials),nT{iSess});
        %end
    end
    total_LRSpikeEvent{iNumTrials} = LRSpikeEvent;
end

for iNumTrials = 1:minNumTrials
    LRSpikeNull = cell(1,nSess);
    for iSess = 1:nSess
        %if(length(NumTrials{iSess}) > iNumTrials)
            LRSpikeNull_tmp = zeros(nTestReps(iSess,iNumTrials),nT(iSess));
            for iRep = 1:nTestReps(iSess,iNumTrials)
                TrialPerm = randperm(nTrNull(iSess));
                TrainTrials = TrialPerm(1:end - NumTrials{iSess}(iNumTrials));
                TestTrials = TrialPerm(end - NumTrials{iSess}(iNumTrials) + 1:end);
                
                if SpikeParams.Static
                    NSpikes = 0;
                    for iTr = 1:length(TrainTrials)
                        NSpikes = NSpikes + length(SpikesNull{iSess}{TrainTrials(iTr)});
                    end
                    RateNullTr = NSpikes./((binnull(2)-binnull(1))./1e3)./length(TrainTrials);
                    RateNullTr = RateNullTr(ones(1,binnull(2)-binnull(1)+1));
                else
                    RateNullTr = mypsth2(SpikesNull{iSess}(TrainTrials), binnull, optsmNull);
                end
                
                nTestTrials = length(TestTrials);
                LRtmp = zeros(nTestTrials,nT(iSess));
                for iTr = 1:nTestTrials
                    LRtmp(iTr,:) = ...
                        LR_InhPoisson(SpikesNull{iSess}(TestTrials(iTr)), RateEvent{iSess}, ...
                        RateNullTr, binnull);
                end
                LRSpikeNull_tmp(iRep,:) = mean(LRtmp);
            end
            LRSpikeNull{iSess} = LRSpikeNull_tmp;
    end
    total_LRSpikeNull{iNumTrials} = LRSpikeNull;
end


% Average across the sessions
for iNumTrials = 1:minNumTrials
    total_LRSpikeEvent{iNumTrials} = averageLR(total_LRSpikeEvent{iNumTrials});
    total_LRSpikeNull{iNumTrials} = averageLR(total_LRSpikeNull{iNumTrials});
end
TrialAv.LREvent = total_LRSpikeEvent;
TrialAv.LRNull = total_LRSpikeNull;

if(nSess == 1)
    TrialAv.EventModel.Rate = RateEvent{1};
    TrialAv.NullModel.Rate = RateNull{1};
else
    TrialAv.EventModel.Rate = RateEvent;
    TrialAv.NullModel.Rate = RateNull;
end

