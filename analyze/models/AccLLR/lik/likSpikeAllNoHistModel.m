function [LRLfpAll, pAll, class, EventModels, NullModels] = ...
    likLfpAllSVDSpectralModel(LfpAll, Targs, ModelDirs, Params)
%
% [LRLfpAll, EventModels, NullModels] =
%       likLfpAllSVDSpectralModel(LfpAll, Targs, ModelDirs, Params)
%
%   Inputs:
%       LfpTest
%       Targs
%       ModelDirs
%       Params	=
%           Params.Tapers Defaults to [0.2,10]
%           Params.Fk  Defaults to 200 (Hz)
%           Params.Dn  Defaults to 0.05 (s)
%           Params.Modes Defaults to 10
%   Outputs:
%       LRLfpAll
%       EventModels
%       NullModels

if ~isfield(Params,'Fk'); Params.Fk = 200; end
if ~isfield(Params,'Dn'); Params.Dn = 0.005; end
if ~isfield(Params,'Tapers'); Params.Tapers = [0.2,10]; end
if ~isfield(Params,'Df'); Params.Df = Params.Tapers(2); end
if ~isfield(Params,'Modes'); Params.Modes = 10; end

nClass = length(unique(Targs));
prior = ones(1,nClass)./nClass;
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

nCh = size(LfpAll,2);
nWin = floor((size(LfpAll,3)-tapers(1)*sampling)./(sampling*dn));

nModel = size(ModelDirs,1);

nTrAll = size(LfpAll,1);
SpecAll = zeros(nTrAll,nCh,nWin,diff(nFk),'single');

tic
parfor iTrial = 1:nTrAll
    SpecAll(iTrial,:,:,:) = log(tfspec(sq(LfpAll(iTrial,:,:)),tapers,sampling,dn,fk));
end
toc
pAll = zeros(nTrAll,nWin,nClass,'single');
class = zeros(nWin, nTrAll);
for iWin = 1:nWin
    tic
    disp([num2str(iWin) ' of ' num2str(nWin)]);
    xTrial = sq(SpecAll(:,:,iWin,:));
    xTrial = reshape(xTrial, [size(xTrial,1),nCh*diff(nFk)]);
    xTrial2 = xTrial*xTrial';
    [u,s,v] = svd(xTrial2);
    vFet = xTrial'*v(:,1:nModes);
    for iTrial = 1:nTrAll
        LooTargs = Targs(setdiff(1:nTrAll,iTrial));
        xLooTrial = sq(SpecAll(setdiff(1:nTrAll,iTrial),:,iWin,:));
        xLooTrial = reshape(xLooTrial, [size(xLooTrial,1),nCh*diff(nFk)]);
        xTestTrial = sq(SpecAll(iTrial,:,iWin,:));
        xTestTrial = reshape(xTestTrial, [1,nCh*diff(nFk)]);
        fetLooTrial = xLooTrial*vFet;
        nfetLooTrial = zeros(size(fetLooTrial));
        sd = std(fetLooTrial);
        for iDim = 1:nModes
            nfetLooTrial(:,iDim) = fetLooTrial(:,iDim)./sd(iDim);
        end
        fetTestTrial = xTestTrial*vFet./sd;
        [class(iTrial,iWin), dum, posterior, logp, coeffs] = classify(fetTestTrial, nfetLooTrial, LooTargs);
        pAll(iTrial,iWin,:) = posterior+1e-10;
        
    end
    toc
end

LRLfpAll = zeros(nModel,nTrAll,nWin,'single');
for iModel = 1:nModel
    LRLfpAll(iModel,:,:) = -diff(log(pAll(:,:,ModelDirs(iModel,:))),1,3);
end

EventModels.Mean = [];
NullModels.Mean = [];
