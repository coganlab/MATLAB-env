function Trials = TrialConds(Trials,conds)
%
%   Trials = TrialConds(Trials,conds,num)
%
%  conds is a cell array in {[E],[H],[T]} form

if isempty(conds) || nargin < 2 conds = []; end


if length(conds)==3
    SE = getStartEye(Trials);
    Trials = Trials(find(ismember(SE,conds{1})));
    SH = getStartHand(Trials);
    Trials = Trials(find(ismember(SH,conds{2})));
    T = getMovementChoice(Trials);
    Trials = Trials(find(ismember(T,conds{3})));
elseif length(conds)==1
    if ~isempty(conds{1})
        T = getMovementChoice(Trials);
        Trials = Trials(find(ismember(T,conds{1})));
    elseif isempty(conds{1}) 
        Trials = Trials;
    end
end