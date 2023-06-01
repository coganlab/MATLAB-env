function MemoryDelay = calcMemoryDelay(Trials)
%  Returns memory-delay period for trials
%  MemoryDelay = Go - TargsOff
%

MemoryDelay = [Trials.Go] - [Trials.TargetOff];

