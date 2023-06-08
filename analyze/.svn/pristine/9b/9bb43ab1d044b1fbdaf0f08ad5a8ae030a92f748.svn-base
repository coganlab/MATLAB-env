function [ val, gradval ] = nloglfVonMisesPoisson(params,data,cens,freq,xi)

% params = [ A B kappa mu ]
% data = observed firing rates
% cens, freq = censor/frequency vectors (unspecified)
% xi = angles associated with observed firing rates


%  Von Mises distributed tuning function
lambda  = @(params) params(1) + params(2).*exp(params(3)*cos(xi-params(4)));

% Negative log likelihood function
    val =  -sum(data.*log(lambda(params))-lambda(params));
    
% Gradients of the negative log likelihood function w.r.t. each parameter
gradval = [-sum( data./lambda(params) - 1) ... % grad A
           -sum((data./lambda(params) - 1).*exp(params(3).*cos(xi-params(4)))) ... % grad B
           -sum((data./lambda(params) - 1).*params(2).*cos(xi-params(4)).*exp(params(3).*cos(xi-params(4)))) ... % grad kappa
           -sum((data./lambda(params) - 1).*params(2).*params(3).*sin(xi-params(4)).*exp(params(3).*cos(xi-params(4)))) ];  % grad mu
