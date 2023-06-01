function [p,D,Z,PD,S_X1,S_X2] = subjTestSpecDiff(Subject,CondParams1,CondParams2,AnalParams)
%;Task,Field,bn,conds,tapers,dn,delay)
%
%   [p,D,Z,PD,S_X1,S_X2] = subjTestSpecDiff(Subject,CondParams1,CondParams2,AnalParams)
%
%   SUBJECT     =   Structure array.  Subject information
%   CONDPARAMS1 =   Data structure.  Parameter information for 1st condition
%   CONDPARAMS2 =   Data structure.  Parameter information for 2nd condition
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%   CondParams.cond    =   StarConds
%   CondParams.PropertyName() = 'Noisy' and/or 'NoResponse'
%   CondParams.PropertyValue() = 0 or 1;
%   CondParams.IntervalName = 'STRING';
%   CondParams.IntervalDuration = [min,max]
%                       IntervalDuration is either in ms or proportions
%                       if min and max are between 0 and 1 IntervalDuration
%                       is a proportion, otherwise a time duration in ms.
%                       For example
%                         IntervalDuration = [0,500] means time duration
%                         IntervalDuration = [0,0.5] means fastest 50% of
%                           intervals
%
%   AnalParams.Tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%   AnalParams.Channel =    String/Scalar.  Name/number of channel to study.
%
%   Outputs:  P	 = p-Value
%		D = Test statistic
%	        PD = Null-distribution of test statistic 

global experiment

NUM_PERMUTATIONS = 1e4;

% This handles Trials in Subject.Trials and same for experiment. 
if isfield(Subject,'Trials')
    Trials = Subject.Trials;
else
    Trials = dbTrials(Subject.Name,Subject.Day);
end
if isfield(Subject,'Experiment')
    experiment = Subject.Experiment;
else
    experiment = loadExperiment(Subject.Name);
end

if ~isfield(AnalParams,'Tapers') || isempty(AnalParams.Tapers)
    tapers = [.5,5]; 
else
    tapers = AnalParams.Tapers;
end

if ~isfield(AnalParams,'fk') || isempty(AnalParams.fk)
    fk = 200;
else
    fk = AnalParams.fk;
end
if ~isfield(AnalParams,'pad') || isempty(AnalParams.pad)
    pad = 2;
else
    pad = AnalParams.pad;
end
if ~isfield(AnalParams,'Channel') || isempty(AnalParams.Channel)
    error('Need to specify which Channel to analyze')
end
if ~isfield(AnalParams,'ArtifactThreshold') || isempty(AnalParams.ArtifactThreshold)
    thresh = 6;
else
    thresh = AnalParams.ArtifactThreshold;
end
if ~isfield(AnalParams,'ReferenceChannels') || isempty(AnalParams.ReferenceChannels)
    ReferenceChannels = 1:64;
else
    ReferenceChannels = AnalParams.ReferenceChannels;
end
if ~isfield(AnalParams,'Reference') || isempty(AnalParams.Reference)
    Reference = 'Single-Ended';
else
    Reference = AnalParams.Reference;
end

channels = experiment.channels;
[Channel_names{1:length(channels)}] = deal(channels.name);
if ischar(AnalParams.Channel)
    [dum,ChNums] = intersect(Channel_names, AnalParams.Channel);
else
    ChNums = AnalParams.Channel;
end

if ischar(ReferenceChannels)
    try
        [dum,ReferenceChannelNums] = intersect(Channel_names,ReferenceChannels);
    catch
        ReferenceChannelNums = 1:64;
    end
elseif iscell(ReferenceChannels)
    ReferenceChannelNums = zeros(1,length(ReferenceChannels));
    for iCh = 1:length(ReferenceChannels)
        try
            [dum,ReferenceChannelNums(iCh)] = intersect(Channel_names,ReferenceChannels{iCh});
        catch
            ReferenceChannelNums(iCh) = iCh; 
        end
    end
else
    ReferenceChannelNums = ReferenceChannels;
end


%  Reject bad trials
IEEG1 = trialIEEG(Trials, ChNums, CondParams1.Field, CondParams1.bn);
IEEG2 = trialIEEG(Trials, ChNums, CondParams2.Field, CondParams2.bn);
if length(ChNums) == 1
    IEEG = [IEEG1 IEEG2];
    th = thresh*std(IEEG(:));
    e = max(abs(IEEG'));
    Trials = Trials(e<th);
else
    ind = [];
    for iCh =1:length(ChNums)
        tmp1 = sq(IEEG1(:,iCh,:));
        tmp2 = sq(IEEG2(:,iCh,:));
        tmp = [tmp1 tmp2];
        th = thresh*std(tmp(:));
        e = max(abs(tmp'));
        ind = [ind find(e>th)]; %#ok<AGROW>
    end
    badtrials = unique(ind);
    goodtrials = setdiff(1:length(Trials),badtrials);
    Trials = Trials(goodtrials);
end



CondParams1 = chkCondParams(CondParams1);
CondParams2 = chkCondParams(CondParams2);

Trials1 = Params2Trials(Trials, CondParams1);
Trials2 = Params2Trials(Trials, CondParams2);

sampling = experiment.processing.ieeg.sample_rate;
N = tapers(1); 
if length(tapers)==3
  W = tapers(2)./tapers(1);
else
  W = tapers(2);
end
p = N*W;
k = floor(2*p-1);
tapers = [N,p,k];
tapers(1) = floor(tapers(1).*sampling);  
tapers = mydpsschk(tapers); 

n = length(tapers(:,1));
nf = max(256,pad*2.^(nextpow2(n+1)));
nfk = floor(fk./sampling.*nf);

PD = zeros(length(ChNums),NUM_PERMUTATIONS);
D = nan(1,length(ChNums));
Z = nan(1,length(ChNums));
p = nan(1,length(ChNums));
switch Reference
    case 'Single-ended'
        X1 = trialIEEG(Trials1, ChNums, CondParams1.Field, CondParams1.bn);
        X2 = trialIEEG(Trials2, ChNums, CondParams2.Field, CondParams2.bn);
        if length(Ch) == 1
            [p, D, Z, PD] = calcSpecDiff(X1, X2, tapers, nfk, nf, NUM_PERMUTATIONS);
        else
            for iCh = 1:length(ChNums)
                 [p(iCh), D(iCh), Z(iCh), PD(iCh,:)] = ...
                     calcSpecDiff(sq(X1(:,iCh,:)), sq(X2(:,iCh,:)), ...
                     tapers, nfk, NUM_PERMUTATIONS);
            end
        end
    case 'Grand average'
        IEEG1 = trialIEEG(Trials1, ReferenceChannelNums, CondParams1.Field, ...
            CondParams1.bn);
        GAR_IEEG1 = sq(mean(IEEG1,2));
        IEEG2 = trialIEEG(Trials2, ReferenceChannelNums, CondParams2.Field, ...
            CondParams2.bn);
        GAR_IEEG2 = sq(mean(IEEG2,2));
        for iCh = 1:length(ChNums)
            disp(['Channel: ' num2str(iCh)])
            X1 = sq(IEEG1(:,ReferenceChannelNums==ChNums(iCh),:)) - GAR_IEEG1;
            X2 = sq(IEEG2(:,ReferenceChannelNums==ChNums(iCh),:)) - GAR_IEEG2;
            [p(iCh), D(iCh), Z(iCh), PD(iCh,:)] = ...
                calcSpecDiff(X1, X2, tapers, nfk, nf, NUM_PERMUTATIONS);
        end
            
end

function [p, D, Z, PD] = calcSpecDiff(X1, X2, tapers, nfk, nf, NUM_PERMUTATIONS)

ntr1 = size(X1,1);
ntr2 = size(X2,1);
K = size(tapers,2);

Xk1 = zeros(ntr1*K, diff(nfk),'single');
Xk2 = zeros(ntr2*K, diff(nfk),'single');
meanX1 = sum(X1)./ntr1;
meanX2 = sum(X2)./ntr2;
for tr = 1:ntr1
    tmp1 = (X1(tr,:) - meanX1).';
    xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf).';
    Xk1((tr-1)*K+1:tr*K,:) = xk(:,nfk(1)+1:nfk(2));
end
for tr = 1:ntr2
    tmp1 = (X2(tr,:) - meanX2).';
    xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf).';
    Xk2((tr-1)*K+1:tr*K,:) = xk(:,nfk(1)+1:nfk(2));
end
den1 = K*ntr1;
den2 = K*ntr2;
S_X1 = sum(Xk1.*conj(Xk1))./den1;
S_X2 = sum(Xk2.*conj(Xk2))./den2;
D = (sum(log(S_X1)) - sum(log(S_X2)))./(nfk(2)-nfk(1));
GX = [Xk1;Xk2];  PD = zeros(1,NUM_PERMUTATIONS);
SX = GX.*conj(GX);
Ntot = size(GX,1);
[dum,NP] = sort(rand(Ntot,NUM_PERMUTATIONS));
NP = NP.';
for iPerm = 1:NUM_PERMUTATIONS
    N1 = NP(iPerm,1:den1);
    N2 = NP(iPerm,den1+1:end);
    PS_X1 = sum(SX(N1,:))./den1;
    PS_X2 = sum(SX(N2,:))./den2;
    PD(iPerm) = (sum(log(PS_X1)) -sum(log(PS_X2)))./(nfk(2)-nfk(1));
end
p = sum(abs(PD)>abs(D))./NUM_PERMUTATIONS;
Z = D./std(PD);

function CondParams = chkCondParams(CondParams)

if ~isfield(CondParams,'PropertyName')
    disp('chkCondParams: Setting Noisy and NoResponse to 0')
    CondParams.PropertyName{1} = 'Noisy';
    CondParams.PropertyValue(1) = 0;
    CondParams.PropertyName{2} = 'NoResponse';
    CondParams.PropertyValue(2) = 0;
end
     

if ~isfield(CondParams,'Field') || isempty(CondParams.Field); 
    disp('chkCondParams: Setting Field to ResponseStart');
    CondParams.Field = 'ResponseStart'; 
end

if ~isfield(CondParams,'bn') || isempty(CondParams.bn)
    disp('chkCondParams: Setting bn to [0,500]');
    CondParams.bn = [0,500]; 
end

if ~isfield(CondParams,'Conds') || isempty(CondParams.Conds)
    disp('chkCondParams: Setting Conds to []');
    CondParams.Conds = []; 
end
