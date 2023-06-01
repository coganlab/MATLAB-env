function  varargout = procarray(Y, varargin);
%PROCARRAY transforms multidimensional arrays into 2-D arrays and vice versa.
%
%   X = PROCARRAY(Y, MASK) takes all but the last dimension of Y and
%   strings the data into one dimension making Y 2-D.
%
%   [X, INDEX] = PROCARRAY(Y) stores the permutations to the array in INDEX. 
%
%   X = PROCARRAY(Y, INDEX) carries out the reverse operation using the INDEX
%   vector output by PROCARRAY.
%

%   Author: Bijan Pesaran, version date 3/7/98.

% defaults:
dir = 1; 			% process in the forward direction by default.

if length(varargin)==1 
	dir=0; 			% if any variable arguments then 
end				% process in the reverse direction.

if dir == 1 			% For forward direction
	sz=size(Y);
	nY=length(sz);  	% dX has the number of dimensions in Y.
	time=sz(nY);            % Take the last dimension to be time
	chan=prod(sz(1:nY-1));	% Calculate the number of channels
	X=reshape(Y,[chan,time]);
	index=sz;
        if nargout == 2, varargout{2}=index;end
else				% For reverse direction
        sz=varargin{1};
	dX=size(sz); dX=dX(2);	% dX has the number of dimensions in X.
	time=sz(length(sz));	% Take the last dimension to be time
	X=reshape(Y,[sz(1:length(sz)-1),time]);	% Time-order the full 
                                                % dimensioned array
end



varargout{1}=X;






