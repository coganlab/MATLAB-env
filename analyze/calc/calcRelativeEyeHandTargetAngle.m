function RelEH = calcRelativeEyeHandTargetAngle(Trials)
%
%  RelEH = calcRelativeEyeHandTargetAngle(Trials)
%

EyeTargetAngle = calcEyeTargetAngle(Trials);
HandTargetAngle = calcHandTargetAngle(Trials);

RelEH = EyeTargetAngle - HandTargetAngle;

RelEH(RelEH > pi) = RelEH(RelEH > pi) - 2*pi;
RelEH(RelEH < -pi) = RelEH(RelEH < -pi) + 2*pi;
