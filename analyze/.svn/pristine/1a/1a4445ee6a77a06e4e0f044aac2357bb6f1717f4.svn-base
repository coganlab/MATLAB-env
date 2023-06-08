function Rank = calcSaccStarttoReachStartRank(Trials)
%
%  Rank = Fastest ReachStart - SaccStart = 0
%         Slowest ReachStart - SaccStart = 1

Time = [Trials.ReachStart] - [Trials.SaccStart];
[dum,ind] = sort(Time);
Ntrials = length(Time);
Rank = zeros(1,Ntrials);
Rank(ind) = linspace(0,1,Ntrials);
