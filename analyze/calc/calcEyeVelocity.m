    function Velocity = calcEyeVelocity(E,g)
%
%  Velocity = calcEyeVelocity(Eye, g)
%
%   Currently works for one trial

if nargin==1 [b,g]=sgolay(5,51); end
sy = filter(g(:,2),1,E').*1e3;
Velocity = sqrt(sum(sy'.^2));
Velocity(1:50) = Velocity(51);
