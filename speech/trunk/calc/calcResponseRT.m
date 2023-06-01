function RT = calcResponseRT(Trials);
%
%  RT = CALCRESPONSERT(TRIALS);
%

RT = [Trials.ResponseStart] - [Trials.Go];
