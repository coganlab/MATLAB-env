function [ val, gradval ] = nloglfBivariateCosVMPoisson(params,data,cens,freq,x)

% params = [ A B k1 m1 k2 m2 k3 ]
% data = observed firing rates
% cens, freq = censor/frequency vectors (unspecified)
% x = N by 2  set of angles associated with observed firing rates
%
%  From Mardia, Taylor and Subramaniam (2007) Biometrics 63, 505-512

xi = x(:,1);
yi = x(:,2);

%  Von Mises distributed tuning function
lambda  = @(params) params(1) + params(2).*exp(params(3)*cos(xi-params(4)) + params(5)*cos(yi-params(6)) - params(7)*cos(xi - params(4) - yi + params(6)));

% Negative log likelihood function
    val =  -sum(data.*log(lambda(params))-lambda(params));
    
% exponential term
expterm = exp(params(3)*cos(xi-params(4)) + params(5)*cos(yi-params(6)) - params(7)*cos(xi - params(4) - yi + params(6)));
% Gradients of the negative log likelihood function w.r.t. each parameter
gradA = -sum(data./lambda(params) - 1);
gradB = -sum((data./lambda(params) - 1).*expterm);
gradk1 = -sum((data./lambda(params) - 1).*params(2).*cos(xi-params(4)).*expterm); % grad k1
gradm1 = -sum((data./lambda(params) - 1).*params(2).*(params(3).*sin(xi-params(4)) - params(7).*sin(xi - params(4) - yi + params(6))).*expterm);  % grad m1
gradk2 = -sum((data./lambda(params) - 1).*params(2).*cos(yi-params(6)).*expterm);% grad k2
gradm2 = -sum((data./lambda(params) - 1).*params(2).*(params(5).*sin(yi-params(6)) + params(7).*sin(xi - params(4) - yi + params(6))).*expterm); % grad m2
gradk3 = -sum((data./lambda(params) - 1).*params(2).*cos(xi - params(4) - yi + params(6)).*expterm);% grad k3
gradval = [gradA, gradB, gradk1, gradm1, gradk2, gradm2, gradk3]; 
