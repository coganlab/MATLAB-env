function [con_p, con_ST, con_FA, LevelInd] = controlled_performance(p, ST, FA, DetectType, MinST)
%
%  [con_p, con_ST, con_FA, LevelInd] = controlled_performance(p, ST, FA, DetectType, MinST)
%
%           DetectType = String. 'Hit' or 'Correct'
%                           Defaults to 'Hit'
%           MinST = Scalar - minimum selection time
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
        [minP,dim] = min(abs(pIncorrect-FA));
        ind = find(pIncorrect==pIncorrect(dim));
        con_p = max(pCorrect(ind));
        pind = find(pCorrect(ind)==con_p);
        [con_ST, ii] = min(ST(ind(pind)));
        con_FA = pIncorrect(ind(pind(ii)));
        LevelInd = ind(pind(ii));
end


if(isempty(con_p))
    con_p = nan;
    con_ST = nan;
    con_FA = nan;
    LevelInd = nan;
end