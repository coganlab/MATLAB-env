function x=shuffle(y);
%SHUFFLE Reorders the elements of a vector
%
%

n=length(y);
x=y(randperm(n));