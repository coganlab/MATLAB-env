function Delay = calcDelay(Trials)
%  Returns delay period for trials
%  Delay = Go - TargsOn
%

Delay = [Trials.Go] - [Trials.TargsOn];

