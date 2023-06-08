function [opt_p, opt_ST, opt_FA, LevelInd] = optimal_performance(p, ST, DetectType, MinST)
%
%  [opt_p, opt_ST, opt_FA, LevelInd] = optimal_performance(p, ST, DetectType, MinST)
%
%           DetectType = String. 'Hit' or 'Correct'
%                           Defaults to 'Hit'
%           MinST = Scalar - minimum selection time
%                   Defaults to 0
%
%   p(:,1,1) = Correct detects for each level.
%   p(:,2,2) = Correct rejects
%   p(:,2,1) = False alarm.
%   p(:,1,2) = Incorrect miss.

if nargin < 3 || isempty(DetectType)
    DetectType = 'Hit';
end
if nargin < 4
    MinST = 0;
end
switch DetectType
    case 'Hit'
        ind = find(ST > MinST);
        ST = ST(ind);
        p = p(ind,:,:);
        pHit = p(:,1,1);
        pFalseAlarm = p(:,2,1);
        opt_p = max(pHit);
        ind_Hit = find(pHit==opt_p);
        opt_FA = min(pFalseAlarm(ind_Hit));
        ind_FA = find(pFalseAlarm(ind_Hit)==opt_FA);
        [opt_ST,dum] = min(ST(ind_Hit(ind_FA)));
        LevelInd = ind_Hit(ind_FA(dum));
    case 'Correct'
        ind = find(ST > MinST);
        ST = ST(ind);
        p = p(ind,:,:);
        pCorrect = (p(:,1,1)+p(:,2,2))./2;
        pIncorrect = (p(:,2,1)+p(:,1,2))./2;
        opt_p = max(pCorrect);
        ind_Corr = find(pCorrect==opt_p);
        opt_FA = min(pIncorrect(ind_Corr));
        ind_Inc = find(pIncorrect(ind_Corr)==opt_FA);
        [opt_ST, dum] = min(ST(ind_Corr(ind_Inc)));
        LevelInd = ind_Corr(ind_Inc(dum));
    case {'Matched','CorrectMatched'}
        % Not yet implemented
        opt_p = NaN;
        opt_ST = NaN;
        opt_FA = NaN;
        LevelInd = NaN;
end
if(isempty(opt_p))
    opt_p = nan;
    opt_ST = nan;
    opt_FA = nan;
    LevelInd = nan;
end