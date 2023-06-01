function Time = calcReachRT(Trials)
%
%  Time =  ReachStart - Go 

Time = [Trials.ReachStart] - [Trials.Go];
