function [LRLfpEvent, LRLfpNull, EventModel, NullModel] = ...
    likLfpSVDSpectralModel(LfpEvent, LfpNull, Params)
%
% [LRLfpEvent, LRLfpNull, EventModel, NullModel] =
%                           likLfpSVDSpectralModel(LfpEvent, LfpNull, Params)
%
%   Inputs:
%       LfpEvent
%       LfpNull
%       Params	=
%           Params.Tapers Defaults to [0.2,10]
%           Params.Fk  Defaults to 200 (Hz)
%           Params.Dn  Defaults to 0.05 (s)
%           Params.Modes Defaults to 10
%   Outputs:
%       LRLfpEvent
%       LRLfpNull
%       EventModel
%       NullModel

if ~isfield(Params,'Fk'); Params.Fk = 200; end
if ~isfield(Params,'Dn'); Params.Dn = 0.005; end
if ~isfield(Params,'Tapers'); Params.Tapers = [0.2,10]; end
if ~isfield(Params,'Df'); Params.Df = Params.Tapers(2); end
if ~isfield(Params,'Modes'); Params.Modes = 10; end

pad = 2; sampling = 1e3;
tapers = Params.Tapers;
dn = Params.Dn;
fk = Params.Fk;
if length(fk)==1; fk = [0,fk]; end
df = Params.Df;
nModes = Params.Modes;
K = floor(2*tapers(1).*tapers(2) - 1);
nF = max(256, pad*2^nextpow2(tapers(1)*sampling+1));
nFk = floor(fk./sampling.*nF);

if(iscell(LfpEvent))
    nSess = length(LfpEvent);
else
    nSess = 1;
    myLfpNull{1} = LfpNull;
    myLfpEvent{1} = LfpEvent;
    LfpNull = myLfpNull; LfpEvent = myLfpEvent;
end

nCh = size(LfpEvent{1},2);
nWin = floor((size(LfpEvent{1},3)-tapers(1)*sampling)./(sampling*dn));

SVDSpecMeanEvent = cell(1,nSess);
SVDSpecMeanNull = cell(1,nSess);

for iSess = 1:nSess
    LfpEventSess = LfpEvent{iSess};
    LfpNullSess = LfpNull{iSess};
    nTrEvent = size(LfpEvent{iSess},1);
    nTrNull = size(LfpNull{iSess},1);
    SpecEvent = zeros(nTrEvent,nCh,nWin,diff(nFk),'single');
    SpecNull = zeros(nTrNull,nCh,nWin,diff(nFk),'single');
    tic
    parfor iTrial = 1:nTrEvent
        SpecEvent(iTrial,:,:,:) = log(tfspec(sq(LfpEventSess(iTrial,:,:)),tapers,sampling,dn,fk));
    end
    parfor iTrial = 1:nTrNull
        SpecNull(iTrial,:,:,:) = log(tfspec(sq(LfpNullSess(iTrial,:,:)),tapers,sampling,dn,fk));
    end
    toc
    SVDSpecEvent = zeros(nTrEvent,nWin,nModes,'single');
    SVDSpecNull = zeros(nTrNull,nWin,nModes,'single');
    tic
    
    for iWin = 1:nWin
        parfor iTrial = 1:nTrEvent
            xLooTrial = sq(SpecEvent(setdiff(1:nTrEvent,iTrial),:,iWin,:));
            xLooTrial = reshape(xLooTrial, [size(xLooTrial,1),nCh*diff(nFk)]);
            xLooTrial2 = xLooTrial*xLooTrial';
            [u,s,v] = svd(xLooTrial2);
            vDataSet = xLooTrial'*v(:,1:nModes);
            for iMode = 1:nModes
                vDataSet(:,iMode) = vDataSet(:,iMode)./sqrt(s(iMode,iMode));
            end
            xTrial = sq(SpecEvent(iTrial,:,iWin,:));
            SVDSpecEvent(iTrial,iWin,:) = xTrial(:)'*vDataSet;
        end
        parfor iTrial = 1:nTrNull
            xLooTrial = sq(SpecNull(setdiff(1:nTrNull,iTrial),:,iWin,:));
            xLooTrial = reshape(xLooTrial, [size(xLooTrial,1),nCh*diff(nFk)]);
            xLooTrial2 = xLooTrial*xLooTrial';
            [u,s,v] = svd(xLooTrial2);
            vDataSet = xLooTrial'*v(:,1:nModes);
            for iMode = 1:nModes
                vDataSet(:,iMode) = vDataSet(:,iMode)./sqrt(s(iMode,iMode));
            end
            xTrial = sq(SpecNull(iTrial,:,iWin,:));
            SVDSpecNull(iTrial,iWin,:) = xTrial(:)'*vDataSet;
        end
    end
    toc
    
    SVDSpecMeanEvent{iSess} = sq(mean(SVDSpecEvent,1));
    SVDSpecMeanNull{iSess} = sq(mean(SVDSpecNull,1));
    
%     nT = size(SVDSpecMeanEvent{iSess},1);
    
    LRLfpEvent = zeros(nTrEvent,nWin);
    for iTr = 1:nTrEvent
        LooTr = ~(ismember(1:nTrEvent,iTr));
        SVDSpecMeanEventTr = sq(sum(SVDSpecEvent(LooTr,:,:)))./(nTrEvent-1);
        [LRLfpEvent(iTr,:)] = ...
            likLR_SVDSpectral(sq(SVDSpecEvent(iTr,:,:)), SVDSpecMeanEventTr, SVDSpecMeanNull{iSess});
    end
    
    LRLfpNull = zeros(nTrNull,nWin);
    for iTr = 1:nTrNull
        LooTr = ~(ismember(1:nTrNull,iTr));
        SVDSpecMeanNullTr = sq(sum(SVDSpecNull(LooTr,:,:)))./(nTrNull-1);
        [LRLfpNull(iTr,:)] = ...
            likLR_SVDSpectral(sq(SVDSpecNull(iTr,:,:)), SVDSpecMeanEvent{iSess}, SVDSpecMeanNullTr);
    end
end

EventModel.Mean = SVDSpecMeanEvent;
NullModel.Mean = SVDSpecMeanNull;
