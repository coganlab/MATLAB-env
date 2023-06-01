function [p,D,PD] = sessTestDecimatedCohNull(Sess,CondParams,AnalParams)
%;Task,Field,bn,conds,tapers,dn,delay)
%
%   [p,D,PD] = sessTestCohNull(Sess,CondParams,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS =   Data structure.  Parameter information for condition
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time. NOTE: Not an interval, a scalar.
%   CondParams.cond    =   Eye,Hand,Target conds {[],[],[]}
%
%	Note: CondParams is parsed by Params2Trials - check that function for reference
%   AnalParams.Tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test.
%                               Test statistic integrates over this band.
%   AnalParams.nPerm   = Scalar.  Number of permutations to generate for null distribution.
%				Defaults to 1e4
%   AnalParams.p       =   probability of spike deletion. 
%                          Default = 0 (same as sessPanelNullzScoreCoherogram.m)
%
%   Outputs:  P	 = p-Value
%		D = Test statistic
%	        PD = Null-distribution of test statistic 
%
%       Notes:  This performs a permutation test with 1e4 permutations

if(isfield(AnalParams,'p'))
    p_delete = AnalParams.p;
else
    p_delete = 0;
end

if isstruct(Sess{1})
    Trials = Sess{1};
else
    Trials = sessTrials(Sess);
end

Trials = Params2Trials(Trials,CondParams);
Type = getSessionType(Sess);
MonkeyDir = sessMonkeyDir(Sess);

disp('Calculating coherence statistics')
sampling = 1e3;
N = AnalParams.Tapers(1); 
if length(AnalParams.Tapers)==3
  W = AnalParams.Tapers(2)./AnalParams.Tapers(1);
else
  W = AnalParams.Tapers(2);
end
p = N*W;
k = floor(2*p-1);
tapers = [N,p,k];
tapers(1) = floor(tapers(1).*sampling);  
tapers = mydpsschk(tapers); 
K = length(tapers(1,:));
n = length(tapers(:,1));
pad = 2;
nf = max(256,pad*2.^(nextpow2(n+1)));
fk = AnalParams.fk;                     %frequencies to keep
nfk = floor(fk./sampling.*nf);          %n frequencies to keep
ntr = length(Trials);
ntapers = tapers.*sqrt(sampling);
H = fft(ntapers(:,1:K),nf)';

if isfield(AnalParams,'nPerm')
    nPerm = AnalParams.nPerm;
else
    nPerm = 1e4;
end

switch Type
    case 'SpikeField'
        Sys = sessTower(Sess);
        Ch = sessElectrode(Sess);
        Contact = sessContact(Sess);
        if ~iscell(Sess{5})
            Cl = Sess{5}(1);
        elseif iscell(Sess{5})
            Cl = Sess{5}{1}(1);
        end
        dN = trialSpike(Trials, Sys{1}, Ch(1), Contact(1), Cl, CondParams.Field, ... %X1 spike session - conditions 1
            [CondParams.bn-N./2*1e3,CondParams.bn+N./2*1e3], MonkeyDir);
        
        for iTr = 1:length(dN)
            cutProb = rand(size(dN{iTr}));
            newSpikeind = cutProb > p_delete;
            dN{iTr} = dN{iTr}(newSpikeind);
        end
        % dN = psth(dN,[CondParams.bn-N./2*1e3,CondParams.bn+N./2*1e3],AnalParams.Smoothing);
        
        dN = sp2ts(dN,[0,N-1/1e3,1e3]);
        Y = trialLfp(Trials, Sys{2}, Ch(2), Contact(2), CondParams.Field, ...
            [CondParams.bn-N./2*1e3,CondParams.bn+N./2*1e3], MonkeyDir);             %Y1 field session - conditions 1
        meanY = sum(Y)./ntr;
        dNk = zeros(ntr*K, diff(nfk));
        Yk = zeros(ntr*K, diff(nfk));
        for tr=1:ntr
            tmp = dN(tr,:)';
            dNk_tmp = fft(ntapers(:,1:K).*tmp(:,ones(1,K)),nf)'- mean(tmp).*H;
            dNk((tr-1)*K+1:tr*K,:) = dNk_tmp(:,nfk(1)+1:nfk(2));
            tmp = (Y(tr,:) - meanY).';
            yk = fft(tapers(:,1:K).*tmp(:,ones(1,K)),nf)';
            Yk((tr-1)*K+1:tr*K,:) = yk(:,nfk(1)+1:nfk(2));
        end
        S_dN = sum(dNk.*conj(dNk)); S_Y = sum(Yk.*conj(Yk));
        coh = sum(dNk.*conj(Yk))./sqrt(S_dN.*S_Y);  %def'n of coherence
        D = sum(abs(coh))./(nfk(2)-nfk(1));
        GdN = [dNk]; GY = [Yk];  PD = zeros(1,nPerm);
        parfor iPerm = 1:nPerm
            NP = randperm(size(GdN,1));
            Pcoh = sum(GdN(NP,:).*conj(GY(:,:)))./sqrt(S_dN.*S_Y);
            PD(iPerm) = sum(abs(Pcoh))./(nfk(2)-nfk(1));
        end
        p = length(find(abs(PD)>abs(D)))./nPerm;
        
%         
%         Lfp = trialMlfp(Trials{iTaskComp}, Sys(2), Ch(2), Field, ...
%             [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
%         Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
%         [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
%             tfcoh_ptx(Lfp,Spike,[N,W],1e3,dn,300,2,0.05,11);
%     case 'SpikeFieldField'
%         Sys = Sess{3};
%         Ch = Sess{4};
%         Cl = Sess{5}(1);
%         Spike = SpikeTrial(Trials, Sys(1), Ch(1), Cl, Field, ...
%             [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
%         Lfp1 = trialMlfp(Trials, Sys(2), Ch(2), Field, ...
%             [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
%         Lfp2 = trialMlfp(Trials, Sys(3), Ch(3), Field, ...
%             [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
%         Lfp = Lfp1-Lfp2; clear Lfp1 Lfp2
%         Spike = sp2ts(Spike,[0,diff(bn)./1e3+N,1e3]);
%         [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp}] = ...
%             tfcoh_ptx(Lfp,Spike,[N,W],1e3,dn,300,2,0.05,11);
%     case 'FieldFieldField'
%         Sys = Sess{3};
%         Ch = Sess{4};
%         tic
%         Lfp1 = trialMlfp(Trials, Sys(1), Ch(1), Field, ...
%             [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
%         Lfp2 = trialMlfp(Trials, Sys(2), Ch(2), Field, ...
%             [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
%         Lfp3 = trialMlfp(Trials, Sys(3), Ch(3), Field, ...
%             [bn(1)-N./2*1e3,bn(2)+N./2*1e3]);
%         Lfp = Lfp2-Lfp3; clear Lfp2 Lfp3
%         [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp}] = ...
%             tfcoh(Lfp1,Lfp,[N,W],1e3,dn,300,2,0.05,11); toc
    case 'SpikeSpike'
        disp('SpikeSpike')
        Sys = Sess{3};
        Ch = sessElectrode(Sess);
        Contact = sessContact(Sess);
        Cl = sessCell(Sess);
        dN1 = trialSpike(Trials, Sys(1), Ch(1), Contact(1), Cl(1), CondParams.Field, ...
            [CondParams.bn-N./2*1e3,CondParams.bn+N./2*1e3],MonkeyDir);             %X1 spike session - conditions 1
        dN1 = sp2ts(dN1,[0,N-1/1e3,1e3]);
        dM1 = trialSpike(Trials, Sys(2), Ch(2), Contact(2), Cl(2), CondParams.Field, ...
            [CondParams.bn-N./2*1e3,CondParams.bn+N./2*1e3],MonkeyDir);             %X1 spike session - conditions 1
        dM1 = sp2ts(dM1,[0,N-1/1e3,1e3]);
       
        dN2 = dN1(randperm(length(Trials)),:);
        dM2 = dM1(randperm(length(Trials)),:);
        
        dNk1 = zeros(ntr*K, diff(nfk));
        dMk1 = zeros(ntr*K, diff(nfk));
        
        for tr=1:ntr
            tmp1 = dN1(tr,:)';
            dNk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'- mean(tmp1).*H;
            dNk1((tr-1)*K+1:tr*K,:) = dNk(:,nfk(1)+1:nfk(2));
            S_dN1(tr,:) = mean(abs(dNk1).^2);
            tmp1 = dM1(tr,:)';
            dMk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'- mean(tmp1).*H;
            dMk1((tr-1)*K+1:tr*K,:) = dMk(:,nfk(1)+1:nfk(2));
            S_dM1(tr,:) = mean(abs(dMk1).^2);
        end
        dNk2 = zeros(ntr*K, diff(nfk));
        dMk2 = zeros(ntr*K, diff(nfk));
        for tr=1:ntr
            tmp1 = dN2(tr,:)';
            dNk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'- mean(tmp1).*H;
            dNk2((tr-1)*K+1:tr*K,:) = dNk(:,nfk(1)+1:nfk(2));
            S_dN2(tr,:) = mean(abs(dNk2).^2);
            
            tmp1 = dM2(tr,:)';
            dMk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'- mean(tmp1).*H;
            dMk2((tr-1)*K+1:tr*K,:) = dMk(:,nfk(1)+1:nfk(2));
            S_dM2(tr,:) = mean(abs(dMk2).^2);
        end
        S_dN1 = mean(abs(dNk1).^2); S_dM1 = mean(abs(dMk1).^2);
        coh1 = mean(dNk1.*conj(dMk1))./sqrt(S_dN1.*S_dM1);  %def'n of coherence
        S_dN2 = mean(abs(dNk2).^2); S_dM2 = mean(abs(dMk2).^2);
        coh2 = mean(dNk2.*conj(dMk2))./sqrt(S_dN2.*S_dM2);
        mean(abs(coh1))
        mean(abs(coh2))
        D = mean(abs(coh1))-mean(abs(coh2));
         GdN = [dNk1;dNk2]; GdM = [dMk1;dMk2];

        for iPerm = 1:nPerm
            if(mod(iPerm,100)== 0)
                disp(num2str(iPerm))
            end
            NP = randperm(size(GdN,1));
            N1 = NP(1:size(dNk1,1));
            N2 = NP(size(dNk1,1)+1:end);
            PS_dN1 = mean(abs(GdN(N1,:)).^2); PS_dM1 = mean(abs(GdM(N1,:)).^2);
            Pcoh1 = mean(GdN(N1,:).*conj(GdM(N1,:)))./sqrt(PS_dN1.*PS_dM1);
            PS_dN2 = mean(abs(GdN(N2,:)).^2); PS_dM2 = mean(abs(GdM(N2,:)).^2);
            Pcoh2 = mean(GdN(N2,:).*conj(GdM(N2,:)))./sqrt(PS_dN2.*PS_dM2);
            PD(iPerm) = mean(abs(Pcoh1))-mean(abs(Pcoh2));
        end
        p = length(find(abs(PD)>abs(D)))./nPerm;
        
        
        
%         tic
%         Spike1 = SpikeTrial(Trials{iTaskComp}, Sys(1), Ch(1), Cl{1}, Field, ...
%             [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
%         Spike2 = SpikeTrial(Trials{iTaskComp}, Sys(2), Ch(2), Cl{2}, Field, ...
%             [bn(1)-N/2*1e3,bn(2)+N/2*1e3]);
%         Spike1 = sp2ts(Spike1,[0,diff(bn)./1e3+N,1e3]);
%         Spike2 = sp2ts(Spike2,[0,diff(bn)./1e3+N,1e3]);
%         [Coh{iTaskComp},S1{iTaskComp},S2{iTaskComp},f] = ...
%             tfcoh_pt(Spike1,Spike2,[N,W],1e3,dn,300,2,0.05,11); toc
end

