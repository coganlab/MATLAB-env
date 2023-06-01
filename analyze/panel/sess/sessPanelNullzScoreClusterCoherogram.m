function Data = sessPanelNullzScoreCoherogram(Sess, CondParams, AnalParams)
%
%   Data = sessPanelNullzScoreCoherogram(Sess,CondParams,AnalParams)
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
%   AnalParams.tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test
%   AnalParams.Field   =   String.  Alignment field
%   AnalParams.bn      =   Alignment time.
%   AnalParams.nPerm   =   Number of permutations in zscore calculation
%                               Defaults to 1e3
%   AnalParams.Sig     =   zscore to consider significant

% global MONKEYDIR MONKEYNAME

if(isfield(AnalParams,'fk'))
    fk = AnalParams.fk;
else
    fk = 200;
end
if length(fk)==1; fk = [0, fk]; end
if(isfield(AnalParams,'Sig'))
    Sig = AnalParams.Sig;
else
    Sig = 0.05;
end
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
    switch Type
        case {'SpikeSpike','SpikeMultiunit','MultiunitMultiunit'}
            Sys = sessTower(Sess);
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            Cl = sessCell(Sess);
            MonkeyDir = sessMonkeyDir(Sess);
            if iscell(Cl{1}); Cl(1) = Cl{1}; end
            if iscell(Cl{2}); Cl(2) = Cl{2}; end
            
            Spike1 = trialSpike(Trials{1}, Sys{1}, Ch(1), Contact(1), Cl(1), Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
            Spike2 = trialSpike(Trials{1}, Sys{2}, Ch(2), Contact(2), Cl(2), Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
            Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
            Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
            numtrials = size(Spike1,1);
            
            Spike1k = tfspproj_pt(Spike1, tapers, sampling_rate, dn, fk, pad);
            Spike2k = tfspproj_pt(Spike2, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Spike1k,2);  nfk = size(Spike1k,4);  K = size(Spike1k,3);
            
            Spike1k = permute(Spike1k, [1,3,2,4]);
            Spike1k = reshape(Spike1k, [numtrials*K, nwin, nfk]);
            Spike2k = permute(Spike2k, [1,3,2,4]);
            Spike2k = reshape(Spike2k, [numtrials*K, nwin, nfk]);
            
            SSpike1 = sq(sum(Spike1k.*conj(Spike1k)));
            SSpike2 = sq(sum(Spike2k.*conj(Spike2k)));
            CrossSpec_S1S2 = sq(sum(Spike1k.*conj(Spike2k)));
            if nwin == 1
                SSpike2 = SSpike2.'; SSpike1 = SSpike1.'; CrossSpec_S1S2 = CrossSpec_S1S2.';
            end
            Coh = CrossSpec_S1S2./sqrt(SSpike2.*SSpike1);
            
            D = Coh.*conj(Coh);
            
            fNum = size(D,2);
            DPerm = zeros(nPerm,fNum);
            pCoh = zeros(nwin,fNum);
            for iWin = 1:nwin
                Spike1kWin = sq(Spike1k(:,iWin,:));
                Spike2kWin = sq(Spike2k(:,iWin,:));
                SSpike1Win = sq(SSpike1(iWin,:));
                SSpike2Win = sq(SSpike2(iWin,:));
                num = sqrt(SSpike1Win.*SSpike2Win);
                Y1k = Spike1kWin;
                for iPerm = 1:nPerm
                    Indices1 = randperm(numtrials*K);
                    X1k = Spike2kWin(Indices1,:);
                    Coh1 = sq(sum(X1k.*conj(Y1k)))./num;
                    DPerm(iPerm,:) = Coh1.*conj(Coh1);
                end
                for iF = 1:size(D,2)
                    pCoh(iWin,iF) = length(find(DPerm(:,iF)>D(iWin,iF)))./nPerm;
                end
            end
            pCoh(pCoh==0) = 1./nPerm;  pCoh(pCoh==1) = (nPerm-1)./nPerm;
            zCoh = sign(D).*norminv(1-pCoh,0,1);
            
        case 'FieldField'
            Sys = sessTower(Sess);
            Sys1 = Sys{1};
            if iscell(Sys1); Sys1 = Sys1{1}; end
            Sys2 = Sys{2};
            if iscell(Sys2); Sys2 = Sys2{1}; end
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            MonkeyDir = sessMonkeyDir(Sess);
            
            Lfp1 = trialLfp(Trials{1}, Sys1, Ch(1), Contact(1), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            Lfp2 = trialLfp(Trials{1}, Sys2, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            if sum(sum(isnan([Lfp1,Lfp2])))
                ind = find(~isnan(Lfp1(:,1)) & ~isnan(Lfp2(:,1)));
                Lfp1 = Lfp1(ind,:);  Lfp2 = Lfp2(ind,:);
            end
            thresh1 = 6*std(Lfp1(:)); e1 = max(abs(Lfp1'));
            thresh2 = 6*std(Lfp2(:)); e2 = max(abs(Lfp2'));
            ind = find(e1<thresh1 & e2<thresh2);
            numtrials = length(ind);
            Lfp1 = Lfp1(ind,:);  Lfp2 = Lfp2(ind,:);
            
            Lfp1k = tfsp_proj(Lfp1, tapers, sampling_rate, dn, fk, pad);
            Lfp2k = tfsp_proj(Lfp2, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfp1k,2);  nfk = size(Lfp1k,4);  K = size(Lfp1k,3);
            Lfp1k = permute(Lfp1k, [1,3,2,4]);
            Lfp1k = reshape(Lfp1k, [numtrials*K, nwin, nfk]);
            Lfp2k = permute(Lfp2k, [1,3,2,4]);
            Lfp2k = reshape(Lfp2k, [numtrials*K, nwin, nfk]);
            
            SLfp1 = sq(sum(Lfp1k.*conj(Lfp1k)));
            SLfp2 = sq(sum(Lfp2k.*conj(Lfp2k)));
            CrossSpec = sq(sum(Lfp1k.*conj(Lfp2k)));
            if nwin == 1
                SLfp1 = SLfp1.'; SLfp2 = SLfp2.'; CrossSpec = CrossSpec.';
            end
            Coh = CrossSpec./sqrt(SLfp1.*SLfp2);
            
            % Updated January 24, 2012 to match other Coherence calculations - HD
            %             if matlabpool('size')
            %                 [Coh,f] = ...
            %                     ptfcoh(Lfp1,Lfp2,tapers,sampling_rate,dn,fk,pad,0.05,11);
            %             else
            %                 [Coh,f] = tfcoh(Lfp1, Lfp2,tapers,sampling_rate,...
            %                     dn,fk,pad,0.05,11);
            %             end
            %             dof = 2*numtrials*floor(2*N*W-1);
            %             zCoh = abs(Coh).*sqrt(dof/2);
            %
            %             %at some point, do this like MF or SF
            %             pCoh = ones(size(zCoh));
            
            D = Coh.*conj(Coh);
            
            fNum = size(D,2);
            DPerm = zeros(nPerm,fNum);
            pCoh = zeros(nwin,fNum);
            for iWin = 1:nwin
                Lfp1kWin = sq(Lfp1k(:,iWin,:));
                Lfp2kWin = sq(Lfp2k(:,iWin,:));
                SLfp1Win = sq(SLfp1(iWin,:));
                SLfp2Win = sq(SLfp2(iWin,:));
                num = sqrt(SLfp1Win.*SLfp2Win);
                Y1k = Lfp1kWin;
                for iPerm = 1:nPerm
                    Indices1 = randperm(numtrials*K);
                    X1k = Lfp2kWin(Indices1,:);
                    Coh1 = sq(sum(X1k.*conj(Y1k)))./num;
                    DPerm(iPerm,:) = Coh1.*conj(Coh1);
                end
                for iF = 1:size(D,2)
                    pCoh(iWin,iF) = length(find(DPerm(:,iF)>D(iWin,iF)))./nPerm;
                end
            end
            pCoh(pCoh==0) = 1./nPerm;  pCoh(pCoh==1) = (nPerm-1)./nPerm;
            zCoh = sign(D).*norminv(1-pCoh,0,1);
            
            
        case {'SpikeField','MultiunitField'}
            
            Sys = sessTower(Sess);
            Sys1 = Sys{1};
            if iscell(Sys1); Sys1 = Sys1{1}; end
            Sys2 = Sys{2};
            if iscell(Sys2); Sys2 = Sys2{1}; end
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
%             Cl = sessCell(Sess);
%             if iscell(Cl{1}); Cl(1) = Cl{1}; end
            Cl = sessCell(Sess);
%             if ~iscell(Sess{5})
%                 Cl = Sess{5}(1);
%             elseif iscell(Sess{5})
%                 Cl = Sess{5}{1}(1);
%             end
            MonkeyDir = sessMonkeyDir(Sess);
            
            Spike = trialSpike(Trials{1}, Sys1, Ch(1), Contact(1), Cl(1), Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
            Lfp = trialLfp(Trials{1}, Sys2, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
            thresh = 6*std(Lfp(:)); e = max(abs(Lfp'));
            ind = find(e<thresh);
            numtrials = length(ind);
            Lfp = Lfp(ind,:);  Spike = Spike(ind,:);
            
            Lfpk = tfsp_proj(Lfp, tapers, sampling_rate, dn, fk, pad);
            Spikek = tfspproj_pt(Spike, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfpk,2);  nfk = size(Lfpk,4);  K = size(Lfpk,3);
            Lfpk = permute(Lfpk, [1,3,2,4]);
            Lfpk = reshape(Lfpk, [numtrials*K, nwin, nfk]);
            Spikek = permute(Spikek, [1,3,2,4]);
            Spikek = reshape(Spikek, [numtrials*K, nwin, nfk]);
            SLfp = sq(sum(Lfpk.*conj(Lfpk)));
            SSpike = sq(sum(Spikek.*conj(Spikek)));
            CrossSpec = sq(sum(Lfpk.*conj(Spikek)));
            if nwin == 1
                SLfp = SLfp.'; SSpike = SSpike.'; CrossSpec = CrossSpec.';
            end
            Coh = CrossSpec./sqrt(SLfp.*SSpike);
            
            D = atanh(abs(Coh));
            
            fNum = size(D,2);
            DPerm = zeros(nPerm,nwin,fNum);
            pCoh = zeros(nwin,fNum);
            for iPerm = 1:nPerm
                if(mod(iPerm,10) == 0)
                    disp(['Permutation ' num2str(iPerm) ' of ' num2str(nPerm)])
                end
                for iWin = 1:nwin
                    LfpkWin = sq(Lfpk(:,iWin,:));
                    SpikekWin = sq(Spikek(:,iWin,:));
                    SLfpWin = sq(SLfp(iWin,:));
                    SSpikeWin = sq(SSpike(iWin,:));
                    num = sqrt(SLfpWin.*SSpikeWin);
                    Y1k = SpikekWin;
                    
                    Indices1 = randperm(numtrials*K);
                    X1k = LfpkWin(Indices1,:);
                    Coh1 = sq(sum(X1k.*conj(Y1k)))./num;
                    DPerm(iPerm,iWin,:) = atanh(abs(Coh1));
                end
            end
            
            for iPerm = 1:nPerm
                if(mod(iPerm,10) == 0)
                    disp(['Permutation ' num2str(iPerm) ' of ' num2str(nPerm)])
                end
                tmpD = sq(DPerm(iPerm,:,:));
                for iWin = 1:nwin
                    for iF = 1:size(tmpD,2)
                        tmppCoh(iWin,iF) = length(find(DPerm(:,iWin,iF)>tmpD(iWin,iF)))./nPerm;
                    end
                end
                
                tmppCoh(tmppCoh==0) = 1./nPerm;  tmppCoh(tmppCoh==1) = (nPerm-1)./nPerm;
                for itmp =1:size(tmppCoh,1)
                    tmppCoh(itmp,tmppCoh(itmp,:) < (1-Sig)) = 0;
                    tmppCoh(itmp,tmppCoh(itmp,:) >= (1-Sig)) = 1;
                end
                [L,n] = bwlabel(tmppCoh);
                bins = hist(reshape(L,size(L,1)*size(L,2),1),n+1);
                if(length(bins) > 1)
                    cluster(iPerm) = max(bins(2:end));
                else
                    cluster(iPerm) = 0;
                end
            end
            for iWin = 1:nwin
                for iF = 1:size(D,2)
                    pCoh(iWin,iF) = length(find(DPerm(:,iWin,iF)>D(iWin,iF)))./nPerm;
                end
            end
            pCoh(pCoh==0) = 1./nPerm;  pCoh(pCoh==1) = (nPerm-1)./nPerm;
            zCoh = sign(D).*norminv(1-pCoh,0,1);
            
            
        case {'MultiunitFieldField','SpikeFieldField'}
            Sys = sessTower(Sess);
            Sys1 = Sys{1};
            if iscell(Sys1); Sys1 = Sys1{1}; end
            Sys2 = Sys{2};
            if iscell(Sys2); Sys2 = Sys2{1}; end
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            Cl = sessCell(Sess);
            if iscell(Cl{1}); Cl(1) = Cl{1}; end
            MonkeyDir = sessMonkeyDir(Sess);
            
            Spike = trialSpike(Trials{1}, Sys1, Ch(1), Contact(1), Cl(1), Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
            Lfp1 = trialLfp(Trials{1}, Sys2, Ch(2), Contact(2), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            Lfp2 = trialLfp(Trials{1}, Sys{3}, Ch(3), Contact(3), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            if sum(sum(isnan([Lfp1,Lfp2])))
                ind = find(~isnan(Lfp1(:,1)) & ~isnan(Lfp2(:,1)));
                Lfp1 = Lfp1(ind,:);  Lfp2 = Lfp2(ind,:); Spike = Spike(ind);
            end
            Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
            thresh1 = 6*std(Lfp1(:)); e1 = max(abs(Lfp1'));
            thresh2 = 6*std(Lfp1(:)); e2 = max(abs(Lfp1'));
            ind = find(e1<thresh1 & e2<thresh2);
            numtrials = length(ind);
            Lfp1 = Lfp1(ind,:);  Lfp2 = Lfp2(ind,:); Spike = Spike(ind,:);
            
            %Calculate windowed FFTs
            Lfp1k = tfsp_proj(Lfp1, tapers, sampling_rate, dn, fk, pad);
            Lfp2k = tfsp_proj(Lfp2, tapers, sampling_rate, dn, fk, pad);
            Spikek = tfspproj_pt(Spike, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfp1k,2);  nfk = size(Lfp1k,4);  K = size(Lfp1k,3);
            Lfp1k = permute(Lfp1k, [1,3,2,4]);
            Lfp1k = reshape(Lfp1k, [numtrials*K, nwin, nfk]);
            Lfp2k = permute(Lfp2k, [1,3,2,4]);
            Lfp2k = reshape(Lfp2k, [numtrials*K, nwin, nfk]);
            Spikek = permute(Spikek, [1,3,2,4]);
            Spikek = reshape(Spikek, [numtrials*K, nwin, nfk]);
            SLfp1 = sq(sum(Lfp1k.*conj(Lfp1k)));
            SLfp2 = sq(sum(Lfp2k.*conj(Lfp2k)));
            SSpike = sq(sum(Spikek.*conj(Spikek)));
            CrossSpec_L1S = sq(sum(Lfp1k.*conj(Spikek)));
            CrossSpec_L2S = sq(sum(Lfp2k.*conj(Spikek)));
            CrossSpec_L1L2 = sq(sum(Lfp1k.*conj(Lfp2k)));
            if nwin == 1
                SLfp1 = SLfp1.'; SLfp2 = SLfp2.'; SSpike = SSpike.';
                CrossSpec_L1S = CrossSpec_L1S.';
                CrossSpec_L2S = CrossSpec_L2S.';
                CrossSpec_L1L2 = CrossSpec_L1L2.';
            end
            Coh_L1S = CrossSpec_L1S./sqrt(SLfp1.*SSpike);
            Coh_L2S = CrossSpec_L2S./sqrt(SLfp2.*SSpike);
            Coh_L1L2 = CrossSpec_L1L2./sqrt(SLfp1.*SLfp2);
            
            Coh{1} = Coh_L1S;
            Coh{2} = Coh_L2S;
            Coh{3} = Coh_L1L2;
            
            %Compute p values
            D_Coh_L1S = magsq_Coh_L1S;
            D_Coh_L2S = magsq_Coh_L2S;
            D_Coh_L1L2 = magsq_Coh_L1L2;
            
            fNum = size(D_Coh_L1S,2);
            D_Coh_L1S_Perm = zeros(nPerm,fNum);
            D_Coh_L2S_Perm = D_Coh_L1S_Perm;
            D_Coh_L1L2_Perm = D_Coh_L1S_Perm;
            pCoh_L1S_tmp = zeros(nwin,fNum);
            pCoh_L2S_tmp = pCoh_L1S_tmp;
            pCoh_L1L2_tmp = pCoh_L1S_tmp;
            for iWin = 1:nwin
                SpikekWin = sq(Spikek(:,iWin,:));
                Lfp1kWin = sq(Lfp1k(:,iWin,:));
                Lfp2kWin = sq(Lfp2k(:,iWin,:));
                SSpikeWin = sq(SSpike(iWin,:));
                SLfp1Win = sq(SLfp1(iWin,:));
                SLfp2Win = sq(SLfp2(iWin,:));
                num_L1S = sqrt(SLfp1Win.*SSpikeWin);
                num_L2S = sqrt(SLfp2Win.*SSpikeWin);
                num_L1L2 = sqrt(SLfp1Win.*SLfp2Win);
                Y1k = SpikekWin;
                for iPerm = 1:nPerm
                    Indices1 = randperm(numtrials*K);
                    Indices2 = randperm(numtrials*K);
                    X1k = Lfp1kWin(Indices1,:);
                    X2k = Lfp2kWin(Indices2,:);
                    
                    Coh_L1S = sq(sum(X1k.*conj(Y1k)))./num_L1S;
                    Coh_L2S = sq(sum(X2k.*conj(Y1k)))./num_L2S;
                    Coh_L1L2 = sq(sum(X1k.*conj(X2k)))./num_L1L2;
                    Coh_SL2 = conj(Coh_L2S);
                    Coh_L2L1 = conj(Coh_L1L2);
                    
                    % compute p values for Coh
                    D_Coh_L1S_Perm(iPerm,:) = Coh_L1S.*conj(Coh_L1S);
                    D_Coh_L2S_Perm(iPerm,:) = Coh_L2S.*Coh_SL2;
                    D_Coh_L1L2_Perm(iPerm,:) = Coh_L1L2.*Coh_L2L1;
                end
                for iF = 1:fNum
                    pCoh_L1S_tmp(iWin,iF) = length(find(D_Coh_L1S_Perm(:,iF)>D_Coh_L1S(iWin,iF)))./nPerm;
                    pCoh_L2S_tmp(iWin,iF) = length(find(D_Coh_L2S_Perm(:,iF)>D_Coh_L2S(iWin,iF)))./nPerm;
                    pCoh_L1L2_tmp(iWin,iF) = length(find(D_Coh_L1L2_Perm(:,iF)>D_Coh_L1L2(iWin,iF)))./nPerm;
                end
            end
            pCoh_L1S(pCoh_L1S_tmp==0) = 1./nPerm;  pCoh_L1S(pCoh_L1S_tmp==1) = (nPerm-1)./nPerm;
            pCoh_L2S(pCoh_L2S_tmp==0) = 1./nPerm;  pCoh_L2S(pCoh_L2S_tmp==1) = (nPerm-1)./nPerm;
            pCoh_L1L2(pCoh_L1L2_tmp==0) = 1./nPerm;  pCoh_L1L2(pCoh_L1L2_tmp==1) = (nPerm-1)./nPerm;
            
            pCoh{1} = pCoh_L1S;
            pCoh{2} = pCoh_L2S;
            pCoh{3} = pCoh_L1L2;
            
            
        case {'SpikeSpikeField','SpikeMultiunitField','MultiunitMultiunitField'}
            Sys = sessTower(Sess);
            Sys1 = Sys{1};
            if iscell(Sys1); Sys1 = Sys1{1}; end
            Sys2 = Sys{2};
            if iscell(Sys2); Sys2 = Sys2{1}; end
            Ch = sessElectrode(Sess);
            Contact = sessContact(Sess);
            Cl = sessCell(Sess);
            if iscell(Cl{1}); Cl(1) = Cl{1}; end
            if iscell(Cl{2}); Cl(2) = Cl{2}; end
            MonkeyDir = sessMonkeyDir(Sess);
            
            Spike1 = trialSpike(Trials{1}, Sys1, Ch(1), Contact(1), Cl(1), Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
            Spike2 = trialSpike(Trials{1}, Sys2, Ch(2), Contact(2), Cl(2), Field, ...
                [bn(1)-N/2*1e3,bn(2)+N/2*1e3], MonkeyDir);
            Lfp = trialLfp(Trials{1}, Sys{3}, Ch(3),Contact(3), Field, ...
                [bn(1)-N./2*1e3,bn(2)+N./2*1e3], MonkeyDir);
            if sum(sum(isnan([Lfp])))
                ind = find(~isnan(Lfp(:,1)));
                Lfp = Lfp(ind,:); Spike1 = Spike1(ind); Spike2 = Spike2(ind);
            end
            Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
            Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
            thresh1 = 6*std(Lfp(:)); e1 = max(abs(Lfp'));
            ind = find(e1<thresh1);
            numtrials = length(ind);
            Lfp = Lfp(ind,:); Spike1 = Spike1(ind,:); Spike2 = Spike2(ind,:);
            
            %Calculate windowed FFTs
            Lfpk = tfsp_proj(Lfp, tapers, sampling_rate, dn, fk, pad);
            Spike1k = tfspproj_pt(Spike1, tapers, sampling_rate, dn, fk, pad);
            Spike2k = tfspproj_pt(Spike2, tapers, sampling_rate, dn, fk, pad);
            nwin = size(Lfpk,2);  nfk = size(Lfpk,4);  K = size(Lfpk,3);
            Lfpk = permute(Lfpk, [1,3,2,4]);
            Lfpk = reshape(Lfpk, [numtrials*K, nwin, nfk]);
            Spike1k = permute(Spike1k, [1,3,2,4]);
            Spike1k = reshape(Spike1k, [numtrials*K, nwin, nfk]);
            Spike2k = permute(Spike2k, [1,3,2,4]);
            Spike2k = reshape(Spike2k, [numtrials*K, nwin, nfk]);
            SLfp = sq(sum(Lfpk.*conj(Lfpk)));
            SSpike1 = sq(sum(Spike1k.*conj(Spike1k)));
            SSpike2 = sq(sum(Spike2k.*conj(Spike2k)));
            
            CrossSpec_S2S1 = sq(sum(Spike2k.*conj(Spike1k)));
            CrossSpec_LS1 = sq(sum(Lfpk.*conj(Spike1k)));
            CrossSpec_S2L = sq(sum(Spike2k.*conj(Lfpk)));
            
            if nwin == 1
                SSpike2 = SSpike2.'; SLfp = SLfp.'; SSpike1 = SSpike1.';
                CrossSpec_S2S1 = CrossSpec_S2S1.';
                CrossSpec_LS1 = CrossSpec_LS1.';
                CrossSpec_S2L = CrossSpec_S2L.';
            end
            Coh_S2S1 = CrossSpec_S2S1./sqrt(SSpike2.*SSpike1);
            Coh_LS1 = CrossSpec_LS1./sqrt(SLfp.*SSpike1);
            Coh_S2L = CrossSpec_S2L./sqrt(SSpike2.*SLfp);
            Coh_LS2 = conj(Coh_S2L);
            Coh_S1L = conj(Coh_LS1);
            
            Coh{1} = Coh_S2S1;
            Coh{2} = Coh_LS1;
            Coh{3} = Coh_S2L;
            
            %Work on partial Coh here
            magsq_Coh_S2S1 = Coh_S2S1.*conj(Coh_S2S1);
            magsq_Coh_LS1 = Coh_LS1.*Coh_S1L;
            magsq_Coh_S2L = Coh_S2L.*Coh_LS2;
            
            %Compute p values
            D_Coh_S2S1 = magsq_Coh_S2S1;
            D_Coh_LS1 = magsq_Coh_LS1;
            D_Coh_S2L = magsq_Coh_S2L;
            
            fNum = size(D_Coh_S2S1,2);
            D_Coh_S2S1_Perm = zeros(nPerm,fNum);
            D_Coh_LS1_Perm = D_Coh_S2S1_Perm;
            D_Coh_S2L_Perm = D_Coh_S2S1_Perm;
            pCoh_S2S1_tmp = zeros(nwin,fNum);
            pCoh_LS1_tmp = pCoh_S2S1_tmp;
            pCoh_S2L_tmp = pCoh_S2S1_tmp;
            for iWin = 1:nwin
                Spike1kWin = sq(Spike1k(:,iWin,:));
                Spike2kWin = sq(Spike2k(:,iWin,:));
                LfpkWin = sq(Lfpk(:,iWin,:));
                SSpike1Win = sq(SSpike1(iWin,:));
                SSpike2Win = sq(SSpike2(iWin,:));
                SLfpWin = sq(SLfp(iWin,:));
                num_S2S1 = sqrt(SSpike2Win.*SSpike1Win);
                num_LS1 = sqrt(SLfpWin.*SSpike1Win);
                num_S2L = sqrt(SSpike2Win.*SLfpWin);
                Y1k = Spike1kWin;
                for iPerm = 1:nPerm
                    Indices1 = randperm(numtrials*K);
                    Indices2 = randperm(numtrials*K);
                    X1k = Spike2kWin(Indices1,:);
                    X2k = LfpkWin(Indices2,:);
                    
                    Coh_S2S1 = sq(sum(X1k.*conj(Y1k)))./num_S2S1;
                    Coh_LS1 = sq(sum(X2k.*conj(Y1k)))./num_LS1;
                    Coh_S2L = sq(sum(X1k.*conj(X2k)))./num_S2L;
                    Coh_S1L = conj(Coh_LS1);
                    Coh_LS2 = conj(Coh_S2L);
                    magsq_Coh_S2S1 = Coh_S2S1.*conj(Coh_S2S1);
                    magsq_Coh_LS1 = Coh_LS1.*conj(Coh_S1L);
                    magsq_Coh_S2L = Coh_S2L.*conj(Coh_LS2);
                    
                    % compute p values for Coh
                    D_Coh_S2S1_Perm(iPerm,:) = magsq_Coh_S2S1;
                    D_Coh_LS1_Perm(iPerm,:) = magsq_Coh_LS1;
                    D_Coh_S2L_Perm(iPerm,:) = magsq_Coh_S2L;
                end
                for iF = 1:fNum
                    pCoh_S2S1_tmp(iWin,iF) = length(find(D_Coh_S2S1_Perm(:,iF)>D_Coh_S2S1(iWin,iF)))./nPerm;
                    pCoh_LS1_tmp(iWin,iF) = length(find(D_Coh_LS1_Perm(:,iF)>D_Coh_LS1(iWin,iF)))./nPerm;
                    pCoh_S2L_tmp(iWin,iF) = length(find(D_Coh_S2L_Perm(:,iF)>D_Coh_S2L(iWin,iF)))./nPerm;
                end
            end
            pCoh_S2S1_tmp(pCoh_S2S1_tmp==0) = 1./nPerm;  pCoh_S2S1_tmp(pCoh_S2S1_tmp==1) = (nPerm-1)./nPerm;
            pCoh_LS1_tmp(pCoh_LS1_tmp==0) = 1./nPerm;  pCoh_LS1_tmp(pCoh_LS1_tmp==1) = (nPerm-1)./nPerm;
            pCoh_S2L_tmp(pCoh_S2L_tmp==0) = 1./nPerm;  pCoh_S2L_tmp(pCoh_S2L_tmp==1) = (nPerm-1)./nPerm;
            
            pCoh_S2S1 = pCoh_S2S1_tmp;
            pCoh_LS1 = pCoh_LS1_tmp;
            pCoh_S2L = pCoh_S2L_tmp;
            
            pCoh{1} = pCoh_S2S1;
            pCoh{2} = pCoh_LS1;
            pCoh{3} = pCoh_S2L;
            
    end
else
    disp('Not enough trials');
    nf = max(256, pad*2^nextpow2(N*sampling_rate+1));
    nfk = floor(fk./sampling_rate.*nf);
    t = bn(1):dn*1e3:bn(2);
    f = linspace(fk(1),fk(2),diff(nfk));
    numtrials = 0;
    zCoh = zeros(length(t)-1,diff(nfk),'single');
    pCoh = zeros(length(t)-1,diff(nfk),'single');
    Coh = zeros(length(t)-1,diff(nfk),'single');
    
end

nf = max(256,pad*2^nextpow2(N*sampling_rate+1));
nfk = floor(fk./sampling_rate.*nf);
f = linspace(fk(1),fk(2),diff(nfk));
t = bn(1):dn*1e3:bn(2);
Data.t = t;
Data.NumTrials = numtrials;
Data.Data = zCoh;
Data.SuppData.pCoh = pCoh;
Data.SuppData.Coh = Coh;
Data.f = f;

%  Restore Session to smaller, Day format removing Trials data structure
%  from first cell element
DataSession = Sess;
DataSession{1} = Trials{1}(1).Day;
Data.Session = DataSession;
Data.clusterSize = cluster;

Data.xax = t;
Data.yax = f;
