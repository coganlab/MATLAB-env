function y = fnVonMises(xi, params)
%
%  y = fnVonMises(xtest, params)
%
%  y = params(1) + params(2).*exp(params(3)*(cos(xi-params(4))));

y = params(1) + params(2).*exp(params(3)*(cos(xi-params(4))));