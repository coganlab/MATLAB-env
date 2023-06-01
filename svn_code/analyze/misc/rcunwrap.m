function [y,nd] = rcunwrap(x)
%RCUNWRAP Phase unwrap utility used by CCEPS.
%   RCUNWRAP(X) unwraps the phase and removes phase corresponding
%   to integer lag.  See also: UNWRAP, CCEPS.

%   Author(s): L. Shure, 1988
%          L. Shure and help from PL, 3-30-92, revised

n = length(x);
y = unwrap(x);
nh = fix((n+1)/2);
nd = round(y(nh+1)/pi);
y(:) = y(:)' - pi*nd*(0:(n-1))/nh;

