function [rate, nTr] = mypsth2(spikecell, bn, smoothing)
%
%  mypsth2(spikecell, bn, smoothing)
%
%   INPUTS: 
%       SPIKECELL = Cell array. Spike times in ms.  This is assumed to start from 0 ms.
%       BN =        Scalar array [start,stop] to give the start and stop times 
%           of the spike times in Spike.  This realigns the spike times.
%       SMOOTHING = Scalar. Degree of smoothing in the psth in ms.
%
%   OUTPUTS:
%       RATE:  Estimated rate profile.
%

if nargin < 3 || isempty(smoothing)
    smoothing = 50; 
end

nTr = length(spikecell);
Start = bn(1); Stop = bn(2);
X = [];
for iTr = 1:nTr;
    x = spikecell{iTr};
    x = (x + Start)';
    X = [X x];
end
Z = hist(X,Start:Stop);
window = normpdf(-3*smoothing:3*smoothing,0,smoothing);
rate = (1e3./nTr)*conv(Z,window);
rate = rate(3*smoothing+1:end-3*smoothing);

rate(1:3*smoothing) = rate(3*smoothing);
rate(end-3*smoothing:end) = rate(end-3*smoothing);