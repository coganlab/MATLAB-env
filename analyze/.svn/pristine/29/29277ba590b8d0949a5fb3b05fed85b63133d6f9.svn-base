    function Speed = calcMarkerSpeed(Data,Filter)
%
%  Speed = calcMarkerSpeed(Data, Filter)
%
%   INPUTS:  DATA = Array.  [Trial,Dimension,Time] or [Dimension,Time] if 1 trial.
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

if length(size(Data))==2 % one trial
  sy = filter(Filter(:,2),1,Data').*200;
  Velocity = sqrt(sum(sy'.^2));
  Velocity(1:nt-1) = Velocity(nt);
  Velocity(end) = Velocity(end-1);
else
  nTr = size(Data,1) ; nT = size(Data,3);
  Velocity = zeros(nTr,nT)
  for iTr = 1:nTr
    sy = filter(Filter(:,2),1,sq(Data(iTr,:,:))').*200;
    Velocity(iTr,:) = sqrt(sum(sy'.^2));
    Velocity(iTr,1:nt-1) = Velocity(iTr,nt);
    Velocity(iTr,end) = Velocity(iTr,end-1);
  end
end

Speed = Velocity;
