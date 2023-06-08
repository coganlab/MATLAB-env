function y = mymedfilt1(data,N)
%
%  y = mymedfilt1(data,N)
%
y = zeros(1,length(data));
start = [1:1e5:length(data)];

if length(start)>1
  for iStart = 1:length(start)-1;
    y(start(iStart):start(iStart+1)-1) = ...
	medfilt1(data(start(iStart):start(iStart+1)-1),N);
  end
  y(start(end-1):end) = medfilt1(data(start(end-1):end),N);
else
  y = medfilt1(data,N);
end
