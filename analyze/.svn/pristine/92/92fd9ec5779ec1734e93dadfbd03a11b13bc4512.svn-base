function [p,D,PD,Rate1,Rate2] = sessTestRateDiff(Sess,CondParams1,CondParams2)
%
%
%   [p,D,PD,Rate1,Rate2] = sessTestRateDiff(Sess,CondParams1,CondParams2)
%
%   SESS    =   Cell array.  Session information
%   CONDPARAMS1 =   Data structure.  Parameter information for 1st condition
%   CONDPARAMS2 =   Data structure.  Parameter information for 2nd condition
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
Trials1 = Params2Trials(All_Trials,CondParams1);
if iscell(Trials1); Trials1 = Trials1{1}; end
Trials2 = Params2Trials(All_Trials,CondParams2);
if iscell(Trials2); Trials2 = Trials2{1}; end

sampling = 1e3;
ntr1 = length(Trials1);
ntr2 = length(Trials2);

if ntr1 < 2 || ntr2 < 2
    p = nan; D = nan; PD = nan;Rate1 = nan; Rate2 = nan;
    disp(['Not enough trials ' num2str(ntr1) ':' num2str(ntr2)])
    return
end

NPERM = 1e4;

Type = getSessionType(Sess);
switch Type
    case {'Spike','Multiunit'}
        Sys = sessTower(Sess); Ch = sessElectrode(Sess); Contact= sessContact(Sess);
        if iscell(Sys); Sys = Sys{1}; end
        if iscell(Sys); Sys = Sys{1}; end
        Cl = sessCellDepthInfo(Sess);
        
        Rate1 = trialRate(Trials1, Sys, Ch, Contact, Cl, CondParams1.Field, ...
            CondParams1.bn);
        Rate2 = trialRate(Trials2, Sys, Ch, Contact, Cl, CondParams2.Field, ...
            CondParams2.bn);
        D = sum(Rate1)./ntr1 - sum(Rate2)./ntr2;
        GX = [Rate1,Rate2]; nGX = size(GX,2);
        disp('Permutation calculation');
        if matlabpool('size')
          parfor iPerm = 1:NPERM
            NP = randperm(nGX);
            N1 = NP(1:ntr1);
            N2 = NP(ntr1+1:end);
            PRate1 = sum(GX(N1))./ntr1;
            PRate2 = sum(GX(N2))./ntr2;
            PD(iPerm) = PRate1-PRate2;
          end
        else
          for iPerm = 1:NPERM
            NP = randperm(nGX);
            N1 = NP(1:ntr1);
            N2 = NP(ntr1+1:end);
            PRate1 = sum(GX(N1))./ntr1;
            PRate2 = sum(GX(N2))./ntr2;
            PD(iPerm) = PRate1-PRate2;
          end
        end
        p = length(find(abs(PD)>abs(D)))./NPERM;
end

