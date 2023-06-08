function [LRLfpEvent, LRLfpNull, EventModel, NullModel] = ...
    likLfpNoHistModel(LfpEvent, LfpNull, Params)
%
% [LRLfpEvent, LRLfpNull, EventModel, NullModel] =
%                           likLfpNoHistModel(LfpEvent, LfpNull, Params)
%
%   Inputs:
%
%   Outputs:
%       LRLfpEvent
%       LRLfpNull
%       EventModel
%       NullModel

if(iscell(LfpEvent))
    nSess = length(LfpEvent);
else
    nSess = 1;
    myLfpNull{1} = LfpNull;
    myLfpEvent{1} = LfpEvent;
    LfpNull = myLfpNull; LfpEvent = myLfpEvent;
end


for iSess = 1:nSess
  LPLfpNull = mtfilter(LfpNull{iSess},[.03,40],1e3,0);
  LPLfpEvent = mtfilter(LfpEvent{iSess},[.03,40],1e3,0);

  LfpMeanEvent{iSess} = mean(LPLfpEvent,1);
  LfpMeanNull{iSess} = mean(LPLfpNull,1);

  nTrEvent = size(LPLfpEvent,1);
  nTrNull = size(LPLfpNull,1);
  nT = length(LfpMeanEvent{iSess});

  ResNull = LPLfpNull - repmat(LfpMeanNull{iSess}, nTrNull,1);
  sigmaNull(iSess) = std(ResNull(:));

  ResEvent = LPLfpEvent - repmat(LfpMeanEvent{iSess},nTrEvent,1);
  sigmaEvent(iSess) = std(ResEvent(:));

  sigmaEventNull = (sigmaEvent(iSess)+sigmaNull(iSess))./2;
  LRLfpEvent_tmp = zeros(nTrEvent,nT);
  ResidualLfpEvent_tmp = zeros(nTrEvent,nT);
  for iTr = 1:nTrEvent
    LooTr = ~(ismember(1:nTrEvent,iTr));
    LfpMeanEventTr = sum(LPLfpEvent(LooTr,:))./(nTrEvent-1);
    [LRLfpEvent_tmp(iTr,:), ResidualLfpEvent_tmp(iTr,:)] = ...
        likLR_Gaussian(LPLfpEvent(iTr,:), LfpMeanEventTr, LfpMeanNull{iSess}, sigmaEventNull, sigmaEventNull);
  end
  LRLfpEvent{iSess} = LRLfpEvent_tmp;
  ResidualLfpEvent{iSess} = ResidualLfpEvent_tmp;

  LRLfpNull_tmp = zeros(nTrNull,nT);
  ResidualLfpNull_tmp = zeros(nTrNull,nT);
  for iTr = 1:nTrNull
    LooTr = ~(ismember(1:nTrNull,iTr));
    LfpMeanNullTr = sum(LPLfpNull(LooTr,:))./(nTrNull-1);
    [LRLfpNull_tmp(iTr,:), ResidualLfpNull_tmp(iTr,:)] = ...
        likLR_Gaussian(LPLfpNull(iTr,:), LfpMeanEvent{iSess}, LfpMeanNullTr, sigmaEventNull, sigmaEventNull);
  end
  LRLfpNull{iSess} = LRLfpNull_tmp;
  ResidualLfpNull{iSess} = ResidualLfpNull_tmp;
end

if nSess == 1
  EventModel.Residual = ResidualLfpEvent{1};
  EventModel.Mean = LfpMeanEvent{1};
  EventModel.sigma = sigmaEvent(1);

  NullModel.Mean = LfpMeanNull{1};
  NullModel.sigma = sigmaNull(1);
  NullModel.Residual = ResidualLfpNull{1};

  LRLfpNull = LRLfpNull{1}; LRLfpEvent = LRLfpEvent{1};
else
  EventModel.Residual = ResidualLfpEvent;
  EventModel.Mean = LfpMeanEvent;
  EventModel.sigma = sigmaEvent;

  NullModel.Mean = LfpMeanNull;
  NullModel.sigma = sigmaNull;
  NullModel.Residual = ResidualLfpNull;
  LRLfpEvent = averageLR(LRLfpEvent);
  LRLfpNull = averageLR(LRLfpNull);

end
