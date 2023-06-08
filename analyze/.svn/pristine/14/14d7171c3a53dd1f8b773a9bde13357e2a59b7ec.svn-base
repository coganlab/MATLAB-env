function Rank = calcAbsDiffRTRank(Trials)
%
%  Rank = Fastest AbsDiffRT = 0
%         Slowest AbsDiffRT = 1

Time = calcAbsDiffRT(Trials);
[dum,ind] = sort(Time);
Ntrials = length(Time);
Rank = zeros(1,Ntrials);
Rank(ind) = linspace(0,1,Ntrials);
