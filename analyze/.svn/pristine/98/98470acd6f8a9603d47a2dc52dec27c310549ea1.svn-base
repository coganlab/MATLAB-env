function Dirs = sessCalcChoiceDirections(Sess)
%
%   Dirs = sessCalcChoiceDirections(Sess)
%

trials = sessTrials(Sess);
movement_directions  = [[trials.ReachChoice],[trials.SaccadeChoice]];
movement_directions = movement_directions(find(movement_directions ~= 0));

[dum, Dirs] = sort(hist(movement_directions,1:8),'descend');
Dirs = Dirs(1:2);