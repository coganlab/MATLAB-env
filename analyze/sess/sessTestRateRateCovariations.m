function [p,D,PD] = sessTestRateRateCovariations(Sess,CondParams)
%
%
%   [p,D,PD] = sessTestRateRateCovariations(Sess,CondParams1,CondParams2)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAM1 =   Data structure.  Parameter information
%
%   CondParams.Task    =   String/Cell.  Tasks to pool and compare.
%	    			To pool Task = {{'Task1','Task2'}};
%   CondParams.conds    =   Eye,Hand,Target conds {[],[],[]}
%   CondParams.condstype = 'Choice'  - looks at eye/hand movement
%   not Target
%   CondParams.Delay   =  Vector. Select trials according to delay interval (s).
%                    Delay = [DelayStart,DelayStop].
%   CondParams.Field   =   String.  Alignment field
%   CondParams.bn      =   Alignment time.
%
%
%   Outputs:  P	 = p-Value
%		D = Test statistic
%	        PD = Null-distribution of test statistic

if ischar(Sess{1})
    All_Trials = sessTrials(Sess);
else
    All_Trials = Sess{1};
end
Trials = Params2Trials(All_Trials,CondParams);

ntr = length(Trials);
NPERM = 1e4;

if ntr > 3
    Sys = sessTower(Sess);
    Ch = sessElectrode(Sess);
    Contact = sessContact(Sess);
    Cl = sessCell(Sess);
    rate1 = trialSpike(Trials, Sys(1), Ch(1), Contact(1), Cl(1), CondParams.Field, CondParams.bn);
    rate2 = trialSpike(Trials, Sys(2), Ch(2), Contact(2), Cl(2), CondParams.Field, CondParams.bn);
    dN = zeros(1,ntr);
    dM = zeros(1,ntr);
    for itrial = 1:ntr
        dN(itrial) = length(rate1{itrial});
        dM(itrial) = length(rate2{itrial});
    end
    GdN = [dN,dM];
    var1 = std(dN).*std(dM);
    tmp = cov([dN',dM']);
    D = tmp(2,1)/var1;
    PD = nan(1,NPERM);
    for iPerm = 1:NPERM
        NP = randperm(size(GdN,2));
        N1 = GdN(NP(1:size(dN,2)));
        N2 = GdN(NP(size(dN,2)+1:end));
        tmp = cov([N1',N2']);
        var1 = std(N1).*std(N2);
        PD(iPerm) = tmp(2,1)/var1;
    end
    p = length(find(abs(PD)>abs(D)))./NPERM;
    
    
else
    p = nan(1);
    D = nan(1);
    PD = nan(1,NPERM);
end






