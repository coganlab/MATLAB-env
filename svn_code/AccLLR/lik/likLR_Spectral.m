function [logLR, Prob1, Prob2] = likLR_Spectral(Spec, Spec1, Spec2, DOF)
%
% [logLR, Prob1, Prob2] = likLR_Spectral(Spec, Spec1, Spec2, DOF) 
%

eps = 10.^(-10);
% 
 Prob1 = chi2pdf(DOF*Spec./Spec1, DOF).' + eps;
 Prob2 = chi2pdf(DOF*Spec./Spec2, DOF).' + eps;
% 
% logLR = (sum(log(Prob1),1) - sum(log(Prob2),1));

logLR = sum(- ((Spec) - (Spec1)).^2 + ((Spec) - (Spec2)).^2,2);