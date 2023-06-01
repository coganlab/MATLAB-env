function [logLR, Prob1, Prob2] = likLR_SVDSpectral(Spec, Spec1, Spec2)
%
% [logLR, Prob1, Prob2] = likLR_SVDSpectral(Spec, Spec1, Spec2) 
%

% Need to account for difference in variances 
% logLR = (sum(log(Prob1),1) - sum(log(Prob2),1));

logLR = sum(- ((Spec) - (Spec1)).^2 + ((Spec) - (Spec2)).^2,2);