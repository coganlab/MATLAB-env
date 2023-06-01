function Data = sessPanelSigDiffCohThreePartSess(Sess, CondParams, AnalParams)
%
%   Data = sessPanelSigDiffCohThreePartSess(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
%   CondParams.cond    =   Eye,Hand,Target conds {[],[],[]}
%
%   AnalParams.Tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time.
%   AnalParams.nPerm   =   Number of permutations in zscore calculation
%                               Defaults to 1e3
%
%   Written by Heather Dean, April 2012

Contact = 1; %HACK!! FIX!!!

if(isfield(AnalParams,'fk'))
    fk = AnalParams.fk;
else
    fk = 200;
end
if length(fk)==1; fk = [0, fk]; end

if(isfield(AnalParams,'sampling_rate'))
    sampling_rate = AnalParams.sampling_rate;
else
    sampling_rate = 1e3;
end
if(isfield(AnalParams,'dn'))
    dn = AnalParams.dn;
else
    dn = 0.05;
end
if(isfield(AnalParams,'pad'))
    pad = AnalParams.pad;
else
    pad = 2;
end
if(isfield(AnalParams,'tapers'))
    tapers = AnalParams.tapers;
else
    tapers = [0.5,10];
end
if(isfield(AnalParams,'bn'))
    bn = AnalParams.bn;
else
    bn = [-1e3,2e3];
end
if(isfield(AnalParams,'Field'))
    Field = AnalParams.Field;
else
    Field = 'TargsOn';
end

if(~isfield(CondParams,'Task'))
    CondParams.Task = 'DelReachSaccade';
end

if(isfield(CondParams,'merge'))
    MergeTrials = CondParams.merge;
else
    MergeTrials = 0;
end

Task = CondParams.Task;
if ischar(Task) && ~isempty(Task)
    NewTask{1} = {Task}; Task = NewTask;
elseif iscell(Task)
    for iTaskComp = 1:length(Task)
        if ~iscell(Task{iTaskComp})
            NewTask(iTaskComp) = {Task(iTaskComp)};
        else
            NewTask(iTaskComp) = Task(iTaskComp);
        end
    end
    Task = NewTask;
end

if(~isfield(CondParams,'conds'))
    CondParams.conds = {[]};
end
if(~isfield(CondParams,'Delay'))
    CondParams.Delay = [500,5e3];
end

if(isfield(AnalParams,'bn'))
    bn = AnalParams.bn;
else
    bn = [-1e3,2e3];
end
if(isfield(AnalParams,'Field'))
    Field = AnalParams.Field;
else
    Field = 'TargsOn';
end
if(isfield(AnalParams,'nPerm'))
    nPerm = AnalParams.nPerm;
else
    nPerm = 1e3;
end
% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    disp('Loading data');
    All_Trials = sessTrials(Sess);
end

Cond_Trials = Params2Trials(All_Trials,CondParams);

if(~iscell(Cond_Trials))
    Trials{1} = Cond_Trials;
else
    Trials = Cond_Trials;
end

Type = getSessionType(Sess);

%We want to merge Trials if multiple tasks are given rather than use just
%the first.
if MergeTrials
    if length(Trials) > 1
        tmpTrials = [];
        for iTask = 1:length(Trials)
            tmpTrials = [tmpTrials Trials{iTask}];
        end
        clear Trials
        Trials{1} = tmpTrials;
    end
end

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

disp([num2str(length(Trials{1})) ' Trials'])
if length(Trials{1}) > 3 && isempty(find(isnan([Trials{1}.(Field)]),1))

    SSess = splitSession(Sess);
    Sys = sessTower(Sess);
    Ch = sessElectrode(Sess);
    Cl = Sess{5};
    if iscell(Cl{1}) Cl(1) = Cl{1}; end
    MonkeyDir = sessMonkeyDir(Sess);
    
    for iSess = 1:3
        SessType{iSess} = getSessionType(SSess{iSess});
        
        switch SessType{iSess}
            case {'Spike','Multiunit'}
                Spike = trialSpike(Trials{1}, Sys{iSess}, Ch(iSess), Contact, Cl(iSess), Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
                Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
                ind{iSess} = 1:size(Spike,1);
                cmdstr = ['Sess' num2str(iSess) 'Sig = Spike;']; eval(cmdstr)
            case {'Field'}
                Lfp = trialLfp(Trials{1}, Sys{iSess}, Ch(iSess), Contact, Field, ...
                    [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
                thresh = 6*std(Lfp(:)); e = max(abs(Lfp'));
                ind{iSess} = intersect(find(e<thresh),find(~isnan(Lfp(:,1))));
                cmdstr = ['Sess' num2str(iSess) 'Sig = Lfp;']; eval(cmdstr)
        end
    end
    
    %Take out bad trials
    goodind = intersect(intersect(ind{1},ind{2}),ind{3});
    numtrials = length(goodind);
    Sess1Sig = Sess1Sig(goodind,:); Sess2Sig = Sess2Sig(goodind,:); Sess3Sig = Sess3Sig(goodind,:);
    
    %Calculate windowed FFTs
    for iSess = 1:3
        switch SessType{iSess}
            case {'Spike','Multiunit'}
                cmdstr = ['Sig' num2str(iSess) 'k = tfspproj_pt(Sess' num2str(iSess) 'Sig, tapers, sampling_rate, dn, fk, pad);']; eval(cmdstr)
            case {'Field'}
                cmdstr = ['Sig' num2str(iSess) 'k = tfsp_proj(Sess' num2str(iSess) 'Sig, tapers, sampling_rate, dn, fk, pad);']; eval(cmdstr)
        end
    end
    
    %---------------------------------------
    nwin = size(Sig2k,2);  nfk = size(Sig2k,4);  K = size(Sig2k,3);
    Sig1k = permute(Sig1k, [1,3,2,4]);
    Sig1k = reshape(Sig1k, [numtrials*K, nwin, nfk]);
    Sig2k = permute(Sig2k, [1,3,2,4]);
    Sig2k = reshape(Sig2k, [numtrials*K, nwin, nfk]);
    Sig3k = permute(Sig3k, [1,3,2,4]);
    Sig3k = reshape(Sig3k, [numtrials*K, nwin, nfk]);
    SSig1 = sq(sum(Sig1k.*conj(Sig1k)));
    SSig2 = sq(sum(Sig2k.*conj(Sig2k)));
    SSig3 = sq(sum(Sig3k.*conj(Sig3k)));
    CrossSpec_S2S1 = sq(sum(Sig2k.*conj(Sig1k)));
    CrossSpec_S3S1 = sq(sum(Sig3k.*conj(Sig1k)));
    CrossSpec_S2S3 = sq(sum(Sig2k.*conj(Sig3k)));
    if nwin == 1
        SSig1 = SSig1.'; SSig2 = SSig2.'; SSig3 = SSig3.'; 
        CrossSpec_S2S1 = CrossSpec_S2S1.';
        CrossSpec_S3S1 = CrossSpec_S3S1.';
        CrossSpec_S2S3 = CrossSpec_S2S3.';
    end
    Coh_S2S1 = CrossSpec_S2S1./sqrt(SSig2.*SSig1);
    Coh_S3S1 = CrossSpec_S3S1./sqrt(SSig3.*SSig1);
    Coh_S2S3 = CrossSpec_S2S3./sqrt(SSig2.*SSig3);

    %Compute p values
    D21_31 = atanh(abs(Coh_S2S1)) - atanh(abs(Coh_S3S1));
     
    fNum = size(D21_31,2);
    D21_31_Perm = zeros(nPerm,fNum);
    pCoh21_31 = zeros(nwin,fNum);
    for iWin = 1:nwin
        Sig1kTot = [sq(Sig1k(:,iWin,:)); sq(Sig1k(:,iWin,:))];
        Sig23kTot = [sq(Sig2k(:,iWin,:)); sq(Sig2k(:,iWin,:))];
        n21_31 = size(Sig23kTot,1);
        parfor iPerm = 1:nPerm
            Indices = randperm(n21_31);
            X1k = Sig1kTot(Indices(1:numtrials*K),:);
            X2k = Sig1kTot(Indices(numtrials*K+1:end),:);
            Y1k = Sig23kTot(Indices(1:numtrials*K),:);
            Y2k = Sig23kTot(Indices(numtrials*K+1:end),:);
            Coh1 = sq(sum(X1k.*conj(Y1k)))./sqrt(sq(sum(X1k.*conj(X1k)).*sum(Y1k.*conj(Y1k))));
            Coh2 = sq(sum(X2k.*conj(Y2k)))./sqrt(sq(sum(X2k.*conj(X2k)).*sum(Y2k.*conj(Y2k))));
            D_S2S1_Perm(iPerm,:) = atanh(abs(Coh1))-atanh(abs(Coh2));
        end
        for iF = 1:fNum
            pCoh21_31(iWin,iF) = length(find(D21_31_Perm(:,iF)>D21_31(iWin,iF)))./nPerm;
        end
    end
    pCoh21_31(pCoh21_31==0) = 1./nPerm;  pCoh21_31(pCoh21_31==1) = (nPerm-1)./nPerm;
else
    disp('Not enough trials');
    nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
    nfk = floor(fk./sampling_rate.*nf);
    t = bn(1):dn*1e3:bn(2);
    f = linspace(fk(1),fk(2),diff(nfk));
    numtrials = 0;
    pCoh21_31 = zeros(length(t)-1,diff(nfk),'single');
    Coh_S2S1 = zeros(length(t)-1,diff(nfk),'single');
    Coh_S3S1 = Coh_S2S1; Coh_S2S3 = Coh_S2S1;
end

nf = max(256,pad*2^nextpow2(N*sampling_rate+1));
nfk = floor(fk./sampling_rate.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
t = bn(1):dn*1e3:bn(2);
Data.t = t;
Data.NumTrials = numtrials;
Data.Data = pCoh21_31;
Data.SuppData.Coh_S2S1 = Coh_S2S1;
Data.SuppData.Coh_S3S1 = Coh_S3S1;
Data.SuppData.Coh_S2S3 = Coh_S2S3;
Data.f = f;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Sess = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;

Data.xax = t;
Data.yax = f;
