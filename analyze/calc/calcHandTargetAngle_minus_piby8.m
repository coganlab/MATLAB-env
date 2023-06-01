function Angle = calcHandTargetAngle_minus_piby8(Trials);
%
%  Angle = calcHandTargetAngle_minus_piby8(Trials)
%
%	Returns angle of position of hand target for each trial
%

H = getHandTargetLocation(Trials);

Angle = atan2(H(:,2),H(:,1)) - pi/8;
