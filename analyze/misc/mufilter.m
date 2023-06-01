function mu = mufilter(data,sampling)
%
%  mu = mufilter(data,sampling)
%
%   SAMPLING defaults to 20kHz
%


if nargin < 2; sampling = 2e4; end

mu = (mtfilter(data,[0.01,3000],sampling,3300));
