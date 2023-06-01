function [Dirs, N, Nall] = sessCalcTarg2Directions(Sess, Task)
%
%   [Dirs, N, Nall] = sessCalcDirections(Sess, Task)
%

if nargin == 1
    Trials = sessTrials(Sess);
else
    Trials = sessTrials(Sess, Task);
end
dsTrials = Trials([Trials.TaskCode]==38 | [Trials.TaskCode]==39);
if ~isempty(dsTrials)
    tmp = hist([dsTrials.Targ2],1:8);
    for i = 1:8 N(i) = sum(tmp(i)); end
    [dum,Dirs] = sort(N,'descend');
    Dirs = [Dirs(1),Dirs(2)];
    N = tmp(Dirs);
    Nall = tmp;
else
    Dirs = [nan,nan];
    N = [0,0];
    Nall = zeros(1,8);
end