function [LRSpikeEvent, LRSpikeNull, EventModel, NullModel] = ...
    likSpikeNoHistModel(SpikesEvent, SpikesNull, InputParams, SpikeParams)
%
%   likSpikeNoHistModel calls LR_InhPoisson
%
%  [LRSpikeEvent, LRSpikeNull, EventModel, NullModel] = ...
%    likSpikeNoHistModel(SpikesEvent, SpikesNull, InputParams, SpikeParams)
%
%   Params.Smoothing = Scalar.  Maximum amount of smoothing for PSTH in
%                               ms.  Defaults to 5.
%   Params.Null.bn
%   Params.Event.bn

binnull = InputParams.Null.bn;
binnull(1:2) = binnull(1:2) - binnull(1);
binevent = InputParams.Event.bn;
binevent(1:2) = binevent(1:2) - binevent(1);

if isfield(SpikeParams,'Smoothing')
    Smoothing = SpikeParams.Smoothing;
else
    Smoothing = 5; % Checks for smoothing up to 5 ms
end

% [CVE, optsmNull] = cvesmoothing(MaxSmoothing, SpikesNull, binnull);
optsmNull = Smoothing;

if(iscell(SpikesEvent{1}))
    nSess = length(SpikesEvent);
else
    nSess = 1;
    mySpikesNull{1} = SpikesNull;
    mySpikesEvent{1} = SpikesEvent;
    SpikesNull = mySpikesNull; SpikesEvent = mySpikesEvent;
end

if SpikeParams.Static %  Firing rate is constant over time only applies for Null
    RateNull = cell(1,nSess);
    for iSess = 1:nSess
        NSpikes = 0;
        for iTr = 1:length(SpikesNull{iSess})
            NSpikes = NSpikes + length(SpikesNull{iSess}{iTr});
        end
        tmp_RateNull = NSpikes./((binnull(2)-binnull(1))./1e3)./length(SpikesNull{iSess});
        tmp_RateNull = tmp_RateNull(ones(1, binnull(2)-binnull(1)+1));
        RateNull{iSess} = tmp_RateNull;
    end
else
    RateNull = cell(1,nSess);
    for iSess = 1:nSess
        RateNull{iSess} = mypsth2(SpikesNull{iSess}, binnull, optsmNull);
    end
end
% [CVE, optsmEvent] = cvesmoothing(MaxSmoothing, SpikesEvent, binevent);
optsmEvent= Smoothing;

RateEvent = cell(1,nSess);
nTrEvent = zeros(1,nSess); nTrNull = zeros(1,nSess); nT = zeros(1,nSess);
for iSess = 1:nSess
    RateEvent{iSess} = mypsth2(SpikesEvent{iSess}, binevent, optsmEvent);
    nTrEvent(iSess) = length(SpikesEvent{iSess});
    nTrNull(iSess) = length(SpikesNull{iSess});
    nT(iSess) = length(RateNull{iSess});    
end

LRSpikeEvent = cell(1,nSess);
for iSess = 1:nSess
    tmp_LRSpikeEvent = zeros(nTrEvent(iSess),nT(iSess));
    for iTr = 1:nTrEvent(iSess)
        LooTr = find(~(ismember(1:nTrEvent(iSess),iTr)));
        RateEventTr = mypsth2(SpikesEvent{iSess}(LooTr), binevent, optsmEvent);
        tmp_LRSpikeEvent(iTr,:) = ...
            likLR_InhPoisson(SpikesEvent{iSess}(iTr), RateEventTr, RateNull{iSess}, [binevent,1]);
    end
    LRSpikeEvent{iSess} = tmp_LRSpikeEvent;
end

LRSpikeNull = cell(1,nSess);
for iSess = 1:nSess
    tmp_LRSpikeNull = zeros(nTrNull(iSess),nT(iSess));
    for iTr = 1:nTrNull(iSess)
        LooTr = find(~(ismember(1:nTrNull(iSess),iTr)));
        if SpikeParams.Static
            NSpikes = 0;
            for iTrRate = 1:length(LooTr)
                NSpikes = NSpikes + length(SpikesNull{iSess}{LooTr(iTrRate)});
            end
            RateNullTr = NSpikes./((binnull(2)-binnull(1))./1e3)./length(LooTr);
            RateNullTr = RateNullTr(ones(1,binnull(2)-binnull(1)+1));
        else
            RateNullTr = mypsth2(SpikesNull{iSess}(LooTr), binnull, optsmNull);
        end
        tmp_LRSpikeNull(iTr,:) = ...
            likLR_InhPoisson(SpikesNull{iSess}(iTr), RateEvent{iSess}, RateNullTr, [binevent,1]);
    end
    LRSpikeNull{iSess} = tmp_LRSpikeNull;
end

% Average across the sessions

if nSess == 1
  LRSpikeEvent = LRSpikeEvent{1};
  LRSpikeNull = LRSpikeNull{1};
  EventModel.Rate = RateEvent{1};
  NullModel.Rate = RateNull{1};
else
  LRSpikeEvent = averageLR(LRSpikeEvent); 
  LRSpikeNull = averageLR(LRSpikeNull);
  EventModel.Rate = RateEvent;
  NullModel.Rate = RateNull;
end
