function Trials = TrialConds(Trials,conds,movement)
%
%   Trials = TrialConds(Trials,conds,movement)
%
%  conds is a cell array in {[E],[H],[T]} form
%  movement is a string - 'Target'or empty- third argument of conds is Target, 'Movement' - third
%  argument is movement direction. 'Target2' arguement is second Target

if isempty(conds) || nargin < 2; conds = []; end

if(nargin < 3)
    movement = 'Target';
end

if length(conds)==3
    SE = getStartEye(Trials);
    Trials = Trials(find(ismember(SE,conds{1})));
    SH = getStartHand(Trials);
    Trials = Trials(find(ismember(SH,conds{2})));
    if(strcmp(movement,'Movement'))
        T = getMovementChoice(Trials);
    end
    if(strcmp(movement, 'Target2'))
        T = getTarget2(Trials);
    else
        T = getTarget(Trials);
    end
    Trials = Trials(find(ismember(T,conds{3})));
elseif length(conds)==1
    if ~isempty(conds{1})
        if(strcmp(movement,'Movement'))
            T = getMovementChoice(Trials);
        
        else
            T = getTarget(Trials);
        end
        Trials = Trials(find(ismember(T,conds{1})));
    elseif isempty(conds{1})
        Trials = Trials;
    end
end
