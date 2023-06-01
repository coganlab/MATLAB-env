function Rank = calcReachRTRank(Trials)
%
%  Rank = Fastest ReachRT = 0
%         Slowest ReachRT = 1

Time = [Trials.ReachStart] - [Trials.Go];
[dum,ind] = sort(Time);
Ntrials = length(Time);
Rank = zeros(1,Ntrials);
Rank(ind) = linspace(0,1,Ntrials);
