function [p,D,PD] = sessTestCohDiff(Sess,CondParams1,CondParams2,AnalParams)
%;Task,Field,bn,conds,tapers,dn,delay)
%
%   [p,D,PD] = sessTestCohDiff(Sess,CondParams1,CondParams2,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS1 =   Data structure.  Parameter information for 1st condition
%   CONDPARAMS2 =   Data structure.  Parameter information for 2nd condition
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%   CondParams.cond    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.Delay   =  Vector. Select trials according to delay interval (s).
%                    Delay = [DelayStart,DelayStop].
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
%   AnalParams.fk      =   Vector.  Select frequency band to test.
%                               Test statistic integrates over this band.
%
%   Outputs:  P	 = p-Value
%		D = Test statistic
%	        PD = Null-distribution of test statistic 
%
%       Notes:  This performs a permutation test with 5000 permutations

if isstruct(Sess{1})
    Trials = Sess{1};
else
    Trials = sessTrials(Sess);
end

Trials1 = Params2Trials(Trials,CondParams1);
Trials2 = Params2Trials(Trials,CondParams2);

if length(Sess{5}) == 2
    if ~iscell(Sess{5})
        if Sess{5}(1) > 15 || Sess{5}(1)<0
            Type = 'FieldField';
        elseif Sess{5}(2) > 15
            Type = 'SpikeField';
        else
            Type = 'SpikeSpike';
        end
    elseif iscell(Sess{5})
        if Sess{5}{1}(1) > 15 || Sess{5}{1}(1)<0
            Type = 'FieldField';
        elseif Sess{5}{2}(1) > 15
            Type = 'SpikeField';
        else
            Type = 'SpikeSpike';
        end
    end
elseif length(Sess{5}) == 3
    if Sess{5}(1) > 15
        Type = 'FieldFieldField';
    elseif Sess{5}(1) < 15 && Sess{5}(2) > 15 && Sess{5}(3) > 15
        Type = 'SpikeFieldField';
    else
        Type = 'SpikeSpikeSpike';
    end
end

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
ntr1 = length(Trials1);
ntr2 = length(Trials2);
ntapers = tapers.*sqrt(sampling);
H = fft(ntapers(:,1:K),nf)';


    switch Type
    case 'FieldField'
        Sys = sessTower(Sess); Ch = sessElectrode(Sess); 
	Contact = sessContact(Sess);
        X1 = trialLfp(Trials1, Sys(1), Ch(1), Contact(1), CondParams1.Field, ...
            [CondParams1.bn(1)-N./2*1e3,CondParams1.bn(2)+N./2*1e3]);
        Y1 = trialLfp(Trials1, Sys(2), Ch(2), Contact(2), CondParams1.Field, ...
            [CondParams1.bn(1)-N./2*1e3,CondParams1.bn(2)+N./2*1e3]);
        X2 = trialLfp(Trials2, Sys(1), Ch(1), Contact(1), CondParams2.Field, ...
            [CondParams1.bn(1)-N./2*1e3,CondParams1.bn(2)+N./2*1e3]);
        Y2 = trialLfp(Trials2, Sys(2), Ch(2), Contact(2), CondParams2.Field, ...
            [CondParams1.bn(1)-N./2*1e3,CondParams1.bn(2)+N./2*1e3]);
        Xk1 = zeros(ntr1*K, diff(nfk));
        Yk1 = zeros(ntr1*K, diff(nfk));
        meanX1 = sum(X1)./ntr1; meanY1 = sum(Y1)./ntr1;
        for tr=1:ntr1
          tmp1 = (X1(tr,:) - meanX1).';
          xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
          Xk1((tr-1)*K+1:tr*K,:) = xk(:,nfk(1)+1:nfk(2));
          tmp2 = (Y1(tr,:) - meanY1).';
          yk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
          Yk1((tr-1)*K+1:tr*K,:) = yk(:,nfk(1)+1:nfk(2));
        end
        Xk2 = zeros(ntr2*K, diff(nfk));
        Yk2 = zeros(ntr2*K, diff(nfk));
        meanX2 = sum(X2)./ntr2; meanY2 = sum(Y2)./ntr2;
        for tr=1:ntr2
          tmp1 = (X2(tr,:) - meanX2).';
          xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
          Xk2((tr-1)*K+1:tr*K,:) = xk(:,nfk(1)+1:nfk(2));
          tmp2 = (Y2(tr,:) - meanY2).';
          yk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
          Yk2((tr-1)*K+1:tr*K,:) = yk(:,nfk(1)+1:nfk(2));
        end
        S_X1 = sum(abs(Xk1).^2); S_Y1 = sum(abs(Yk1).^2);
        coh1 = sum(Xk1.*conj(Yk1))./sqrt(S_X1.*S_Y1);  %def'n of coherence
        S_X2 = sum(abs(Xk2).^2); S_Y2 = sum(abs(Yk2).^2);
        coh2 = sum(Xk2.*conj(Yk2))./sqrt(S_X2.*S_Y2);
        D = (sum(abs(coh1))-sum(abs(coh2)))./(nfk(2)-nfk(1));
        GX = [Xk1;Xk2]; GY = [Yk1;Yk2]; PD = zeros(1,5e3);
        for iPerm = 1:5e3
          NP = randperm(size(GX,1));
          N1 = NP(1:size(Xk1,1));
          N2 = NP(size(Xk1,1)+1:end);
          %PS_X1 = sum(abs(GX(N1,:)).^2); PS_Y1 = sum(abs(GY(N1,:)).^2);
          PS_X1 = sum(GX(N1,:).*conj(GX(N1,:))); PS_Y1 = sum(GY(N1,:).*conj(GY(N1,:)));
          Pcoh1 = sum(GX(N1,:).*conj(GY(N1,:)))./sqrt(PS_X1.*PS_Y1);
          %PS_X2 = sum(abs(GX(N2,:)).^2); PS_Y2 = sum(abs(GY(N2,:)).^2);
          PS_X2 = sum(GX(N2,:).*conj(GX(N2,:))); PS_Y2 = sum(GY(N2,:).*conj(GY(N2,:)));
          Pcoh2 = sum(GX(N2,:).*conj(GY(N2,:)))./sqrt(PS_X2.*PS_Y2);
          PD(iPerm) = (sum(abs(Pcoh1))-sum(abs(Pcoh2)))./(nfk(2)-nfk(1));
        end
        p = length(find(abs(PD)>abs(D)))./5e3;


    case 'SpikeField'
        Sys = sessTower(Sess);
        Ch = sessElectrode(Sess);
	Contact = sessContact(Sess);
        if ~iscell(Sess{5})
            Cl = Sess{5}(1);
        elseif iscell(Sess{5})
            Cl = Sess{5}{1}(1);
        end
        dN1 = trialSpike(Trials1, Sys(1), Ch(1), Contact(1), Cl, CondParams1.Field, ...
            [CondParams1.bn-N./2*1e3,CondParams1.bn+N./2*1e3]);             %X1 spike session - conditions 1
        dN1 = sp2ts(dN1,[0,N-1/1e3,1e3]);
        Y1 = trialLfp(Trials1, Sys(2), Ch(2), Contact(2), CondParams1.Field, ...
            [CondParams1.bn-N./2*1e3,CondParams1.bn+N./2*1e3]);             %Y1 field session - conditions 1
        dN2 = trialSpike(Trials2, Sys(1), Ch(1), Contact(1), Cl, CondParams2.Field, ...
            [CondParams1.bn-N./2*1e3,CondParams1.bn+N./2*1e3]);             %X2 spike session - conditions 2
        dN2 = sp2ts(dN2,[0,N-1/1e3,1e3]);
        Y2 = trialLfp(Trials2, Sys(2), Ch(2), Contact(2), CondParams2.Field, ...
            [CondParams1.bn-N./2*1e3,CondParams1.bn+N./2*1e3]);             %Y2 field session - conditions 2
        dNk1 = zeros(ntr1*K, diff(nfk));
        Yk1 = zeros(ntr1*K, diff(nfk));
        for tr=1:ntr1
          tmp1 = dN1(tr,:)';
          dNk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'- mean(tmp1).*H;
          dNk1((tr-1)*K+1:tr*K,:) = dNk(:,nfk(1)+1:nfk(2));
          tmp2 = detrend(Y1(tr,:))';
          yk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
          Yk1((tr-1)*K+1:tr*K,:) = yk(:,nfk(1)+1:nfk(2));
        end
        dNk2 = zeros(ntr2*K, diff(nfk));
        Yk2 = zeros(ntr2*K, diff(nfk));
        for tr=1:ntr2
          tmp1 = dN2(tr,:)';
          dNk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'- mean(tmp1).*H;
          dNk2((tr-1)*K+1:tr*K,:) = dNk(:,nfk(1)+1:nfk(2));
          tmp2 = detrend(Y2(tr,:))';
          yk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
          Yk2((tr-1)*K+1:tr*K,:) = yk(:,nfk(1)+1:nfk(2));
        end
        S_dN1 = sum(dNk1.*conj(dNk1)); S_Y1 = sum(Yk1.*conj(Yk1));
        coh1 = sum(dNk1.*conj(Yk1))./sqrt(S_dN1.*S_Y1);  %def'n of coherence
        S_dN2 = sum(dNk2.*conj(dNk2)); S_Y2 = sum(Yk2.*conj(Yk2));
        coh2 = sum(dNk2.*conj(Yk2))./sqrt(S_dN2.*S_Y2);
        D = (sum(abs(coh1))-sum(abs(coh2)))./(nfk(2)-nfk(1));
        GdN = [dNk1;dNk2]; GY = [Yk1;Yk2];  PD = zeros(1,5e3);
        for iPerm = 1:5e3
          NP = randperm(size(GdN,1));
          N1 = NP(1:size(dNk1,1));
          N2 = NP(size(dNk1,1)+1:end);
          PS_dN1 = sum(GdN(N1,:).*conj(GdN(N1,:))); PS_Y1 = sum(GY(N1,:).*conj(GY(N1,:)));
          Pcoh1 = sum(GdN(N1,:).*conj(GY(N1,:)))./sqrt(PS_dN1.*PS_Y1);
          PS_dN2 = sum(GdN(N2,:).*conj(GdN(N2,:))); PS_Y2 = sum(GY(N2,:).*conj(GY(N2,:)));
          Pcoh2 = sum(GdN(N2,:).*conj(GY(N2,:)))./sqrt(PS_dN2.*PS_Y2);
          PD(iPerm) = (sum(abs(Pcoh1))-sum(abs(Pcoh2)))./(nfk(2)-nfk(1));
        end
        p = length(find(abs(PD)>abs(D)))./5e3;

        
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
        Sys = sessTower(Sess);
        Ch = sessElectrode(Sess);
	Contact = sessContact(Sess);
	Cl = sessCell(Sess);
        dN1 = trialSpike(Trials1, Sys(1), Ch(1), Contact(1), Cl(1), CondParams1.Field, ...
            [CondParams1.bn-N./2*1e3,CondParams1.bn+N./2*1e3]);             %X1 spike session - conditions 1
        dN1 = sp2ts(dN1,[0,N-1/1e3,1e3]);
        dM1 = trialSpike(Trials1, Sys(2), Ch(2), Contact(2), Cl(2), CondParams1.Field, ...
            [CondParams1.bn-N./2*1e3,CondParams1.bn+N./2*1e3]);             %X1 spike session - conditions 1
        dM1 = sp2ts(dN1,[0,N-1/1e3,1e3]);
        
        dN2 = trialSpike(Trials2, Sys(1), Ch(1), Contact(1), Cl(1), CondParams2.Field, ...
            [CondParams1.bn(1)-N./2*1e3,CondParams1.bn(2)+N./2*1e3]);             %X2 spike session - conditions 2
        dN2 = sp2ts(dN2,[0,N-1/1e3,1e3]);
        dM2 = trialSpike(Trials2, Sys(2), Ch(2), Contact(2), Cl(2), CondParams2.Field, ...
            [CondParams1.bn(1)-N./2*1e3,CondParams1.bn(2)+N./2*1e3]);             %X2 spike session - conditions 2
        dM2 = sp2ts(dN2,[0,N-1/1e3,1e3]);
        dNk1 = zeros(ntr1*K, diff(nfk));
        dMk1 = zeros(ntr1*K, diff(nfk));
        for tr=1:ntr1
          tmp1 = dN1(tr,:)';
          dNk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'- mean(tmp1).*H;
          dNk1((tr-1)*K+1:tr*K,:) = dNk(:,nfk(1)+1:nfk(2));
          S_dN1(tr,:) = mean(abs(dNk1).^2);          
          tmp1 = dM1(tr,:)';
          dMk = fft(ntapers(:,1:K).*tmp1(:,ones(1,K)),nf)'- mean(tmp1).*H;
          dMk1((tr-1)*K+1:tr*K,:) = dMk(:,nfk(1)+1:nfk(2));
          S_dM1(tr,:) = mean(abs(dMk1).^2);
        end
        Xk2 = zeros(ntr2*K, diff(nfk));
        dMk2 = zeros(ntr2*K, diff(nfk));
        for tr=1:ntr2
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
        D = mean(abs(coh1))-mean(abs(coh2));
        GdN = [dNk1;dNk2]; GdM = [dMk1;dMk2];
        for iPerm = 1:5e3
          NP = randperm(size(GdN,1));
          N1 = NP(1:size(dNk1,1));
          N2 = NP(size(dNk1,1)+1:end);
          PS_dN1 = mean(abs(GdN(N1,:)).^2); PS_dM1 = mean(abs(GdM(N1,:)).^2);
          Pcoh1 = mean(GdN(N1,:).*conj(GdM(N1,:)))./sqrt(PS_dN1.*PS_dM1);
          PS_dN2 = mean(abs(GdN(N2,:)).^2); PS_dM2 = mean(abs(GdM(N2,:)).^2);
          Pcoh2 = mean(GdN(N2,:).*conj(GdM(N2,:)))./sqrt(PS_dN2.*PS_dM2);
          PD(iPerm) = mean(abs(Pcoh1))-mean(abs(Pcoh2));
        end
        p = length(find(abs(PD)>abs(D)))./5e3;

    end

