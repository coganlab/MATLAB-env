function [LRLfpTest, EventModel, NullModel] = ...
    likLfpTestSVDSpectralModel(LfpTest, LfpEvent, LfpNull, Params)
%
% [LRLfpTest, EventModel, NullModel] =
%       likLfpTestSVDSpectralModel(LfpTest, LfpEvent, LfpNull, Params)
%
%   Inputs:
%       LfpTest
%       LfpEvent
%       LfpNull
%       Params	=
%           Params.Tapers Defaults to [0.2,10]
%           Params.Fk  Defaults to 200 (Hz)
%           Params.Dn  Defaults to 0.05 (s)
%           Params.Modes Defaults to 10
%   Outputs:
%       LRLfpTest
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
% 
% if(iscell(LfpEvent))
%     nSess = length(LfpEvent);
% else
%     nSess = 1;
%     myLfpNull{1} = LfpNull;
%     myLfpEvent{1} = LfpEvent;
%     LfpNull = myLfpNull; LfpEvent = myLfpEvent;
% end

nCh = size(LfpEvent,2);
nWin = floor((size(LfpEvent,3)-tapers(1)*sampling)./(sampling*dn));



    nTrTest = size(LfpTest,1);
    nTrEvent = size(LfpEvent,1);
    nTrNull = size(LfpNull,1);
    SpecTest = zeros(nTrTest,nCh,nWin,diff(nFk),'single');
    SpecEvent = zeros(nTrEvent,nCh,nWin,diff(nFk),'single');
    SpecNull = zeros(nTrNull,nCh,nWin,diff(nFk),'single');
    tic
    parfor iTrial = 1:nTrTest
        SpecTest(iTrial,:,:,:) = log(tfspec(sq(LfpTest(iTrial,:,:)),tapers,sampling,dn,fk));
    end
    parfor iTrial = 1:nTrEvent
        SpecEvent(iTrial,:,:,:) = log(tfspec(sq(LfpEvent(iTrial,:,:)),tapers,sampling,dn,fk));
    end
    parfor iTrial = 1:nTrNull
        SpecNull(iTrial,:,:,:) = log(tfspec(sq(LfpNull(iTrial,:,:)),tapers,sampling,dn,fk));
    end
    toc
    SVDSpecEvent = zeros(nTrEvent,nWin,nModes,'single');
    SVDSpecNull = zeros(nTrNull,nWin,nModes,'single');
    SVDSpecTest = zeros(nTrTest,nWin,nModes,'single');
    tic
    
    for iWin = 1:nWin
        xLooTrial = [sq(SpecEvent(:,:,iWin,:));sq(SpecNull(:,:,iWin,:))];
        xLooTrial = reshape(xLooTrial, [size(xLooTrial,1),nCh*diff(nFk)]);
        xLooTrial2 = xLooTrial*xLooTrial';
        [u,s,v] = svd(xLooTrial2);
        vDataSet = xLooTrial'*v(:,1:nModes);
        for iMode = 1:nModes
            vDataSet(:,iMode) = vDataSet(:,iMode)./sqrt(s(iMode,iMode));
        end
        
        parfor iTrial = 1:nTrEvent
            xTrial = sq(SpecEvent(iTrial,:,iWin,:));
            SVDSpecEvent(iTrial,iWin,:) = xTrial(:)'*vDataSet;
        end
        parfor iTrial = 1:nTrNull
            xTrial = sq(SpecNull(iTrial,:,iWin,:));
            SVDSpecNull(iTrial,iWin,:) = xTrial(:)'*vDataSet;
        end
        parfor iTrial = 1:nTrTest
            xTrial = sq(SpecTest(iTrial,:,iWin,:));
            SVDSpecTest(iTrial,iWin,:) = xTrial(:)'*vDataSet;
        end
    end
    toc
    
    SVDSpecMeanEvent = sq(mean(SVDSpecEvent,1));
    SVDSpecMeanNull = sq(mean(SVDSpecNull,1));
    
    LRLfpTest = zeros(nTrTest,nWin,'single');
    for iTr = 1:nTrTest
        [LRLfpTest(iTr,:)] = ...
            likLR_SVDSpectral(sq(SVDSpecTest(iTr,:,:)), SVDSpecMeanEvent, SVDSpecMeanNull);
    end

EventModel.Mean = SVDSpecMeanEvent;
NullModel.Mean = SVDSpecMeanNull;
