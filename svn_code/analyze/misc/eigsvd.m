function [U,S,V] = eigsvd(X,num)
%EIGSVD  Singular Value Decomposition using TQLI diagonalisation
%
%   [U,S,V] = TQLISVD(X, NUM) produces a diagonal matrix S, of the
%	same dimension as X and with nonnegative diagonal elements
%	in decreasing order, and unitary matrices U and V so that
%	X = U*S*V' but that the dimensions of U and V are m-by-NUM
%	and n-by-NUM respectively.
%
%	See also:  SVD.

%	Author: B. Pesaran, 03-03-98
%

[m,n]=size(X);

if n < m, X=X'; end
[p,q]=size(X);

xr=zeros(p,p);
for i=1:p, 
	for j=i:p, xr(i,j)=sum(X(i,:).*X(j,:)); end
end

xr=xr+xr';

for i=1:p, xr(i,i)=sum(X(i,:).*X(i,:)); end

[Us,D] = eig(xr);

for i=1:p, Ss(i)=D(i,i); end
[tmp,index]=sort(Ss);
tmp=tmp(p:-1:1);
index=index(p:-1:1);
S=sqrt(abs(tmp));

U=zeros(p,num);
for i=1:num, U(:,i)=Us(:,index(i)); end
V=X'*U;
for i=1:num, V(:,i)=V(:,i)/S(i); end


U=U';
V=V';

