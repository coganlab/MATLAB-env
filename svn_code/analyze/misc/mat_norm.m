function X_NORM = mat_norm(X);
%MAT_NORM Normalise a matrix
% X_NORM = MAT_NORM(X) zeroes out the rows of a matrix
%	and makes the standard deviation of each row
%
%

%  Author:  Bijan Pesaran 03/19/98

nrows=size(X,1);
ncolumns=size(X,2);

X_NORM=X;
for i=1:nrows,
	X_NORM(i,:)=X(i,:)-sum(X(i,:))./ncolumns;	
	sd=sqrt(sum(X(i,:).^2))./ncolumns;
	X_NORM(i,:)=X_NORM(i,:)./sd;
end
