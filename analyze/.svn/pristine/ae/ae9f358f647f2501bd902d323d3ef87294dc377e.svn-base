function [u,s,v] = tqlisvd(x);
%
%  TQLISVD performs SVD for long-thin matrices.
%  
%  Inputs:  X = Array, Small dimension comes first.
%
%  Outputs: U = Array.  First index modes.  U(:,i)
%	    S = Vector.  Singular values.
%	    V = Array.  Second index modes.  V(:,i);
%  
%


x2 = x * x';
[a,s2] = eig(x2);
s = zeros(size(x));
for iDim = 1:size(x,1)
	s(iDim, iDim) = sqrt(s2(end-iDim+1,end-iDim+1));
end
u = a(:,end:-1:1);
v = zeros(size(x,2),size(x,1));
for iDim = 1:size(x,1)
  v(:,iDim) = u(:,iDim)'*x./s(iDim,iDim);
end
