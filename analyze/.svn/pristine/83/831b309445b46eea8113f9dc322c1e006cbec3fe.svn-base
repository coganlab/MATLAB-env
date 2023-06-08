function [probSpikeEvent, probSpikeNull, EventModel, NullModel] = ...
    probSpikeStaticModel(SpikesEvent, SpikesNull, Params)
%
%   probSpikeStaticModel calls probPoisson which returns a log probability
%
%  [probSpikeEvent, probSpikeNull, EventModel, NullModel] = ...
%    probSpikeStaticModel(SpikesEvent, SpikesNull, Params)
%
%   Params.MaxSmoothing = Scalar.  Maximum amount of smoothing for PSTH in
%                               ms.  Defaults to 50.
%   Params.Null.bn
%   Params.Event.bn

binnull = Params.Null.bn;
binevent = Params.Event.bn;
binwidth = Params.Smoothing;

nTrEvent = length(SpikesEvent);
nTrNull = length(SpikesNull);

RateNull = sum(sp2ts(SpikesNull, [0,diff(binevent)], binwidth))./nTrNull;
nT = length(RateNull);
Rate = sum(RateNull)./nT;
NullSpikeCount = nTrNull*nT*Rate;

probSpikeEvent = zeros(nTrEvent,nT);
RateTr = zeros(1,nTrEvent);
for iTr = 1:nTrEvent
    probSpikeEvent(iTr,:) = ...
        probPoisson(SpikesEvent(iTr), Rate, binevent, binwidth);
end

probSpikeNull = zeros(nTrNull,nT);
for iTr = 1:nTrNull
    RateTr(iTr) = (NullSpikeCount - length(SpikesNull{iTr}))./(nTrNull-1);
    probSpikeNull(iTr,:) = ...
        probPoisson(SpikesNull(iTr), RateTr(iTr), [0,diff(binnull)], binwidth);
end

NullModel.Rate = RateTr;
EventModel.Rate = Rate(ones(1,nTrNull));

