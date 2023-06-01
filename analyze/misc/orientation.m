function [phi,r,p,ang,phi_B] = Orientation(X)
%   
%   [phi,r,p] = Orientation(X)
%

zi = interp2((X),3,'cubic');

[Fx,Fy] = gradient(zi);
r2 = sqrt(Fx.^2+Fy.^2);
ang = atan2(Fy,Fx);
angout = ang;
for i =1:size(ang,1)
    for j = 1:size(ang,2)
        if ang(i,j)<0
            ang(i,j) = ang(i,j) + 2*pi;
        end
    end
end
ang = ang*2;
px2 = cos(ang).*(r2);
py2 = sin(ang).*(r2);
PX = sum(sum(px2));
PY = sum(sum(py2));
phi = atan2(PY,PX);
r = sqrt(PX.^2+PY.^2);


    

%  Repeat analysis without interpolation to 
%  get right degrees of freedom for rayleigh test
[Fx,Fy] = gradient(X);
r2 = sqrt(Fx.^2+Fy.^2);
ang = atan2(Fy,Fx);
angout = ang;
for i =1:size(ang,1)
    for j = 1:size(ang,2)
        if ang(i,j)<0
            ang(i,j) = ang(i,j) + 2*pi;
        end
    end
end
ang = ang*2;

px2 = cos(ang).*(r2);
py2 = sin(ang).*(r2);

%  Bootstrap samples to estimate variability in phi
px2 = px2([1:prod(size(px2))]);
py2 = py2([1:prod(size(py2))]);
for i = 1:length(px2)
    ind = setdiff([1:length(px2)],i);
    PXb = sum(px2(ind));
    PYb = sum(py2(ind));
    phi_B(i) = atan2(PYb,PXb);
end





ind = find(ang>2*pi);
ang(ind) = ang(ind)-4*pi;
ang = ang./2;
[dum,rbar] = circ_mean(ang(:));
n = prod(size(ang));
% rn = rbar./n;
Z = n*rbar.^2;
p = exp(-Z) * (1 + (2*Z - Z^2) / (4*n) - (24*Z - 132*Z^2 + 76*Z^3 - 9*Z^4) / (288*n^2));
