function Targ2Delay = calcTarg2DelayReach(Trials)
%  Returns target delay from end of reach to onset of second target
%  Targ2Delay = Targ2On - ReachAq
%

Targ2Delay = [Trials.Targ2On] - [Trials.ReachAq];

end