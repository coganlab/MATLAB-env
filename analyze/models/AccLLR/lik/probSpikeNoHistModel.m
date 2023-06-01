function [ProbSpikes, Models] = ...
    probSpikeNoHistModel(Spikes, Labels, InputParams, SpikeParams)
%
%   probSpikeNoHistModel calls probPoisson
%
%  [ProbSpikes, Models] = ...
%    probSpikeNoHistModel(Spikes, Labels, InputParams, SpikeParams)
%
%   SpikeParams.Smoothing = Scalar.  Maximum amount of smoothing for PSTH in
%                               ms.  Defaults to 5.
%   InputParams.Event.bn

binevent = InputParams.Event.bn;
binevent(1:2) = binevent(1:2) - binevent(1);

if isfield(SpikeParams,'Smoothing')
    Smoothing = SpikeParams.Smoothing;
else
    Smoothing = 5; % Checks for smoothing up to 5 ms
end

if(iscell(Spikes{1}))
    nSess = length(Spikes);
else
    nSess = 1;
    mySpikes{1} = Spikes;
    Spikes = mySpikes;
end

optsmEvent= Smoothing;

uLabels = unique(Labels);
nLabel = length(uLabels);

Rate_Label = cell(1,nSess);
for iSess = 1:nSess
  for iLabel = 1:nLabel
    Rate_Label{iSess}(iLabel,:) = mypsth2(Spikes{iSess}(Labels == uLabels(iLabel)), binevent, optsmEvent);
  end
end

for iLabel = 1:nLabel
  TrIndLabel{iLabel} = find(Labels==uLabels(iLabel));
  nTrLabel(iLabel) = length(TrIndLabel);
end

nTr = length(Labels);
nTime = length(Rate_Label{1}(1,:));
TrLabel = zeros(nLabel,nTime);

ProbSpikes = cell(1,nSess);
for iSess = 1:nSess
  tmp_ProbSpike = zeros(nTr,nTime);
  for iTr = 1:nTr
    for iLabel = 1:nLabel
      if Labels(iTr)==uLabels(iLabel)
        LooTr = find(~(ismember(TrIndLabel{iLabel},iTr)));
        LooRate = mypsth2(Spikes{iSess}(LooTr), binevent, optsmEvent);
      else
        LooRate = Rate_Label{iSess}(iLabel,:);
      end
      TrRateLabel(iLabel,:) = LooRate;
    end
    for iLabel = 1:nLabel
      tmp_probSpike(iTr,iLabel,:) = ...
            probPoisson(Spikes{iSess}(iTr), TrRateLabel(iLabel,:), binevent, 1, 1./1e3);
    end
  end
  ProbSpikes{iSess} = tmp_probSpike;
end

% Average across the sessions

if nSess == 1
  ProbSpikes = ProbSpikes{1};
  Models.Rate = Rate_Label{1};
else
  AvProbSpikes = averageProb(ProbSpikes);
  ProbSpikes = AvProbSpikes;
  Models.Rate = Rate_Label;
end
