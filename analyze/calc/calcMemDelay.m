function MemDelay = calcMemDelay(Trials)
%  Returns memory delay period for trials
%  MemDelay = Go - TargsOn
%

MemDelay = [Trials.Go] - [Trials.TargetOff];

