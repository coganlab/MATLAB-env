function d = phi2dir(Phi);
%
%	d = phi2dir(Phi)
%

for iPhi = 1:length(Phi)
if Phi(iPhi)<0 Phi(iPhi) = Phi(iPhi)+2*pi; end

d(iPhi) = round(Phi(iPhi)./(pi./4));
if d(iPhi)==8 d(iPhi) = 0; end
end
d = d+1;
