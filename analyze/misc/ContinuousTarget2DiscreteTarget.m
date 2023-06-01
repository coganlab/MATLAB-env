function target = ContinuousTarget2DiscreteTarget(continuous_target)
%
%  target = ContinuousTarget2DiscreteTarget(continuous_target)
%

phi = atan2(continuous_target(2),continuous_target(1));
phi(phi<0) = phi(phi<0)+2*pi;
phi(phi > 15*pi./8) = phi(phi > 15*pi./8) - 2*pi;

Direction = 0:pi/4:2*pi;

for iDir = 1:8
    if phi >= Direction(iDir)-pi./8 && phi < Direction(iDir)+pi./8
        target = iDir;
    end
end