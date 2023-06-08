function X = reverse(Y);
%REVERSE reverses the elements of a vector.
%
% X = Reverse (Y) reverses the elements of Y and returns the new vector in X.

%   Author: Bijan Pesaran, version date 3/7/98.

% error chk
sY=size(Y);
dY=size(sY);
if dY(1) > 1 , error('Only accept vectors, not arrays.'); end

nY=sY(2);
X=Y(nY:-1:1);
