function x=shift(y,n,flag)
%SHIFT Shifts the elements of a 1-D array
%
%  X = SHIFT(Y, N, FLAG) shifts the elements of the 1-D array
%      Y by N points.  If flag is set to 'aperiodic' then aperiodic
%      boundary conditions are used otherwise X is rotated.
%

%  Modification History:  Bijan Pesaran 12/25/98
%

reverse=0;
if nargin < 3 flag = 0; 
else flag = 1; end
if n < 0 reverse=1; end

n=abs(n);

N=length(y);
x=zeros(1,N);

if flag
if ~reverse 
x(n+1:end)=y(1:N-n);
else 
x(1:N-n)=y(n+1:N);
end
end

if ~flag
if ~reverse
x(1:n)=y(N-n+1:end);
x(n+1:N)=y(1:N-n);
else
x(1:N-n)=y(n+1:N);
x(N-n+1:end)=y(1:n);
end
end
