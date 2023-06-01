function [p,D,PD,Rate1a,Rate1b,Rate2a,Rate2b] = sessTestRateDiff(Sess,CondParams1a,CondParams1b,CondParams2a,CondParams2b)
%
%
%   [p,D,PD,Rate1,Rate2] = sessTestRateDiffDiff(Sess,CondParams1a,CondParams1b,CondParams2a,CondParams2b)
%
%   Compares the difference between condParams1a and CondParams1b to
%   CondParams2a and CondParams2b 
%   SESS    =   Cell array.  Session information
%   CONDParams1a =   Data structure.  Parameter information for 1st condition
%   CondParams1b =   Data structure.  Parameter information for 1st
%   condition diff
%   CONDParams2a =   Data structure.  Parameter information for 2nd condition
%   CondParams2b =   Data structure.  Parameter information for 2nd
%   condition diff
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


All_Trials = sessTrials(Sess);
Trials1a = Params2Trials(All_Trials,CondParams1a);
if iscell(Trials1a); Trials1a = Trials1a{1}; end
Trials1b = Params2Trials(All_Trials,CondParams1b);
if iscell(Trials1b); Trials1b = Trials1b{1}; end
Trials2a = Params2Trials(All_Trials,CondParams2a);
if iscell(Trials2a); Trials2a = Trials2a{1}; end
Trials2b = Params2Trials(All_Trials,CondParams2b);
if iscell(Trials2b); Trials2b = Trials2b{1}; end

sampling = 1e3;
ntr1a = length(Trials1a);
ntr1b = length(Trials1b);
ntr2a = length(Trials2a);
ntr2b = length(Trials2b);

if ntr1a < 2 || ntr1b < 2 || ntr2a < 2|| ntr2b < 2
    p = nan; D = nan; PD = nan;Rate1 = nan; Rate2 = nan;
    error(['Not enough trials ' num2str(ntr1a) ':' num2str(ntr1b) ':' num2str(ntr2a) ':' num2str(ntr2b)])
end


Type = getSessionType(Sess);
switch Type
    case {'Spike','Multiunit'}
        Sys = Sess{3}{1}; Ch = sessElectrode(Sess); Contact = sessContact(Sess);
        Cl = sessCell(Sess);
        Rate1a = trialRate(Trials1a, Sys, Ch, Contact, Cl, CondParams1a.Field, ...
            CondParams1a.bn);
        Rate1b = trialRate(Trials1b, Sys, Ch, Contact, Cl, CondParams1b.Field, ...
            CondParams1b.bn);
        
        Rate2a = trialRate(Trials2a, Sys, Ch, Contact, Cl, CondParams2a.Field, ...
            CondParams2a.bn);
        Rate2b = trialRate(Trials2b, Sys, Ch, Contact, Cl, CondParams2b.Field, ...
            CondParams2b.bn);
        
        Rate1a_Ave = sum(Rate1a)./ntr1a;
        Rate1b_Ave = sum(Rate1b)./ntr1b;
        Rate2a_Ave = sum(Rate2a)./ntr2a;
        Rate2b_Ave = sum(Rate2b)./ntr2b;
        
        Rate1_D = abs(Rate1a_Ave-Rate1b_Ave);
        Rate2_D = abs(Rate2a_Ave-Rate2b_Ave);
        
        D  = (Rate1_D - Rate2_D)/(Rate1_D + Rate2_D);
        
%         Rate1 = Rate1a./Rate1b_Ave;
%         Rate2 = Rate2a./Rate2b_Ave;
%         D = sum(Rate1)./ntr1a - sum(Rate2)./ntr2a;
        GXa = [Rate1a,Rate2a];
        GXb = [Rate1b,Rate2b];
        disp('Permutation calculation');
        for iPerm = 1:10e3
            NPa = randperm(size(GXa,2));
            N1a = NPa(1:ntr1a);
            N2a = NPa(ntr1a+1:end);
            PRate1a = sum(GXa(N1a))./ntr1a;
            PRate2a = sum(GXa(N2a))./ntr2a;
            
            NPb = randperm(size(GXb,2));
            N1b = NPb(1:ntr1b);
            N2b = NPb(ntr1b+1:end);
            PRate1b = sum(GXb(N1b))./ntr1b;
            PRate2b = sum(GXb(N2b))./ntr2b;
            
            PRate1_D = abs(PRate1a - PRate1b);
            PRate2_D = abs(PRate2a - PRate2b);
            
            PD(iPerm) = (PRate1_D - PRate2_D)/(PRate1_D + PRate2_D);
        end
        p = length(find(abs(PD)>abs(D)))./10e3;
        
       
end

