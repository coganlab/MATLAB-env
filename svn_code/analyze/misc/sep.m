function Y = sep(X1,X2,varargin)
%SEP Vector p-norm
%  Y = SEP(X1,X2) calculates the usual 2-norm between two input vectors, 
%    X1 and X2
%  Y = SEP(X1,X2,P) calculates the p-norm.

p=2;
if length(varargin) > 0; p=varargin(1); end

tot=sum((X1-X2).^p);
Y=tot.^(1./p);


