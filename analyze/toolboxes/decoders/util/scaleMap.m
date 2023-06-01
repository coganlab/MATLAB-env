function [f finv] = scaleMap( data, N )
% Given a time series, find the piecewise-linear monotonic function with N
% pieces that maps the data such that the points under the mapping are as
% close to Gaussian distributed as possible.  Returns two function handles,
% one for the forward mapping and one for the inverse.

sortData = sort(data);
sortNorm = sort(randn(size(data)));

pt1 = sortData(1:floor(numel(sortData)/N):end);
pt2 = sortNorm(1:floor(numel(sortData)/N):end);

f    = @(x) piecewiseMap( x, pt1, pt2 );
finv = @(x) piecewiseMap( x, pt2, pt1 );

function y = piecewiseMap( x, pt1, pt2 )

if x < pt1(1) || x >= pt1(end) % extrapolate
    y = pt2(1) + (x-pt1(1))/(pt1(end)-pt1(1))*(pt2(end)-pt2(1));
else % interpolate
    idx = find( pt1 > x, 1 );
    if isempty(idx)
        disp('ho');
    end
    y = pt2(idx-1) + (x-pt1(idx-1))/(pt1(idx)-pt1(idx-1))*(pt2(idx)-pt2(idx-1));
end