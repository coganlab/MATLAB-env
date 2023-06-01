function Time = calcAbsDiffRT(Trials)
%
%  Time =  abs(ReachStart - SaccStart) 

Time = abs([Trials.ReachStart] - [Trials.SaccStart]);
