function [LRSpikeEvent, LRSpikeNull, EventModel, NullModel] = ...
    likSpikeStaticModel(SpikesEvent, SpikesNull, Params)
%
%   likSpikeStaticModel calls likLR_InhPoisson
%
%  [LRSpikeEvent, LRSpikeNull, EventModel, NullModel] = ...
%    likSpikeStaticModel(SpikesEvent, SpikesNull, Params)
%
%   Params.MaxSmoothing = Scalar.  Maximum amount of smoothing for PSTH in
%                               ms.  Defaults to 50.
%   Params.Null.bn
%   Params.Event.bn

binnull = Params.Null.bn;
binevent = Params.Event.bn;

if isfield(Params,'Smoothing')
    Smoothing = Params.Smoothing;
else
    Smoothing = 5; % Checks for smoothing up to 50 ms
end

optsmEvent= Smoothing;
RateEvent = mypsth2(SpikesEvent, binevent, optsmEvent);
RateNull = repmat(RateEvent(1),1,length(RateEvent));

nTrEvent = length(SpikesEvent);
nTrNull = length(SpikesNull);
nT = length(RateNull);

LRSpikeEvent = zeros(nTrEvent,nT);
for iTr = 1:nTrEvent
    LooTr = find(~(ismember(1:nTrEvent,iTr)));
    RateEventTr = mypsth2(SpikesEvent(LooTr), binevent, optsmEvent);
    LRSpikeEvent(iTr,:) = ...
        likLR_InhPoisson(SpikesEvent(iTr), RateEventTr, RateNull, binevent);
end
LRSpikeNull = zeros(nTrNull,nT);
for iTr = 1:nTrNull
    LooTr = find(~(ismember(1:nTrNull,iTr)));
    RateNullTr = mypsth2(SpikesNull(LooTr), binnull, optsmNull);
    LRSpikeNull(iTr,:) = ...
        likLR_InhPoisson(SpikesNull(iTr), RateEvent, RateNullTr, binevent);
end

EventModel.Rate = RateEvent;
NullModel.Rate = RateNull;

