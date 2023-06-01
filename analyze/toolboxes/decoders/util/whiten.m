function [y m c z] = whiten(x)
% y - whitened version of input x
% m - mean of each column of x, subtracted from y
% c - covariance between columns of x, decorrelated from y
% z - nonzero columns of x (zero columns are removed from y)
% David Pfau, 2012
m = mean(x);
z = m==0;
y = x(:,m~=0);
m = m(m~=0);
y = y - m(ones(1,size(y,1)),:);
c = (y'*y)/size(y,1);
y = (chol(c)'\y')';