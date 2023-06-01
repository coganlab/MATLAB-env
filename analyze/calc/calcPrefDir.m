function [PD,phi] = calcPrefDir(F)
%
%  [PD,phi] = calcPrefDir(F)
%


% because PD is NaN if any F = -Inf
for i=1:length(F)
    if abs(F(i))>1000
        F(i)=0;
    end
end

Theta = [0:pi./4:7.*pi./4];
C = sum(F.*cos(Theta));
S = sum(F.*sin(Theta));

r = sqrt(C.^2+S.^2);
phi = atan2(S,C);
PD = phi2dir(phi);


