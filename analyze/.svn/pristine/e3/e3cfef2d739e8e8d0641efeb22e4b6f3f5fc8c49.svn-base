function Data = sessPanelPartialCoherency(Sess, CondParams, AnalParams)
%
%   Data = sessPanelPartialCoherency(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for%
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
%   DATA 
%
%   Data.Data{1} = ParCoh_S2S1_S3;
%   Data.Data{2} = ParCoh_S3S1_S2;
%   Data.Data{3} = ParCoh_S2S3_S1;
%
%   Data.SuppData contains subfields
% pCoh{1} = pCoh_S2S1;
% pCoh{2} = pCoh_S3S1;
% pCoh{3} = pCoh_S2S3;
% pParCoh{1} = pParCoh_S2S1_S3;
% pParCoh{2} = pParCoh_S3S1_S2;
% pParCoh{3} = pParCoh_S2S3_S1;
% Coh{1} = Coh_S2S1;
% Coh{2} = Coh_S3S1;
% Coh{3} = Coh_S2S3;

%   Written by Heather Dean, January 2012
%   Updated 2 April 12

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
    Contact = sessContact(Sess);
    Cl = sessCellDepthInfo(Sess);
    MonkeyDir = sessProjectDir(Sess);
    
    for iSess = 1:3
        SessType{iSess} = getSessionType(SSess{iSess});
        
        switch SessType{iSess}
            case {'Spike','Multiunit'}
                sys = Sys{iSess};
                if iscell(sys); sys = sys{1}; end
                Spike = trialSpike(Trials{1}, sys, Ch(iSess), Contact(iSess),Cl(iSess), Field, ...
                    [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
                Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
                ind{iSess} = 1:size(Spike,1);
                cmdstr = ['Sess' num2str(iSess) 'Sig = Spike;']; eval(cmdstr)
            case {'Field'}
                sys = Sys{iSess};
                if iscell(sys); sys = sys{1}; end
                Lfp = trialLfp(Trials{1}, sys, Ch(iSess), Contact(iSess), Field, ...
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
    Coh_S3S2 = conj(Coh_S2S3);
    Coh_S1S3 = conj(Coh_S3S1);
    
    Coh{1} = Coh_S2S1;
    Coh{2} = Coh_S3S1;
    Coh{3} = Coh_S2S3;
    
    %Work on partial Coh here
    magsq_Coh_S2S1 = Coh_S2S1.*conj(Coh_S2S1);
    magsq_Coh_S3S1 = Coh_S3S1.*Coh_S1S3;
    magsq_Coh_S2S3 = Coh_S2S3.*Coh_S3S2;
    magsq_Coh_S3S2 = magsq_Coh_S2S3;
    magsq_Coh_S1S3 = magsq_Coh_S3S1;
    
    ParCoh_S2S1_S3 = (Coh_S2S1 - Coh_S2S3.*Coh_S3S1) ./ ...
        sqrt((1-magsq_Coh_S2S3) .* (1-magsq_Coh_S3S1));
    
    ParCoh_S3S1_S2 = (Coh_S3S1 - Coh_S3S2.*Coh_S2S1) ./ ...
       sqrt((1-magsq_Coh_S3S2) .* (1-magsq_Coh_S2S1));
    
    ParCoh_S2S3_S1 = (Coh_S2S3 - Coh_S2S1.*Coh_S1S3) ./ ...
       sqrt((1-magsq_Coh_S2S1) .* (1-magsq_Coh_S1S3));
   
   ParCoh{1} = ParCoh_S2S1_S3;
   ParCoh{2} = ParCoh_S3S1_S2;
   ParCoh{3} = ParCoh_S2S3_S1;
        
    %Compute p values
    D_Coh_S2S1 = magsq_Coh_S2S1;
    D_Coh_S3S1 = magsq_Coh_S3S1;
    D_Coh_S2S3 = magsq_Coh_S2S3;
    D_ParCoh_S2S1_S3 = ParCoh_S2S1_S3 .* conj(ParCoh_S2S1_S3);
    D_ParCoh_S3S1_S2 = ParCoh_S3S1_S2 .* conj(ParCoh_S3S1_S2);
    D_ParCoh_S2S3_S1 = ParCoh_S2S3_S1 .* conj(ParCoh_S2S3_S1);
    
    fNum = size(D_Coh_S2S1,2);
    D_Coh_S2S1_Perm = zeros(nPerm,fNum);
    D_Coh_S3S1_Perm = D_Coh_S2S1_Perm;
    D_Coh_S2S3_Perm = D_Coh_S2S1_Perm;
    D_ParCoh_S2S1_S3_Perm = D_Coh_S2S1_Perm;
    D_ParCoh_S3S1_S2_Perm = D_Coh_S2S1_Perm;
    D_ParCoh_S2S3_S1_Perm = D_Coh_S2S1_Perm;
    pCoh_S2S1 = zeros(nwin,fNum);
    pCoh_S3S1 = pCoh_S2S1;
    pCoh_S2S3 = pCoh_S2S1;
    pParCoh_S2S1_S3 = pCoh_S2S1;
    pParCoh_S3S1_S2 = pCoh_S2S1;
    pParCoh_S2S3_S1 = pCoh_S2S1;
    
    for iWin = 1:nwin
        Sig1kWin = sq(Sig1k(:,iWin,:));
        Sig2kWin = sq(Sig2k(:,iWin,:));
        Sig3kWin = sq(Sig3k(:,iWin,:));
        Sig1Win = sq(SSig1(iWin,:));
        Sig2Win = sq(SSig2(iWin,:));
        Sig3Win = sq(SSig3(iWin,:));
        num_S2S1 = sqrt(Sig2Win.*Sig1Win);
        num_S3S1 = sqrt(Sig3Win.*Sig1Win);
        num_S2S3 = sqrt(Sig2Win.*Sig3Win);
        X1k = Sig1kWin;
        for iPerm = 1:nPerm
            Indices1 = randperm(numtrials*K);
            Indices2 = randperm(numtrials*K);
            X2k = Sig2kWin(Indices1,:);
            X3k = Sig3kWin(Indices2,:);
            
            Coh_S2S1_Perm = sq(sum(X2k.*conj(X1k)))./num_S2S1;
            Coh_S3S1_Perm = sq(sum(X3k.*conj(X1k)))./num_S3S1;
            Coh_S2S3_Perm = sq(sum(X2k.*conj(X3k)))./num_S2S3;
            Coh_S1S3_Perm = conj(Coh_S3S1_Perm);
            Coh_S3S2_Perm = conj(Coh_S2S3_Perm);
            magsq_Coh_S2S1 = Coh_S2S1_Perm.*conj(Coh_S2S1_Perm);
            magsq_Coh_S3S1 = Coh_S3S1_Perm.*Coh_S1S3_Perm;
            magsq_Coh_S2S3 = Coh_S2S3_Perm.*Coh_S3S2_Perm;
            magsq_Coh_S3S2 = magsq_Coh_S2S3;
            magsq_Coh_S1S3 = magsq_Coh_S3S1;
            
            ParCoh_S2S1_S3_Perm = (Coh_S2S1_Perm - Coh_S2S3_Perm.*Coh_S3S1_Perm) ./ ...
                sqrt((1-magsq_Coh_S2S3) .* (1-magsq_Coh_S3S1));
            ParCoh_S3S1_S2_Perm = (Coh_S3S1_Perm - Coh_S3S2_Perm.*Coh_S2S1_Perm) ./ ...
                sqrt((1-magsq_Coh_S3S2) .* (1-magsq_Coh_S2S1));
            ParCoh_S2S3_S1_Perm = (Coh_S2S3_Perm - Coh_S2S1_Perm.*Coh_S1S3_Perm) ./ ...
                sqrt((1-magsq_Coh_S2S1) .* (1-magsq_Coh_S1S3));
            
            %compute p values for Coh
            D_Coh_S2S1_Perm(iPerm,:) = magsq_Coh_S2S1;
            D_Coh_S3S1_Perm(iPerm,:) = magsq_Coh_S3S1;
            D_Coh_S2S3_Perm(iPerm,:) = magsq_Coh_S2S3;
            D_ParCoh_S2S1_S3_Perm(iPerm,:) = ParCoh_S2S1_S3_Perm .* conj(ParCoh_S2S1_S3_Perm);
            D_ParCoh_S3S1_S2_Perm(iPerm,:) = ParCoh_S3S1_S2_Perm .* conj(ParCoh_S3S1_S2_Perm);
            D_ParCoh_S2S3_S1_Perm(iPerm,:) = ParCoh_S2S3_S1_Perm .* conj(ParCoh_S2S3_S1_Perm);
        end
        for iF = 1:fNum
            pCoh_S2S1(iWin,iF) = length(find(D_Coh_S2S1_Perm(:,iF)>D_Coh_S2S1(iWin,iF)))./nPerm;
            pCoh_S3S1(iWin,iF) = length(find(D_Coh_S3S1_Perm(:,iF)>D_Coh_S3S1(iWin,iF)))./nPerm;
            pCoh_S2S3(iWin,iF) = length(find(D_Coh_S2S3_Perm(:,iF)>D_Coh_S2S3(iWin,iF)))./nPerm;
            pParCoh_S2S1_S3(iWin,iF) = length(find(D_ParCoh_S2S1_S3_Perm(:,iF)>D_ParCoh_S2S1_S3(iWin,iF)))./nPerm;
            pParCoh_S3S1_S2(iWin,iF) = length(find(D_ParCoh_S3S1_S2_Perm(:,iF)>D_ParCoh_S3S1_S2(iWin,iF)))./nPerm;
            pParCoh_S2S3_S1(iWin,iF) = length(find(D_ParCoh_S2S3_S1_Perm(:,iF)>D_ParCoh_S2S3_S1(iWin,iF)))./nPerm;
        end
    end
    pCoh_S2S1(pCoh_S2S1==0) = 1./nPerm;  pCoh_S2S1(pCoh_S2S1==1) = (nPerm-1)./nPerm;
    pCoh_S3S1(pCoh_S3S1==0) = 1./nPerm;  pCoh_S3S1(pCoh_S3S1==1) = (nPerm-1)./nPerm;
    pCoh_S2S3(pCoh_S2S3==0) = 1./nPerm;  pCoh_S2S3(pCoh_S2S3==1) = (nPerm-1)./nPerm;
    pParCoh_S2S1_S3(pParCoh_S2S1_S3==0) = 1./nPerm;  pParCoh_S2S1_S3(pParCoh_S2S1_S3==1) = (nPerm-1)./nPerm;
    pParCoh_S3S1_S2(pParCoh_S3S1_S2==0) = 1./nPerm;  pParCoh_S3S1_S2(pParCoh_S3S1_S2==1) = (nPerm-1)./nPerm;
    pParCoh_S2S3_S1(pParCoh_S2S3_S1==0) = 1./nPerm;  pParCoh_S2S3_S1(pParCoh_S2S3_S1==1) = (nPerm-1)./nPerm;
    
    pCoh{1} = pCoh_S2S1;
    pCoh{2} = pCoh_S3S1;
    pCoh{3} = pCoh_S2S3;
    pParCoh{1} = pParCoh_S2S1_S3;
    pParCoh{2} = pParCoh_S3S1_S2;
    pParCoh{3} = pParCoh_S2S3_S1;
else
    disp('Not enough trials');
    nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
    nfk = floor(fk./sampling_rate.*nf);
    t = bn(1):dn*1e3:bn(2);
    f = linspace(fk(1),fk(2),diff(nfk));
    numtrials = 0;
    pCoh = zeros(length(t)-1,diff(nfk),'single');
    pParCoh = zeros(length(t)-1,diff(nfk),'single');
    Coh = zeros(length(t)-1,diff(nfk),'single');
    ParCoh = zeros(length(t)-1,diff(nfk),'single');
end

nf = max(256,pad*2^nextpow2(N*sampling_rate+1));
nfk = floor(fk./sampling_rate.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
t = bn(1):dn*1e3:bn(2);
Data.t = t;
Data.NumTrials = numtrials;
Data.Data = ParCoh;
Data.SuppData.pCoh = pCoh;
Data.SuppData.pParCoh = pParCoh;
Data.SuppData.Coh = Coh;
Data.SuppData.Sess = Sess;
Data.f = f;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Sess = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;


Data.xax = t;
Data.yax = f;
