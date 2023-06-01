function [opt_p, opt_ST, opt_FA, LevelInd] = optimal_performance(p, ST, DetectType, MinST)
%
%  [opt_p, opt_ST, opt_FA, LevelInd] = optimal_performance(p, ST, DetectType)
%
%           DetectType = String. 'Hit' or 'Correct'
%                           Defaults to 'Hit'
%           MinST = Scalar - minimum selection time
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
        ind = find(pHit==opt_p);
        [opt_ST,dum] = min(ST(ind));
        opt_FA = pFalseAlarm(ind(dum));
        LevelInd = ind(dum);
    case 'Correct'
        ind = find(ST > MinST);
        ST = ST(ind);
        p = p(ind,:,:);
        pCorrect = (p(:,1,1)+p(:,2,2))./2;
        pIncorrect = (p(:,2,1)+p(:,1,2))./2;
        opt_p = max(pCorrect);
        ind = find(pCorrect==opt_p);
        [opt_ST, dum] = min(ST(ind));
        opt_FA = pIncorrect(ind(dum));
        LevelInd = ind(dum);
end
if(isempty(opt_p))
    opt_p = nan;
    opt_ST = nan;
    opt_FA = nan;
    LevelInd = nan;
end