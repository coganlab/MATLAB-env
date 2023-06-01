function Y = myfastmedfilt1(X,N)
%
%
%

X = rand(10000);
[a,b] = sort(X);
[c,d] = ismember(b,1:31);
indices = find(d);
Y = X(b(indices(16)));