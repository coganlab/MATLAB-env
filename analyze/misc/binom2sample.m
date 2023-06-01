function [D,phat,z,pvalue,CI,obsp] = binom2sample(x,n,y,m,alpha) 
% 2-sample binomial test. 
%
%  [D,phat,z,pvalue,CI,obsp]=binom2sample(x,n,y,m,alpha)
%
% Input: Sample 1: x successes in n trials 
% Sample 2: y successes in m trials 
% alpha level for CI, optional, 95% if not specified 
% Output: D=x/n-y/m; 
% phat= expected p value under the no-difference null hypothesis 
% z=test statistic 
% p value, 2-sided, for z statistic 
% CI (1-alpha) percentile for D;95% CI if alpha not specified. 
% obsp=obsrved proportions = [x/n y/m] 
% Based on Theorem 9.4.1, page 506 Larsen & Marx (2001, 3rd edition) and 
% Page 578 in Larsen & Marx (2006, 4th edition) Introduction to 
% Mathematical Statistics and for CI's Theorem 9.5.3 (p. 514) in Larsen & 
% Marx (2001, 3rd edition), Page 587 in Larsen & Marx (2006, 4th edition 
% Written by E. Gallagher; revised 12/19/10 

if x>n | y>m
    error('Successes can''t exceed number of trials') 
end

D = x/n-y/m; 
phat = (x+y)/(n+m); 
z = D/sqrt(phat*(1-phat)/n+phat*(1-phat)/m);

% Use Matlab stats toolbox normcdf for significance of z, 
% the standard normal variate 
% could use statbox normp.m or Gallagher's zprob.m or stixbox pnorm. 
if z>=0
    pvalue=2*(1-normcdf(z));
else
    pvalue=2*normcdf(z); 
end 
if nargin<5;
    alpha=0.05; 
end 
% Use Matlab's norminv. 
% Theorem 9.5.3 (p. 514); 
% n.b., the CI uses a different estimator for the standard deviation 
% to find CI's for the difference D 
HalfCI = norminv(1-alpha/2)*sqrt(((x/n)*(1-x/n)/n) +((y/m)*(1-y/m)/m)); 
CI = [D-HalfCI D+HalfCI]; 
obsp = [x/n y/m];
