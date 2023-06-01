    function Velocity = calcMarkerVelocity(M,g)
%
%  Velocity = calcMarkerVelocity(M, g)
%
%   Currently works for one trial

if nargin==1 [b,g]=sgolay(5,11); end
nt = size(g,1);
sy = filter(g(:,2),1,M').*200;
Velocity = sy';
Velocity(1:nt-1) = Velocity(nt);
Velocity(end) = Velocity(end-1);
