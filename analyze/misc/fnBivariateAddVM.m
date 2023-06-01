function y = fnBivariateAddVM(xtest, params)
%
%  y = fnBivariateAddVM(xtest, params)
%
%  y = params(1) + params(2).*exp(params(3)*cos(xi-params(4))) + params(5).*exp(params(6)*cos(xyi-params(7)));
% xtest needs to be trial x angle and contains xi for xtest(:,1) and yi for
% xtest(:,2).


xi = xtest(:,1);
yi = xtest(:,2);

y = params(1) + params(2).*exp(params(3)*(cos(xi-params(4)))) + ...
    params(5).*exp(params(6)*(cos(yi-params(7))));