function Time = calcSaccStarttoReachStart(Trials)
%
%  Time =  ReachStart - SaccStart 

Time = [Trials.ReachStart] - [Trials.SaccStart];
