function RotatedAngle = rotateAngle(Angle, Theta)
%
%  RotatedAngle = rotateAngle(Angle, Theta)
%
%	Angles are assumed to be in radians
%	RotatedAngle = Angle - Theta;
%	Angles are assumed to be in the range -pi,pi.

RotatedAngle = Angle-Theta;
RotatedAngle(RotatedAngle < -pi) = RotatedAngle(RotatedAngle<-pi)+2*pi;;
RotatedAngle(RotatedAngle > pi) = RotatedAngle(RotatedAngle>pi)-2*pi;;
