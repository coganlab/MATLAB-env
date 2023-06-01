function [ val, gradval ] = nloglfConstantPoisson(params,data,cens,freq,xi)

% params = [ A ]
% data = observed firing rates
% cens, freq = censor/frequency vectors (unspecified)
% xi = angles associated with observed firing rates


%  Poisson distributed Constant tuning function
lambda  = @(params) params(1) ;

% Negative log likelihood function
    val =  -sum(data.*log(lambda(params))-lambda(params));
    
% Gradients of the negative log likelihood function w.r.t. each parameter
gradval = [-sum( data./lambda(params) - 1)]; % grad A
