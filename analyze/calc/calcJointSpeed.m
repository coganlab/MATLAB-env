    function Speed = calcJointSpeed(Data,Filter)
%
%  Speed = calcJointSpeed(Data, Filter)
%
%   INPUTS:  DATA = Array.  [Trial,Time]
%	     FILTER
%
%  OUTPUTS:  SPEED = Array.  Marker speed for each trial
%

if nargin==1 
  [b,Filter] = sgolay(5,11); 
end
if length(Filter)==1 
  [b,Filter] = sgolay(5,Filter); 
end
nt = size(Filter,1);

  nTr = size(Data,1) ; nT = size(Data,2);
  sy = filter(Filter(:,2),1,Data').*200;
  Speed = abs(sy');
  for iTr = 1:nTr
    Speed(iTr,1:nt-1) = Speed(iTr,nt);
    Speed(iTr,end) = Speed(iTr,end-1);
  end
end

