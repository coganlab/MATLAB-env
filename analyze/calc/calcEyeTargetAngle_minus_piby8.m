function Angle = calcEyeTargetAngle_minus_piby8(Trials);
%
%  Angle = calcEyeTargetAngle_minus_piby8(Trials)
%
%	Returns angle of position of eye target for each trial
%	minus pi/8 to allow for bin boundaries to be shifted
%

E = getEyeTargetLocation(Trials);

Angle = atan2(E(:,2),E(:,1)) - pi/8;
