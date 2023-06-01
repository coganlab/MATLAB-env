function y=Gauss(beta,x);
mu=beta(1);
sigma=beta(2);
B=beta(3);
A=beta(4);
y=A+B.*1./sqrt(2.*pi.*sigma.^2).*exp(-(x-mu).^2./(2.*sigma.^2));
