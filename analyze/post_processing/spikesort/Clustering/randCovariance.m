function [ C ] = randCovariance ( D, scale )

% function [ C ] = randCovariance ( D, scale )
% D = dimension
% scale = scale

ready = 0;

 if nargin ==1
  	scale = 1 ;
 end

while ~ready,
   
   C =   2*rand(D, D) - 1;
	C = scale * C * C';
	if rank(C) == D,
		ready = 1;

	end
end
