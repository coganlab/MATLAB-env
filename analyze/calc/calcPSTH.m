function [rate, nTr] = calcPSTH(spikecell, bn, smoothing)
%
%  psth(spike, bn, smoothing)
%
%	Spike is a cell array of spike times in ms.  This is assumed to start from 0ms.
%	bn is [start,stop] to give the start and stop times 
%		of the spike times in Spike.  This realigns the spike times
%	smoothing is the degree of smoothing in the psth in ms.
%

if nargin < 3 | length(smoothing)==0 smoothing = 50; end

nTr = length(spikecell);
Start = bn(1); Stop = bn(2);

X = [];
xx = cell(1,nTr);
for iTr = 1:nTr;
    x = spikecell{iTr};
    x = (x + Start)';
    xx{iTr} = x;
    X = [X x];
end

Z = hist(X,Start:Stop);
window = normpdf([-3*smoothing:3*smoothing],0,smoothing);

rate = (1000/nTr)*conv(Z,window);
rate = rate(3*smoothing+1:end-3*smoothing);
% 
