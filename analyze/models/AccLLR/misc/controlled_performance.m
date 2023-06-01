function [con_p, con_ST, con_FA, LevelInd] = controlled_performance(p, ST, FA, DetectType, MinST, pCorr)
%
%  [con_p, con_ST, con_FA, LevelInd] = controlled_performance(p, ST, FA, DetectType, MinST, pCorr)
%
%           DetectType = String. 'Hit' or 'Correct'
%                           Defaults to 'Hit'
%           MinST = Scalar - minimum selection time
%           pCorr = Scalar - Prob correct level. 
%                           Defaults to 100.
%
%   p(:,1,1) = Correct detects for each level.
%   p(:,2,2) = Correct rejects
%   p(:,2,1) = False alarm.
%   p(:,1,2) = Incorrect miss.

if nargin < 4 || isempty(DetectType)
    DetectType = 'Hit';
end
if nargin < 5
    MinST = 0;
    pCorr = 100;
elseif nargin < 5
    MinST = 0;
end
switch DetectType
    case 'Hit'
        ind = find(ST > MinST);
        ST = ST(ind);
        p = p(ind,:,:);
        [minP,dim] = min(abs(p(:,2,1)-FA));
        ind = find(p(:,2,1)==p(dim,2,1));
        con_p = max(p(ind,1,1));
        pind = find(p(ind,1,1)==con_p);
        [con_ST, ii] = min(ST(ind(pind)));
        con_FA = p(ind(pind(ii)),2,1);
        LevelInd = ind(pind(ii));
%    case 'Reject'
%        [minP,dim] = min(abs(p(:,1,2)-FA));
%        ind = find(p(:,1,2)==p(dim,1,2));
%        con_FA = p(ind(1),1,2);
%        con_p = max(p(ind,2,2));
%        pind = find(p(ind,2,2)==con_p);
%        con_ST = min(ST(ind(pind)));
    case 'Correct'
        ind = find(ST > MinST);
        ST = ST(ind);
        p = p(ind,:,:);
        pCorrect = (p(:,1,1)+p(:,2,2))./2;
        pIncorrect = (p(:,2,1)+p(:,1,2))./2;
        
        %Keep controlled FA then find PCorr val
        %[minP,dim] = min(abs(pIncorrect-FA));
        ind = find(pIncorrect < FA);
        if(length(ind) ==0)
        	[minP,ind] = min(abs(pIncorrect-FA));
        end
        %size(pIncorrect)
        %ind = find(pIncorrect==pIncorrect(dim));
        % Instead of maximising correct find the value that is nearest to pCorr
        %con_p = max(pCorrect(ind))
        %pind = find(pCorrect(ind)==con_p)
        
        pind = find(pCorrect(ind) > pCorr);
        if(length(pind) == 0)
            con_p = min(abs(pCorrect(ind) - pCorr));
            pind = find((abs(pCorrect(ind) - pCorr)) == con_p);
        end
        [con_ST, ii] = min(ST(ind(pind)));
        con_FA = pIncorrect(ind(pind(ii)));
        con_p =  pCorrect(ind(pind(ii)));
        LevelInd = ind(pind(ii));
        %pause
    case 'Matched'
        bound = 0.1;
        % Match total FA and Correct performance
        ind = find(ST > MinST);
        ST = ST(ind);
        p = p(ind,:,:);
        pCorrect = (p(:,1,1)+p(:,2,2))./2;
        pIncorrect = (p(:,2,1)+p(:,1,2))./2; %Keep controlled FA then find PCorr val
        %[minP,dim] = min(abs(pIncorrect-FA));
        
        p_total = pCorrect + (1 - pIncorrect);
        
        closest_pval = abs(p_total - pCorr - (1- FA));
        ind = find(closest_pval<bound);
        if(length(ind) == 0)
            [minP,ind] = min(closest_pval);
            con_p = pCorrect(ind);
            con_ST = ST(ind);
            con_FA = pIncorrect(ind);
            LevelInd = ind;
        else
            con_ST = ST(ind);
            [con_ST,pind] = min(con_ST);
            con_p = pCorrect(ind(pind));
            con_FA = pIncorrect(ind(pind));
            LevelInd = ind(pind);
        end
    case 'CorrectMatched'
        bound = 0.05;
        % Match total FA and Correct performance
        ind = find(ST > MinST);
        ST = ST(ind);
        p = p(ind,:,:);
        pCorrect = (p(:,1,1)+p(:,2,2))./2;
        pIncorrect = (p(:,2,1)+p(:,1,2))./2; %Keep controlled FA then find PCorr val
        %[minP,dim] = min(abs(pIncorrect-FA));
        
        p_total = pCorrect + (1 - pIncorrect);
        
        closest_pval = p_total - pCorr - (1- FA);
        ind = find(closest_pval>-bound);
        if(length(ind) == 0)
            con_ST = ST(ind);
            [minP,pind] = min(con_ST);
            con_p = pCorrect(ind(pind));
            con_ST = ST(ind(pind));
            con_FA = pIncorrect(ind(pind));
            LevelInd = ind(pind);
        else
            con_ST = NaN;
            con_p = NaN;
            con_FA = NaN;
            LevelInd = NaN;
        end
end


if(isempty(con_p))
    con_p = nan;
    con_ST = nan;
    con_FA = nan;
    LevelInd = nan;
end