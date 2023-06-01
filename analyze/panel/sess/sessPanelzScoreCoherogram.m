function [Data, Raw] = sessPanelzScoreCoherogram(Sess, CondParams, AnalParams)
%
%   [Data, Raw] = sessPanelzScoreCoherogram(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for
%   condition information
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.sort{}{}
%
%   AnalParams.tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time.
%   AnalParams.nPerm      =   Scalar.  Number of permutations to run

%
%   CondParams.Diff.Task    =   String/Cell.  Tasks to pool and compare.
%                               To pool Task = {{'Task1','Task2'}};
%   CondParams.Diff.Cond    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.Diff.sort{}{}
%   AnalParams.Diff.Field   =   String.  Alignment field
%   AnalParams.Diff.bn      =   Alignment time.


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

DiffTask = '';
DiffCond = {[]};
Diffbn = [-tapers(1)*sampling_rate,0];
DiffField = 'TargsOn';
DiffDelay = [500,5e3];
if(isfield(AnalParams,'Diff'))
    if(isfield(AnalParams.Diff,'bn'))
        Diffbn = AnalParams.Diff.bn;
    end
    if(isfield(AnalParams,'Field'))
        DiffField = AnalParams.Diff.Field;
    end
end

if(isfield(CondParams,'Diff'))
    if(isfield(CondParams.Diff,'Task'))
        DiffTask = CondParams.Diff.Task;
    end
    if(isfield(CondParams.Diff,'conds'))
        DiffCond = CondParams.Diff.conds;
    end
    if(isfield(CondParams.Diff,'sort'))
        Diffsort = CondParams.Diff.sort;
        DiffCondParams.sort = Diffsort;
    end
    DiffCondParams = CondParams.Diff;
end

if ischar(DiffTask) && ~isempty(DiffTask)
    NewTask{1} = {DiffTask}; DiffTask = NewTask;
elseif iscell(DiffTask)
    for iTaskComp = 1:length(DiffTask)
        if ~iscell(DiffTask{iTaskComp})
            NewTask(iTaskComp) = {DiffTask(iTaskComp)};
        else
            NewTask(iTaskComp) = DiffTask(iTaskComp);
        end
    end
    DiffTask = NewTask;
end

DiffCondParams.Task = DiffTask;
DiffCondParams.conds = DiffCond;

% This handles Trials in Sess{1} instead of Day.
if isstruct(Sess{1})
    All_Trials = Sess{1};
else
    disp('Loading data');
    All_Trials = sessTrials(Sess);
end
Cond_Trials = Params2Trials(All_Trials,CondParams);
DiffCond_Trials = Params2Trials(All_Trials,DiffCondParams);

if(~iscell(Cond_Trials))
    Trials{1} = Cond_Trials;
else
    Trials = Cond_Trials;
end
if(~iscell(DiffCond_Trials))
    DiffTrials{1} = DiffCond_Trials;
else
    DiffTrials = DiffCond_Trials;
end

Type = getSessionType(Sess);

N = tapers(1);
if length(tapers)==3
    W = tapers(2)./tapers(1);
else
    W = tapers(2);
end

if length(Trials{1}) > 3 && length(DiffTrials{1}) > 3 && ...
        isempty(find(isnan([Trials{1}.(Field)]),1)) %&& isempty(find(isnan([DiffTrials{1}.(Field)]),1))
    switch Type
        case 'FieldField'
            Sys = sessTower(Sess);
            Sys1 = Sys{1};
            if iscell(Sys1); Sys1 = Sys1{1}; end
            Sys2 = Sys{2};
            if iscell(Sys2); Sys2 = Sys2{1}; end
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            MonkeyDir = sessMonkeyDir(Sess);

            Lfp1 = trialLfp(Trials{1}, Sys{1}, Ch(1), Contact(1), Field, ...
                [bn(1)-N./2*sampling_rate,bn(2)+N./2*sampling_rate], MonkeyDir);
            Lfp2 = trialLfp(Trials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*sampling_rate,bn(2)+N./2*sampling_rate], MonkeyDir);
            thresh1 = 6*std(Lfp1(:)); e1 = max(abs(Lfp1'));
            thresh2 = 6*std(Lfp2(:)); e2 = max(abs(Lfp2'));
            ind = find(e1<thresh1 & e2<thresh2);
            numtrials = length(ind);
            num_Trials = numtrials;
            disp([num2str(numtrials) ' Trials'])
            
            Lfp1 = Lfp1(ind,:);  Lfp2 = Lfp2(ind,:);
            Raw.Lfp1 = Lfp1; Raw.Lfp2 = Lfp2;
            
            Lfpk1 = tfsp_proj(Lfp1, tapers, sampling_rate, dn, fk, pad);
            Lfpk2 = tfsp_proj(Lfp2, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfpk1,2);  nfk = size(Lfpk1,4);  K = size(Lfpk1,3);
            Lfpk1 = permute(Lfpk1, [1,3,2,4]);
            Lfpk1 = reshape(Lfpk1, [numtrials*K, nwin, nfk]);
            Lfpk2 = permute(Lfpk2, [1,3,2,4]);
            Lfpk2 = reshape(Lfpk2, [numtrials*K, nwin, nfk]);
            Coh = sq(sum(Lfpk1.*conj(Lfpk2)))./sqrt(sq(sum(Lfpk1.*conj(Lfpk1)).*sum(Lfpk2.*conj(Lfpk2))));
            
            if diff(Diffbn) == N*sampling_rate  % Baseline normalization
                DiffLfp1 = trialLfp(DiffTrials{1}, Sys{1}, Ch(1), Contact(1), DiffField, Diffbn, MonkeyDir);
                DiffLfp2 = trialLfp(DiffTrials{1}, Sys{2}, Ch(2), Contact(2), DiffField, Diffbn, MonkeyDir);
                thresh1 = 6*std(DiffLfp1(:)); e1 = max(abs(DiffLfp1'));
                thresh2 = 6*std(DiffLfp2(:)); e2 = max(abs(DiffLfp2'));
                ind = find(e1<thresh1 & e2<thresh2);
                num_DiffTrials = length(ind);
                disp([num2str(num_DiffTrials) ' Diff Trials'])
                DiffLfp1 = DiffLfp1(ind,:);  DiffLfp2 = DiffLfp2(ind,:);
                Raw.DiffLfp1 = Lfp1; Raw.DiffLfp2 = DiffLfp2;
                
                DiffLfpk1 = sp_proj(DiffLfp1, tapers, sampling_rate, fk, pad);
                DiffLfpk2 = sp_proj(DiffLfp2, tapers, sampling_rate, fk, pad);
                diffntrials = size(DiffLfpk1,1);  nfk = size(DiffLfpk1,3);
                DiffLfpk1 = reshape(DiffLfpk1, [diffntrials*K, nfk]);
                DiffLfpk2 = reshape(DiffLfpk2, [diffntrials*K, nfk]);
                DiffCoh = sq(sum(DiffLfpk1.*conj(DiffLfpk2)))./sqrt(sq(sum(DiffLfpk1.*conj(DiffLfpk1)).*sum(DiffLfpk2.*conj(DiffLfpk2))));
                
                D = atanh(abs(Coh)) - atanh(abs(DiffCoh(ones(1,size(Coh,1)),:)));
                pCoh = zeros(size(Coh,1),size(Coh,2));
                for iWin = 1:size(Coh,1)
                    DPerm = zeros(nPerm,size(Coh,2));
                    Lfp1kTot = [sq(Lfpk1(:,iWin,:)); DiffLfpk1];
                    Lfp2kTot = [sq(Lfpk2(:,iWin,:)); DiffLfpk2];
                    nLfpTot = size(Lfp1kTot,1);
                    for iPerm = 1:nPerm
                        Indices1 = randperm(nLfpTot);
                        Indices2 = randperm(nLfpTot);
                        Xk1 = Lfp1kTot(Indices1(1:numtrials*K),:);
                        Yk1 = Lfp1kTot(Indices1(numtrials*K+1:end),:);
                        Xk2 = Lfp2kTot(Indices2(1:numtrials*K),:);
                        Yk2 = Lfp2kTot(Indices2(numtrials*K+1:end),:);
                        Coh1 = sq(sum(Xk1.*conj(Xk2)))./sqrt(sq(sum(Xk1.*conj(Xk1)).*sum(Xk2.*conj(Xk2))));
                        Coh2 = sq(sum(Yk1.*conj(Yk2)))./sqrt(sq(sum(Yk1.*conj(Yk1)).*sum(Yk2.*conj(Yk2))));
                        DPerm(iPerm,:) = atanh(abs(Coh1)) - atanh(abs(Coh2));
                    end
                    for iF = 1:size(D,2)
                        pCoh(iWin,iF) = length(find(abs(DPerm(:,iF))>abs(D(iWin,iF))))./nPerm;
                    end
                    pCoh(pCoh==0) = 1./nPerm;  %pCoh(pCoh==1) = (nPerm-1)./nPerm;
                    
                end
                zCoh = sign(D)*norminv(1-pCoh,0,1);
                dCoh = D;
                
            elseif diff(Diffbn)==diff(bn)
                DiffLfp1 = trialLfp(DiffTrials{1}, Sys{1}, Ch(1), DiffField, ...
                    [Diffbn(1)-N./2*sampling_rate,Diffbn(2)+N./2*sampling_rate], MonkeyDir);
                DiffLfp2 = trialLfp(DiffTrials{1}, Sys{2}, Ch(2), DiffField, ...
                    [Diffbn(1)-N./2*sampling_rate,Diffbn(2)+N./2*sampling_rate], MonkeyDir);
                thresh1 = 6*std(DiffLfp1(:)); e1 = max(abs(DiffLfp1'));
                thresh2 = 6*std(DiffLfp2(:)); e2 = max(abs(DiffLfp2'));
                ind = find(e1<thresh1 & e2<thresh2);
                num_DiffTrials = length(ind);
                disp([num2str(num_DiffTrials) ' Diff Trials'])
                DiffLfp1 = DiffLfp1(ind,:);  DiffLfp2 = DiffLfp2(ind,:);
                Raw.DiffLfp1 = DiffLfp1; Raw.DiffLfp2 = DiffLfp2;
                
                DiffLfp1k = tfsp_proj(DiffLfp1, tapers, sampling_rate, dn, fk, pad);
                DiffLfp2k = tfsp_proj(DiffLfp2, tapers, sampling_rate, dn, fk, pad);
                nwin = size(DiffLfp1k,2);  nfk = size(DiffLfp1k,4); diffntrials = size(DiffLfp1k,1);
                DiffLfp1k = permute(DiffLfp1k, [1,3,2,4]);
                DiffLfp1k = reshape(DiffLfp1k, [diffntrials*K, nwin, nfk]);
                DiffLfp2k = permute(DiffLfp2k, [1,3,2,4]);
                DiffLfp2k = reshape(DiffLfp2k, [diffntrials*K, nwin, nfk]);
                DiffCoh = sq(sum(DiffLfp1k.*conj(DiffLfp2k)))./sqrt(sq(sum(DiffLfp1k.*conj(DiffLfp1k)).*sum(DiffLfp2k.*conj(DiffLfp2k))));
                
                D = atanh(abs(Coh)) - atanh(abs(DiffCoh));
                pCoh = zeros(size(Coh,1),size(Coh,2));
                for iWin = 1:size(Coh,1)
                    DPerm = zeros(nPerm,size(Coh,2));
                    Lfp1kTot = [sq(Lfpk1(:,iWin,:)); sq(DiffLfp1k(:,iWin,:))];
                    Lfp2kTot = [sq(Lfpk2(:,iWin,:)); sq(DiffLfp2k(:,iWin,:))];
                    nLfpTot = size(Lfp1kTot,1);
                    for iPerm = 1:nPerm
                        Indices1 = randperm(nLfpTot);
                        Indices2 = randperm(nLfpTot);
                        Xk1 = Lfp1kTot(Indices1(1:numtrials*K),:);
                        Yk1 = Lfp1kTot(Indices1(numtrials*K+1:end),:);
                        Xk2 = Lfp2kTot(Indices2(1:numtrials*K),:);
                        Yk2 = Lfp2kTot(Indices2(numtrials*K+1:end),:);
                        Coh1 = squeeze(sum(Xk1.*conj(Xk2)))./sqrt(squeeze(sum(Xk1.*conj(Xk1)).*sum(Xk2.*conj(Xk2))));
                        Coh2 = squeeze(sum(Yk1.*conj(Yk2)))./sqrt(squeeze(sum(Yk1.*conj(Yk1)).*sum(Yk2.*conj(Yk2))));
                        DPerm(iPerm,:) = atanh(abs(Coh1)) - atanh(abs(Coh2));
                    end
                    for iF = 1:size(D,2)
                        pCoh(iWin,iF) = length(find(abs(DPerm(:,iF))>abs(D(iWin,iF))))./nPerm;
                    end
                    pCoh(pCoh==0) = 1./nPerm;  %pCoh(pCoh==1) = (nPerm-1)./nPerm;
                    
                end
                zCoh = sign(D).*norminv(1-pCoh,0,1);
                dCoh = D;
            else
                error('Normalization time definition is wrong');
            end
            
        case {'SpikeField','MultiunitField'}
            Sys = sessTower(Sess);
            Sys1 = Sys{1};
            if iscell(Sys1); Sys1 = Sys1{1}; end
            Sys2 = Sys{2};
            if iscell(Sys2); Sys2 = Sys2{1}; end
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            Cl = sessCell(Sess);
            if iscell(Cl{1}) Cl(1) = Cl{1}; end
            MonkeyDir = sessMonkeyDir(Sess);
            
            Lfp = trialLfp(Trials{1}, Sys{2}, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            Spike = trialSpike(Trials{1}, Sys{1}, Ch(1), Contact(1), Cl(1), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
            n = sum(Spike,2)';
            thresh = 6*std(Lfp(:)); e = max(abs(Lfp'));
            ind = find(e<thresh & n>0);
            numtrials = length(ind);
            num_Trials = numtrials;
            disp([num2str(num_Trials) ' Trials'])
            Lfp = Lfp(ind,:);  Spike = Spike(ind,:);
            Raw.Lfp = Lfp; Raw.Spike = Spike;
            
            Lfpk = tfsp_proj(Lfp, tapers, sampling_rate, dn, fk, pad);
            Spikek = tfspproj_pt(Spike, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfpk,2);  nfk = size(Lfpk,4);  K = size(Lfpk,3);
            Lfpk = permute(Lfpk, [1,3,2,4]);
            Lfpk = reshape(Lfpk, [numtrials*K, nwin, nfk]);
            Spikek = permute(Spikek, [1,3,2,4]);
            Spikek = reshape(Spikek, [numtrials*K, nwin, nfk]);
            Coh = sq(sum(Lfpk.*conj(Spikek)))./sqrt(sq(sum(Lfpk.*conj(Lfpk)).*sum(Spikek.*conj(Spikek))));
            
            Coh = Coh';
            
            if diff(Diffbn) == N*sampling_rate
                DiffSpike = trialSpike(DiffTrials{1}, Sys{1}, Ch(1), Contact(1), Cl(1), DiffField, Diffbn);
                DiffSpike = sp2ts(DiffSpike,[0,(diff(Diffbn)-1)./1e3,1e3], MonkeyDir);
                DiffLfp = trialLfp(DiffTrials{1}, Sys{2}, Ch(2), Contact(2), DiffField, Diffbn, MonkeyDir);
                thresh = 6*std(DiffLfp(:)); e = max(abs(DiffLfp'));
                n = sum(DiffSpike,2)';
                ind = find(e<thresh & n>0);
                num_DiffTrials = length(ind);
                disp([num2str(num_DiffTrials) ' Diff Trials'])
                DiffLfp = DiffLfp(ind,:);  DiffSpike = DiffSpike(ind,:);
                Raw.DiffLfp = DiffLfp; Raw.DiffSpike = DiffSpike;
                
                DiffLfpk = sp_proj(DiffLfp, tapers, sampling_rate, fk, pad);
                DiffSpikek = spproj_pt(DiffSpike, tapers, sampling_rate, fk, pad);
                diffntrials = size(DiffLfpk,1);  nfk = size(DiffLfpk,3);
                DiffLfpk = reshape(DiffLfpk, [diffntrials*K, nfk]);
                DiffSpikek = reshape(DiffSpikek, [diffntrials*K, nfk]);
                DiffCoh = sq(sum(DiffLfpk.*conj(DiffSpikek)))./sqrt(sq(sum(DiffLfpk.*conj(DiffLfpk)).*sum(DiffSpikek.*conj(DiffSpikek))));

                D = atanh(abs(Coh)) - atanh(abs(DiffCoh(ones(1,size(Coh,1)),:)));

                pCoh = zeros(size(Coh,1),size(Coh,2));
                for iWin = 1:size(Coh,1)
                    DPerm = zeros(nPerm,size(Coh,2));
                    SpikekTot = [sq(Spikek(:,iWin,:)); DiffSpikek];
                    LfpkTot = [sq(Lfpk(:,iWin,:)); DiffLfpk];
                    nLfpTot = size(LfpkTot,1);
                    for iPerm = 1:nPerm
                        Indices1 = randperm(nLfpTot);
                        Indices2 = randperm(nLfpTot);
                        X1k = LfpkTot(Indices1(1:numtrials*K),:);
                        X2k = LfpkTot(Indices1(numtrials*K+1:end),:);
                        Y1k = SpikekTot(Indices2(1:numtrials*K),:);
                        Y2k = SpikekTot(Indices2(numtrials*K+1:end),:);
                        Coh1 = sq(sum(X1k.*conj(Y1k)))./sqrt(sq(sum(X1k.*conj(X1k)).*sum(Y1k.*conj(Y1k))));
                        Coh2 = sq(sum(X2k.*conj(Y2k)))./sqrt(sq(sum(X2k.*conj(X2k)).*sum(Y2k.*conj(Y2k))));
                        DPerm(iPerm,:) = atanh(abs(Coh1)) - atanh(abs(Coh2));
                    end
                    for iF = 1:size(D,2)
                        pCoh(iWin,iF) = length(find(abs(DPerm(:,iF))>abs(D(iWin,iF))))./nPerm;
                    end
                    pCoh(pCoh==0) = 1./nPerm;  %pCoh(pCoh==1) = (nPerm-1)./nPerm;
                end
                zCoh = sign(D).*norminv(1-pCoh,0,1);
                dCoh = D;
            elseif diff(Diffbn)==diff(bn)
                DiffSpike = trialSpike(DiffTrials{1}, Sys{1}, Ch(1), Contact(1), Cl(1), DiffField, ...
                    [Diffbn(1)-N./2*1e3,Diffbn(2)+N./2.*1e3], MonkeyDir);
                DiffSpike = sp2ts(DiffSpike, [0,diff(bn)./1e3+N,1e3]);
                DiffLfp = trialMlfp(DiffTrials{1}, Sys{2}, Ch(2), Contact(2), DiffField, ...
                    [Diffbn(1)-N./2*1e3,Diffbn(2)+N./2*1e3], MonkeyDir);
                thresh = 6*std(DiffLfp(:)); e = max(abs(DiffLfp'));
                n = sum(DiffSpike,2)';
                ind = find(e<thresh & n>0);
                num_DiffTrials = length(ind);
                disp([num2str(num_DiffTrials) ' Diff Trials'])
                DiffLfp = DiffLfp(ind,:); DiffSpike = DiffSpike(ind,:);
                Raw.DiffLfp = DiffLfp; Raw.DiffSpike = DiffSpike;
                
                DiffLfpk = tfsp_proj(DiffLfp, tapers, sampling_rate, dn, fk, pad);
                DiffSpikek = tfspproj_pt(DiffSpike, tapers, sampling_rate, dn, fk, pad);
                diffntrials = size(DiffLfpk,1); nwin = size(DiffLfpk,2);  nfk = size(DiffLfpk,4);
                DiffLfpk = permute(DiffLfpk, [1,3,2,4]);
                DiffLfpk = reshape(DiffLfpk, [diffntrials*K, nwin, nfk]);
                DiffSpikek = permute(DiffSpikek, [1,3,2,4]);
                DiffSpikek = reshape(DiffSpikek, [diffntrials*K, nwin, nfk]);
                DiffCoh = sq(sum(DiffLfpk.*conj(DiffSpikek)))./sqrt(sq(sum(DiffLfpk.*conj(DiffLfpk)).*sum(DiffSpikek.*conj(DiffSpikek))));
                
                D = atanh(abs(Coh)) - atanh(abs(DiffCoh));
                pCoh = zeros(size(Coh,1),size(Coh,2));
                for iWin = 1:size(DiffCoh,1);
                    DPerm = zeros(nPerm,size(DiffCoh,2),'single');
                    SpikekTot = [sq(Spikek(:,iWin,:)); sq(DiffSpikek(:,iWin,:))];
                    LfpkTot = [sq(Lfpk(:,iWin,:)); sq(DiffLfpk(:,iWin,:))];
                    nLfpTot = size(LfpkTot,1);
                    for iPerm = 1:nPerm
                        Indices1 = randperm(nLfpTot);
                        Indices2 = randperm(nLfpTot);
                        X1k = LfpkTot(Indices1(1:numtrials*K),:);
                        X2k = LfpkTot(Indices1(numtrials*K+1:end),:);
                        Y1k = SpikekTot(Indices2(1:numtrials*K),:);
                        Y2k = SpikekTot(Indices2(numtrials*K+1:end),:);
                        Coh1 = sq(sum(X1k.*conj(Y1k)))./sqrt(sq(sum(X1k.*conj(X1k)).*sum(Y1k.*conj(Y1k))));
                        Coh2 = sq(sum(X2k.*conj(Y2k)))./sqrt(sq(sum(X2k.*conj(X2k)).*sum(Y2k.*conj(Y2k))));
                        DPerm(iPerm,:) = atanh(abs(Coh1))-atanh(abs(Coh2));
                    end
                    for iF = 1:size(D,2)
                        pCoh(iWin,iF) = length(find(abs(DPerm(:,iF))>abs(D(iWin,iF))))./nPerm;
                    end
                    pCoh(pCoh==0) = 1./nPerm;  %pCoh(pCoh==1) = (nPerm-1)./nPerm;
                end
                zCoh = sign(D).*norminv(1-pCoh,0,1);
                dCoh = D;
            else
                error('Normalization time definition is wrong');
            end
 
    end
else
    disp('Not enough trials');
    nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
    nfk = floor(fk./sampling_rate.*nf);
    f = linspace(fk(1),fk(2),diff(nfk));
    t = bn(1):dn*1e3:bn(2);
    num_Trials = 0;  num_DiffTrials = 0;
    zCoh = zeros(length(t)-1,diff(nfk),'single');
    dCoh = zeros(length(t)-1,diff(nfk),'single');
    pCoh = zeros(length(t)-1,diff(nfk),'single');
    Coh = zeros(length(t)-1,diff(nfk),'single');
    DiffCoh = zeros(length(t)-1,diff(nfk),'single');
    Raw = struct([]);
end
nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
nfk = floor(fk./sampling_rate.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
t = bn(1):dn*1e3:bn(2);
Data.t = t;
Data.NumTrials = num_Trials;
Data.NumDiffTrials = num_DiffTrials;
Data.Data = zCoh;
Data.SuppData.dCoh = dCoh;
Data.SuppData.pCoh = pCoh;
Data.SuppData.Coh = Coh;
Data.SuppData.DiffCoh = DiffCoh;
Data.f = f;

DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Sess = DataSession;
Data.CondParams = CondParams;
Data.AnalParams = AnalParams;


Data.xax = t;
Data.yax = f;
