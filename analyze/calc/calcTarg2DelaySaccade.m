function Targ2Delay = calcTarg2DelaySaccade(Trials)
%  Returns target delay from end of saccade to onset of second target
%  Targ2Delay = Targ2On - SaccadeAq
%

Targ2Delay = [Trials.Targ2On] - [Trials.SaccadeAq];

end