function [p,D,PD,S_X1,S_X2] = sessTestSpecDiff(Sess,CondParams1,CondParams2,AnalParams)
%;Task,Field,bn,conds,tapers,dn,delay)
%
%   [p,D,PD,S_X1,S_X2] = sessTestSpecDiff(Sess,CondParams1,CondParams2,AnalParams)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS1 =   Data structure.  Parameter information for 1st condition
%   CONDPARAMS2 =   Data structure.  Parameter information for 2nd condition
%   ANALPARAMS  =   Data structure.  Analysis parameter information.
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.Delay   =  Vector. Select trials according to delay interval (s).
%                    Delay = [DelayStart,DelayStop].
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%
%   AnalParams.Tapers  =   [N,W].  Defaults to [.5,10]
%   AnalParams.fk      =   Vector.  Select frequency band to test in Hz.
%
%   Outputs:  P	 = p-Value
%		D = Test statistic
%	        PD = Null-distribution of test statistic 


All_Trials = sessTrials(Sess);
Trials1 = Params2Trials(All_Trials,CondParams1);
if iscell(Trials1); Trials1 = Trials1{1}; end
Trials2 = Params2Trials(All_Trials,CondParams2);
if iscell(Trials2); Trials2 = Trials2{1}; end

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
fk = AnalParams.fk;
if length(fk)==1; fk = [0,fk]; end
nfk = floor(fk./sampling.*nf);
ntr1 = length(Trials1);
ntr2 = length(Trials2);

if ntr1 < 2 || ntr2 < 2
    p = nan; D = nan; PD = nan;S_X1 = nan; S_X2 = nan;
    error(['Not enough trials ' num2str(ntr1) ':' num2str(ntr2)])
end

Type = getSessionType(Sess);
switch Type
    case 'Field'
        Sys = sessTower(Sess); Ch = sessElectrode(Sess);
        if iscell(Sys); Sys = Sys{1}; end
        if iscell(Sys); Sys = Sys{1}; end
        Contact = sessContact(Sess);

        X1 = trialLfp(Trials1, Sys, Ch, Contact, CondParams1.Field, ...
            CondParams1.bn);
        X2 = trialLfp(Trials2, Sys, Ch, Contact, CondParams2.Field, ...
            CondParams2.bn);
        Xk1 = zeros(ntr1*K, diff(nfk));
        Xk2 = zeros(ntr2*K, diff(nfk));
        mX1 = sum(X1)./ntr1; mX2 = sum(X2)./ntr2;
        X1 = X1 - mX1(ones(1,ntr1),:);
        X2 = X2 - mX2(ones(1,ntr2),:);

        for tr = 1:ntr1
            tmp1 = X1(tr,:)';
            xk = fft(tapers(:,1:K).*tmp1(:,ones(1,K)),nf)';
            Xk1((tr-1)*K+1:tr*K,:) = xk(:,nfk(1)+1:nfk(2));
        end
        for tr = 1:ntr2
            tmp2 = X2(tr,:)';
            xk = fft(tapers(:,1:K).*tmp2(:,ones(1,K)),nf)';
            Xk2((tr-1)*K+1:tr*K,:) = xk(:,nfk(1)+1:nfk(2));
        end
        S_X1 = sum(Xk1.*conj(Xk1))./(ntr1*K);
        S_X2 = sum(Xk2.*conj(Xk2))./(ntr2*K);
        D = sum(log(S_X1) - log(S_X2))./diff(nfk);
        GX = [Xk1;Xk2];
        cGX = conj(GX);
        aGX = GX.*cGX;
        disp('Permutation calculation');
	NPERM = 5e3;
        parfor iPerm = 1:NPERM
            NP = randperm(size(GX,1));
            N1 = NP(1:size(Xk1,1));
            N2 = NP(size(Xk1,1)+1:end);
            PS_X1 = sum(aGX(N1,:))./(ntr1.*K);
            PS_X2 = sum(aGX(N2,:))./(ntr2.*K);
            PD(iPerm) = sum(log(PS_X1)-log(PS_X2))./diff(nfk);
        end
        p = length(find(abs(PD)>abs(D)))./NPERM;
end

