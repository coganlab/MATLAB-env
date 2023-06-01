function [LRLfpEvent, LRLfpNull, EventModel, NullModel] = ...
    likLfpSpectralModel(LfpEvent, LfpNull, Params)
%
% [LRLfpEvent, LRLfpNull, EventModel, NullModel] =
%                           likLfpSpectralModel(LfpEvent, LfpNull, Params)
%
%   Inputs:
%       LfpEvent
%       LfpNull
%       Params	= 
%           Params.Tapers Defaults to [0.2,10]
%           Params.Fk  Defaults to 200 (Hz)
%           Params.Dn  Defaults to 0.05 (s)
%   Outputs:
%       LRLfpEvent
%       LRLfpNull
%       EventModel
%       NullModel

if ~isfield(Params,'Fk'); Params.Fk = 200; end
if ~isfield(Params,'Dn'); Params.Dn = 0.005; end
if ~isfield(Params,'Tapers'); Params.Tapers = [0.2,10]; end
if ~isfield(Params,'Df'); Params.Df = Params.Tapers(2); end

tapers = Params.Tapers;
dn = Params.Dn;
fk = Params.Fk;
if length(fk)==1; fk = [0,fk]; end
df = Params.Df;

K = floor(2*tapers(1).*tapers(2) - 1);

if(iscell(LfpEvent))
    nSess = length(LfpEvent);
else
    nSess = 1;
    myLfpNull{1} = LfpNull;
    myLfpEvent{1} = LfpEvent;
    LfpNull = myLfpNull; LfpEvent = myLfpEvent;
end

SpecMeanEvent = cell(1,nSess);
SpecMeanNull = cell(1,nSess);

for iSess = 1:nSess
  SpecEvent = log(tfspec(LfpEvent{iSess},tapers,1e3,dn,fk));
  SpecNull = log(tfspec(LfpNull{iSess},tapers,1e3,dn,fk));

  nTrEvent = size(LfpEvent{iSess},1);
  nTrNull = size(LfpNull{iSess},1);

  dftobn = round(df.*size(SpecEvent,3)./diff(fk));
  SpecEvent = SpecEvent(:,:,1:dftobn:end);
  SpecNull = SpecNull(:,:,1:dftobn:end);
   
  SpecMeanEvent{iSess} = sq(mean(SpecEvent,1));
  SpecMeanNull{iSess} = sq(mean(SpecNull,1));
  
  nT = size(SpecMeanEvent{iSess},1);

  LRLfpEvent = zeros(nTrEvent,nT);
  for iTr = 1:nTrEvent
    LooTr = ~(ismember(1:nTrEvent,iTr));
    SpecMeanEventTr = sq(sum(SpecEvent(LooTr,:,:)))./(nTrEvent-1);
    [LRLfpEvent(iTr,:)] = ...
        likLR_Spectral(sq(SpecEvent(iTr,:,:)), SpecMeanEventTr, SpecMeanNull{iSess}, K);
  end

  LRLfpNull = zeros(nTrNull,nT);
  for iTr = 1:nTrNull
    LooTr = ~(ismember(1:nTrNull,iTr));
    SpecMeanNullTr = sq(sum(SpecNull(LooTr,:,:)))./(nTrNull-1);
    [LRLfpNull(iTr,:)] = ...
        likLR_Spectral(sq(SpecNull(iTr,:,:)), SpecMeanEvent{iSess}, SpecMeanNullTr, K);
  end
end

EventModel.Mean = SpecMeanEvent;
NullModel.Mean = SpecMeanNull;
