function Angle = calcEyeTargetAngle(Trials);
%
%  Angle = calcEyeTargetAngle(Trials)
%
%	Returns angle of position of eye target for each trial
%

E = getEyeTargetLocation(Trials);

Angle = atan2(E(:,2),E(:,1));
Angle = Angle';
