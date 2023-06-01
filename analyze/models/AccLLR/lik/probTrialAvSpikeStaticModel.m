function TrialAv = ...
    probTrialAvSpikeStaticModel(SpikesEvent, SpikesNull, InputParams, Params)
%
%   probTrialAvSpikeStaticModel calls probPoisson which returns a log probability
%
%  [TrialAv] = ...
%    probSpikeStaticModel(SpikesEvent, SpikesNull, InputParams, Params)
%
%   Params.MaxSmoothing = Scalar.  Maximum amount of smoothing for PSTH in
%                               ms.  Defaults to 50.
%   Params.Null.bn
%   Params.Event.bn

binnull = Params.Null.bn;
binevent = Params.Event.bn;
binwidth = Params.Smoothing;

binnull(1:2) = [0,diff(binnull(1:2))];
binevent(1:2) = [0,diff(binevent(1:2))];

nTrEvent = length(SpikesEvent);
nTrNull = length(SpikesNull);

NumTrials = InputParams.TrialAvNumTrials;
nTestReps = InputParams.TrialAvIterations;

tmp = sp2ts(SpikesEvent,[0,diff(binevent)], binwidth);
nTEvent = size(tmp,2);
tmp = sp2ts(SpikesNull,[0,diff(binnull)], binwidth);
nTNull = size(tmp,2);
Rate = 0;
for iTrial = 1:nTrNull
    Rate = Rate + length(SpikesNull{iTrial});
end
Rate = diff(binnull(1:2))./1e3.*Rate./nTrNull;

probSpikeEvent = cell(1,length(NumTrials));
for iNumTrials = 1:length(NumTrials)
    probSpikeEvent_tmp = zeros(nTestReps,nTEvent);
    for iRep = 1:nTestReps
        TrialPerm = randperm(nTrEvent);
        TestTrials = TrialPerm(end - NumTrials(iNumTrials) + 1:end);
        Spikestmp = [];
        for iTestTrial = 1:NumTrials(iNumTrials)
            Spikestmp = [Spikestmp SpikesEvent{TestTrials(iTestTrial)}'];
        end
        probSpikeEvent_tmp(iRep,:) = probPoisson({Spikestmp}, Rate, ...
                    binevent, binwidth)./NumTrials(iNumTrials);
    end
    probSpikeEvent{iNumTrials} = probSpikeEvent_tmp;
end

probSpikeNull = cell(1,length(NumTrials));
RateTr = zeros(1,length(NumTrials));
for iNumTrials = 1:length(NumTrials)
    probSpikeNull_tmp = zeros(nTestReps,nTNull);
    for iRep = 1:nTestReps
        TrialPerm = randperm(nTrNull);
        TrainTrials = TrialPerm(1:end - NumTrials(iNumTrials));
        TrainRate = 0;
        for iTrainTrial = 1:length(TrainTrials)
            TrainRate = TrainRate + length(SpikesNull{TrainTrials(iTrainTrial)});
        end
        TrainRate = diff(binnull(1:2))./1e3.*TrainRate./length(TrainTrials);
        RateTr(iNumTrials) = TrainRate;
        TestTrials = TrialPerm(end - NumTrials(iNumTrials) + 1:end);
        Spikestmp = [];
        for iTestTrial = 1:NumTrials(iNumTrials)
            Spikestmp = [Spikestmp SpikesNull{TestTrials(iTestTrial)}'];
        end
        probSpikeNull_tmp(iRep,:) = probPoisson({Spikestmp}, Rate, ...
                    binnull, binwidth)./NumTrials(iNumTrials);
    end
    probSpikeNull{iNumTrials} = probSpikeNull_tmp;
end

TrialAv.probEvent = probSpikeEvent;
TrialAv.probNull = probSpikeNull;
TrialAv.NullModel.Rate = RateTr;
TrialAv.EventModel.Rate = Rate(ones(1,length(NumTrials)));

