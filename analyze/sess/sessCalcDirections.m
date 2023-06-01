function [Dirs, N, Nall] = sessCalcDirections(Sess, Task)
%
%   [Dirs, N, Nall] = sessCalcDirections(Sess, Task)
%

if nargin == 1
    Trials = sessTrials(Sess);
else
    Trials = sessTrials(Sess, Task);
end
if ~isempty(Trials)
    goodind = find([Trials.Target] < 9);
    Trials = Trials(goodind);
    tmp = hist([Trials.Target],1:8);
    for i = 1:4 N(i) = sum(tmp([i,i+4])); end
    [dum,Dirs] = sort(N,'descend');
    Dirs = [Dirs(1),Dirs(1)+4];
    N = tmp(Dirs);
    Nall = tmp;
else
    Dirs = [nan,nan];
    N = [0,0];
    Nall = zeros(1,8);
end