function Time = calcSaccadeRT(Trials)
%
%  Time =  SaccStart - Go 

Time = [Trials.SaccStart] - [Trials.Go];
