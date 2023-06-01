function [h, p] = corrcoef_test(r, n, alpha)
%
%  [h, p] = corrcoef_test(r, n, alpha)
%
%  Implements the hypothesis test for the null hypothesis
%  that rho = 0 against the alternative hypothesis that rho is not 0
%  following Zar (), p381.
%

if nargin < 3 alpha = 0.05; end

nu = n-2;
tcrit = abs(tinv(alpha./2,nu));

sr = sqrt((1-r.^2)./nu);

t = r./sr;

h = abs(t) > tcrit;

p = 1 - tcdf(abs(t),nu);
