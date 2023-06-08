function Y=smooth(X,h)
%SMOOTH  Smooth time series using the optimal least squares filter
%
%   Y = SMOOTH(X, H)  produces a smoothed time series Y by
%	convolving a filter of width H with the input time series
%	X.
%
%  	See also:

%	Author: B. Pesaran, 03-03-98
%

hh=2.*h-1;
time=[1:hh]-h-1;
kernel=0.75*(1.-(time./h).^2);
kernel=kernel./sum(kernel);
Y=filter(kernel,1,X')';
Y(:,1:end-h)=Y(:,h+1:end);


