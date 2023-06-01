function Angle = calcHandTargetAngle(Trials);
%
%  Angle = calcHandTargetAngle(Trials)
%
%	Returns angle of position of hand target for each trial
%

H = getHandTargetLocation(Trials);

Angle = atan2(H(:,2),H(:,1));
Angle = Angle';
