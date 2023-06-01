function r = ztrans(C,trials,tapers,gamma)
%
%  r = ztrans(C,trials,tapers,gamma)
%

if nargin < 4 gamma=1.5; end

K = floor(2*tapers(1).*tapers(2) - 1);
nu = 2.*trials*K;

q = sqrt((-(nu-2).*log(1-abs(C).^2)));
r = gamma.*(q-gamma);
