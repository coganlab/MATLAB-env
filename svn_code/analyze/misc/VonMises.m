function y=VonMises(beta,x);
mu=beta(1);
kappa=beta(2);
B=beta(3);
A=beta(4);
Io=besseli(0,kappa);
y=A+B.*1./sqrt(2.*pi.*Io).*exp(kappa.*cos(x-mu));
