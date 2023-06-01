

function [Eo , Gain]  = OpAmpNoise(B, Rs, en, in )

% returns Eo squared

%B = 750000 * pi / 2;
%Rs = 1000;
%en = 1.1e-9;
%in = 1.7e-12;

R2 = 4520;
R1 = 499;
Gain = (1 + R2 / R1);
e1 = sqrt(4 * 1.38e-23 * 300 * R1) * (R2 / R1);
e2 = sqrt(4 * 1.38e-23 * 300 * R2);

es = sqrt(4 * 1.38e-23 * 300 * Rs) * (1 + R2/R1);
Eo = ( (1 + R2 / R1)^2 * (en^2) + e1^2 + e2^2 + (in*R2)^2 + es^2 + ((in * Rs)^2) * ((1 + R2 / R1)^2)    ) * B;

