function [ val, gradval ] = nloglfBivariateAddVMPoisson(params,data,cens,freq,x)

% params = [ A B1 k1 mu1 B2 k2 mu2 ]
% data = observed firing rates, trial x 1.
% cens, freq = censor/frequency vectors (unspecified)
% x = angles associated with observed firing rates
%       This needs to be trial x angle.

xi = x(:,1);
yi = x(:,2);

%  Von Mises distributed tuning function
lambda  = @(params) params(1) + params(2).*exp(params(3)*cos(xi-params(4))) + params(5).*exp(params(6)*cos(yi-params(7)));

% Negative log likelihood function
    val =  -sum(data.*log(lambda(params))-lambda(params));
    
% Gradients of the negative log likelihood function w.r.t. each parameter
gradval = [-sum( data./lambda(params) - 1) ... % grad A
           -sum((data./lambda(params) - 1).*exp(params(3).*cos(xi-params(4)))) ... % grad B1
           -sum((data./lambda(params) - 1).*params(2).*cos(xi-params(4)).*exp(params(3).*cos(xi-params(4)))) ... % grad k1
           -sum((data./lambda(params) - 1).*params(2).*params(3).*sin(xi-params(4)).*exp(params(3).*cos(xi-params(4)))) ... %grad mu1
           -sum((data./lambda(params) - 1).*exp(params(6).*cos(yi-params(7)))) ... % grad B2
           -sum((data./lambda(params) - 1).*params(5).*cos(yi-params(7)).*exp(params(6).*cos(yi-params(7)))) ... % grad k2
           -sum((data./lambda(params) - 1).*params(5).*params(6).*sin(yi-params(7)).*exp(params(6).*cos(yi-params(7)))) ... %grad mu2
           ];  % end
