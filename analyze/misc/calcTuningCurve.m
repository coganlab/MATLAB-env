function [f, N] = calcTuningCurve(x, y, bins);
%
%  [f, N] = calcTuningCurve(x, y, bins);
%
%  bins = Cell array.  Boundaries of bins for each element.
%           Each element of bins is [nRange,minmaxRange]  
%   Defaults to angles for circular tuning curve, assuming x is [-pi,pi]

if nargin < 3  || isempty(bins)
    bins{1}(1,:) = [-pi./8,pi./8];
    bins{2}(1,:) = [pi./8,3*pi./8];
    bins{3}(1,:) = [3*pi./8,5*pi./8];
    bins{4}(1,:) = [5*pi./8,7*pi./8];
    bins{5}(1,:) = [7*pi./8,pi];
    bins{5}(2,:) = [-pi,-7*pi./8];
    bins{6}(1,:) = [-7*pi./8,-5*pi./8];
    bins{7}(1,:) = [-5*pi./8,-3*pi./8];
    bins{8}(1,:) = [-3*pi./8,-pi./8];
end

nBin = length(bins);
f = zeros(1,nBin);
N = zeros(1,nBin);
for iBin = 1:nBin
    bn = bins{iBin};
    nRange = size(bn,1);
    xtot = [];
    for iRange = 1:nRange
        minRange = bn(iRange,1);
        maxRange = bn(iRange,2);
      xtot = [xtot find(x > minRange & x<= maxRange)];
    end
    if length(xtot)==0 
        warning('Missing data'); 
    else
        f(iBin) = mean(y(xtot));
        N(iBin) = length(xtot);
    end
end